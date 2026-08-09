from __future__ import annotations

import math
import sys
from pathlib import Path

import networkx as nx
import osmium


# ============================================================
# PROJECT PATHS
# ============================================================

BACKEND_DIR = Path(__file__).resolve().parent.parent

RAW_DIR = BACKEND_DIR / "data" / "raw"
NASHIK_DIR = BACKEND_DIR / "data" / "nashik"
GRAPHS_DIR = BACKEND_DIR / "data" / "graphs"

OUTPUT_GRAPH = GRAPHS_DIR / "nashik_road_graph.graphml"


# ============================================================
# NASHIK CITY BOUNDING BOX
#
# These coordinates intentionally cover a larger Nashik urban
# area rather than only the central city.
#
# west, south, east, north
# ============================================================

NASHIK_WEST = 73.60
NASHIK_SOUTH = 19.78
NASHIK_EAST = 74.05
NASHIK_NORTH = 20.15


# ============================================================
# ROAD SETTINGS
# ============================================================

ALLOWED_HIGHWAYS = {
    "motorway",
    "trunk",
    "primary",
    "secondary",
    "tertiary",
    "unclassified",
    "residential",
    "living_street",
    "service",
    "motorway_link",
    "trunk_link",
    "primary_link",
    "secondary_link",
    "tertiary_link",
}


DEFAULT_SPEED_KMH = {
    "motorway": 80,
    "trunk": 70,
    "primary": 60,
    "secondary": 50,
    "tertiary": 40,
    "unclassified": 35,
    "residential": 30,
    "living_street": 15,
    "service": 20,
    "motorway_link": 40,
    "trunk_link": 40,
    "primary_link": 35,
    "secondary_link": 30,
    "tertiary_link": 25,
}


# ============================================================
# HELPERS
# ============================================================

def print_header(title: str) -> None:
    print()
    print("=" * 60)
    print(title)
    print("=" * 60)


def is_inside_nashik(latitude: float, longitude: float) -> bool:
    return (
        NASHIK_SOUTH <= latitude <= NASHIK_NORTH
        and NASHIK_WEST <= longitude <= NASHIK_EAST
    )


def haversine_distance_meters(
    latitude_1: float,
    longitude_1: float,
    latitude_2: float,
    longitude_2: float,
) -> float:
    radius = 6_371_000.0

    lat_1 = math.radians(latitude_1)
    lon_1 = math.radians(longitude_1)
    lat_2 = math.radians(latitude_2)
    lon_2 = math.radians(longitude_2)

    delta_lat = lat_2 - lat_1
    delta_lon = lon_2 - lon_1

    a = (
        math.sin(delta_lat / 2) ** 2
        + math.cos(lat_1)
        * math.cos(lat_2)
        * math.sin(delta_lon / 2) ** 2
    )

    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))

    return radius * c


def parse_speed_kmh(value: str | None, default_speed: float) -> float:
    if not value:
        return default_speed

    cleaned = value.strip().lower()

    try:
        if ";" in cleaned:
            cleaned = cleaned.split(";")[0].strip()

        if "mph" in cleaned:
            number = float(
                cleaned.replace("mph", "").strip()
            )
            return number * 1.60934

        cleaned = (
            cleaned
            .replace("km/h", "")
            .replace("kph", "")
            .strip()
        )

        return float(cleaned)

    except (TypeError, ValueError):
        return default_speed


def is_oneway(tags) -> bool:
    oneway = tags.get("oneway", "").strip().lower()

    if oneway in {"yes", "true", "1"}:
        return True

    if tags.get("junction", "").strip().lower() == "roundabout":
        return True

    return False


def is_reverse_oneway(tags) -> bool:
    return tags.get("oneway", "").strip() == "-1"


# ============================================================
# PASS 1
# FIND ALL OSM NODES INSIDE NASHIK
# ============================================================

class NashikNodeFinder(osmium.SimpleHandler):
    def __init__(self) -> None:
        super().__init__()
        self.node_ids: set[int] = set()

    def node(self, node) -> None:
        if not node.location.valid():
            return

        latitude = node.location.lat
        longitude = node.location.lon

        if is_inside_nashik(latitude, longitude):
            self.node_ids.add(node.id)


# ============================================================
# PASS 2
# FIND ROAD WAYS CONNECTED TO NASHIK NODES
# ============================================================

class NashikRoadWayFinder(osmium.SimpleHandler):
    def __init__(
        self,
        nashik_node_ids: set[int],
    ) -> None:
        super().__init__()

        self.nashik_node_ids = nashik_node_ids

        self.road_ways: list[dict] = []
        self.required_node_ids: set[int] = set()

    def way(self, way) -> None:
        highway = way.tags.get("highway")

        if highway not in ALLOWED_HIGHWAYS:
            return

        node_refs = [
            node.ref
            for node in way.nodes
        ]

        if len(node_refs) < 2:
            return

        intersects_nashik = any(
            node_id in self.nashik_node_ids
            for node_id in node_refs
        )

        if not intersects_nashik:
            return

        self.road_ways.append(
            {
                "id": way.id,
                "nodes": node_refs,
                "highway": highway,
                "name": way.tags.get("name", ""),
                "oneway": is_oneway(way.tags),
                "reverse_oneway": is_reverse_oneway(way.tags),
                "maxspeed": way.tags.get("maxspeed"),
            }
        )

        self.required_node_ids.update(node_refs)


# ============================================================
# PASS 3
# EXTRACT COORDINATES FOR REQUIRED ROAD NODES
# ============================================================

class RequiredNodeExtractor(osmium.SimpleHandler):
    def __init__(
        self,
        required_node_ids: set[int],
    ) -> None:
        super().__init__()

        self.required_node_ids = required_node_ids

        self.coordinates: dict[
            int,
            tuple[float, float],
        ] = {}

    def node(self, node) -> None:
        if node.id not in self.required_node_ids:
            return

        if not node.location.valid():
            return

        self.coordinates[node.id] = (
            node.location.lat,
            node.location.lon,
        )


# ============================================================
# GRAPH BUILDER
# ============================================================

def add_graph_node(
    graph: nx.MultiDiGraph,
    node_id: int,
    coordinates: dict[int, tuple[float, float]],
) -> None:
    if node_id in graph:
        return

    latitude, longitude = coordinates[node_id]

    graph.add_node(
        str(node_id),
        latitude=float(latitude),
        longitude=float(longitude),
        x=float(longitude),
        y=float(latitude),
    )


def add_road_edge(
    graph: nx.MultiDiGraph,
    source_id: int,
    target_id: int,
    *,
    distance: float,
    highway: str,
    name: str,
    speed_kmh: float,
    osmid: int,
) -> None:
    if speed_kmh <= 0:
        speed_kmh = DEFAULT_SPEED_KMH.get(
            highway,
            30,
        )

    travel_time_seconds = (
        distance / (speed_kmh * 1000 / 3600)
    )

    graph.add_edge(
        str(source_id),
        str(target_id),
        length=float(distance),
        travel_time=float(travel_time_seconds),
        weight=float(travel_time_seconds),
        highway=str(highway),
        name=str(name),
        maxspeed=float(speed_kmh),
        osmid=str(osmid),
    )


def build_graph(
    road_ways: list[dict],
    coordinates: dict[int, tuple[float, float]],
) -> nx.MultiDiGraph:
    graph = nx.MultiDiGraph()

    skipped_ways = 0
    skipped_segments = 0

    total_ways = len(road_ways)

    for index, road in enumerate(
        road_ways,
        start=1,
    ):
        if index % 10_000 == 0:
            print(
                f"Processing ways: "
                f"{index:,}/{total_ways:,}"
            )

        node_refs = road["nodes"]

        highway = road["highway"]

        default_speed = DEFAULT_SPEED_KMH.get(
            highway,
            30,
        )

        speed_kmh = parse_speed_kmh(
            road["maxspeed"],
            default_speed,
        )

        valid_segments = 0

        for source_id, target_id in zip(
            node_refs,
            node_refs[1:],
        ):
            if (
                source_id not in coordinates
                or target_id not in coordinates
            ):
                skipped_segments += 1
                continue

            source_lat, source_lon = coordinates[source_id]
            target_lat, target_lon = coordinates[target_id]

            distance = haversine_distance_meters(
                source_lat,
                source_lon,
                target_lat,
                target_lon,
            )

            if distance <= 0:
                continue

            add_graph_node(
                graph,
                source_id,
                coordinates,
            )

            add_graph_node(
                graph,
                target_id,
                coordinates,
            )

            if road["reverse_oneway"]:
                add_road_edge(
                    graph,
                    target_id,
                    source_id,
                    distance=distance,
                    highway=highway,
                    name=road["name"],
                    speed_kmh=speed_kmh,
                    osmid=road["id"],
                )

            elif road["oneway"]:
                add_road_edge(
                    graph,
                    source_id,
                    target_id,
                    distance=distance,
                    highway=highway,
                    name=road["name"],
                    speed_kmh=speed_kmh,
                    osmid=road["id"],
                )

            else:
                add_road_edge(
                    graph,
                    source_id,
                    target_id,
                    distance=distance,
                    highway=highway,
                    name=road["name"],
                    speed_kmh=speed_kmh,
                    osmid=road["id"],
                )

                add_road_edge(
                    graph,
                    target_id,
                    source_id,
                    distance=distance,
                    highway=highway,
                    name=road["name"],
                    speed_kmh=speed_kmh,
                    osmid=road["id"],
                )

            valid_segments += 1

        if valid_segments == 0:
            skipped_ways += 1

    print()
    print(f"Skipped ways: {skipped_ways:,}")
    print(f"Skipped segments: {skipped_segments:,}")

    return graph


# ============================================================
# MAIN
# ============================================================

def main() -> None:
    print_header(
        "THE MAP PROJECT - NASHIK ROAD GRAPH BUILDER"
    )

    print(f"Backend directory: {BACKEND_DIR}")
    print(f"Raw directory: {RAW_DIR}")
    print(f"Output directory: {GRAPHS_DIR}")

    print()
    print("Nashik bounding box:")
    print(
        f"South: {NASHIK_SOUTH}, "
        f"North: {NASHIK_NORTH}"
    )
    print(
        f"West:  {NASHIK_WEST}, "
        f"East:  {NASHIK_EAST}"
    )

    NASHIK_DIR.mkdir(
        parents=True,
        exist_ok=True,
    )

    GRAPHS_DIR.mkdir(
        parents=True,
        exist_ok=True,
    )

    pbf_files = sorted(
        RAW_DIR.glob("*.osm.pbf"),
        key=lambda path: path.stat().st_mtime,
        reverse=True,
    )

    if not pbf_files:
        print()
        print("ERROR: No .osm.pbf file found in:")
        print(RAW_DIR)
        sys.exit(1)

    input_file = pbf_files[0]

    print()
    print(
        f"Using input file: "
        f"{input_file.name}"
    )

    print(
        f"File size: "
        f"{input_file.stat().st_size / 1024 / 1024:.2f} MB"
    )

    # --------------------------------------------------------
    # PASS 1
    # --------------------------------------------------------

    print_header(
        "PASS 1 - FINDING NASHIK NODES"
    )

    node_finder = NashikNodeFinder()

    node_finder.apply_file(
        str(input_file),
        locations=False,
    )

    nashik_node_ids = node_finder.node_ids

    print(
        f"Nashik nodes found: "
        f"{len(nashik_node_ids):,}"
    )

    if not nashik_node_ids:
        print()
        print(
            "ERROR: No nodes found inside "
            "the Nashik bounding box."
        )
        sys.exit(1)

    # --------------------------------------------------------
    # PASS 2
    # --------------------------------------------------------

    print_header(
        "PASS 2 - FINDING NASHIK ROAD WAYS"
    )

    road_finder = NashikRoadWayFinder(
        nashik_node_ids,
    )

    road_finder.apply_file(
        str(input_file),
        locations=False,
    )

    road_ways = road_finder.road_ways
    required_node_ids = (
        road_finder.required_node_ids
    )

    print(
        f"Road ways found: "
        f"{len(road_ways):,}"
    )

    print(
        f"Required road nodes: "
        f"{len(required_node_ids):,}"
    )

    if not road_ways:
        print()
        print(
            "ERROR: No usable road ways found."
        )
        sys.exit(1)

    # --------------------------------------------------------
    # PASS 3
    # --------------------------------------------------------

    print_header(
        "PASS 3 - EXTRACTING ROAD NODE COORDINATES"
    )

    node_extractor = RequiredNodeExtractor(
        required_node_ids,
    )

    node_extractor.apply_file(
        str(input_file),
        locations=False,
    )

    coordinates = (
        node_extractor.coordinates
    )

    print(
        f"Coordinates extracted: "
        f"{len(coordinates):,}"
    )

    if not coordinates:
        print()
        print(
            "ERROR: No road node coordinates extracted."
        )
        sys.exit(1)

    # --------------------------------------------------------
    # BUILD GRAPH
    # --------------------------------------------------------

    print_header(
        "BUILDING NETWORKX ROAD GRAPH"
    )

    graph = build_graph(
        road_ways,
        coordinates,
    )

    print()
    print(
        f"Graph nodes: "
        f"{graph.number_of_nodes():,}"
    )

    print(
        f"Graph edges: "
        f"{graph.number_of_edges():,}"
    )

    if graph.number_of_nodes() == 0:
        print()
        print(
            "ERROR: Graph contains no nodes."
        )
        sys.exit(1)

    # --------------------------------------------------------
    # GRAPH METADATA
    # --------------------------------------------------------

    graph.graph["name"] = (
        "Nashik Road Network"
    )

    graph.graph["city"] = "Nashik"

    graph.graph["source"] = (
        input_file.name
    )

    graph.graph["weight"] = (
        "travel_time"
    )

    graph.graph["algorithm"] = (
        "Custom A* compatible"
    )

    # --------------------------------------------------------
    # SAVE
    # --------------------------------------------------------

    print_header(
        "SAVING ROAD GRAPH"
    )

    nx.write_graphml(
        graph,
        OUTPUT_GRAPH,
    )

    print(
        f"Graph saved successfully:"
    )

    print(OUTPUT_GRAPH)

    print(
        f"Output size: "
        f"{OUTPUT_GRAPH.stat().st_size / 1024 / 1024:.2f} MB"
    )

    print_header(
        "NASHIK ROAD GRAPH BUILD COMPLETE"
    )


if __name__ == "__main__":
    main()