import math
from pathlib import Path

import networkx as nx


BACKEND_DIR = Path(__file__).resolve().parent.parent.parent

GRAPH_FILE = (
    BACKEND_DIR
    / "data"
    / "graphs"
    / "nashik_road_graph.graphml"
)


class NashikRoadGraph:
    def __init__(self):
        self.graph = None
        self._nodes = set()
        self._edge_events = {}

    def load(self):
        if not GRAPH_FILE.exists():
            raise FileNotFoundError(
                f"Road graph not found: {GRAPH_FILE}"
            )

        print("Loading Nashik road graph...")

        self.graph = nx.read_graphml(
            GRAPH_FILE,
            force_multigraph=True,
        )

        self._nodes = set(self.graph.nodes())

        print(
            f"Graph loaded successfully: "
            f"{self.graph.number_of_nodes():,} nodes, "
            f"{self.graph.number_of_edges():,} edges"
        )

        return self

    def get_nodes(self):
        if self.graph is None:
            raise RuntimeError(
                "Graph has not been loaded."
            )

        return self._nodes

    def get_coordinates(self, node_id):
        if self.graph is None:
            raise RuntimeError(
                "Graph has not been loaded."
            )

        if node_id not in self.graph:
            return None

        data = self.graph.nodes[node_id]

        try:
            return (
                float(data["latitude"]),
                float(data["longitude"]),
            )
        except (
            KeyError,
            TypeError,
            ValueError,
        ):
            return None

    def get_neighbors(self, node_id):
        if self.graph is None:
            raise RuntimeError(
                "Graph has not been loaded."
            )

        neighbors = []

        for source, target, key, data in self.graph.out_edges(
            node_id,
            keys=True,
            data=True,
        ):
            try:
                travel_time = float(
                    data.get(
                        "travel_time",
                        0,
                    )
                )

                length = float(
                    data.get(
                        "length",
                        0,
                    )
                )
            except (
                TypeError,
                ValueError,
            ):
                continue

            if travel_time <= 0:
                continue

            event = self._edge_events.get(
                (
                    str(source),
                    str(target),
                    str(key),
                ),
                {},
            )

            neighbors.append(
                {
                    "to": target,
                    "key": key,
                    "travel_time": travel_time,
                    "length": length,
                    "blocked": event.get(
                        "blocked",
                        False,
                    ),
                    "penalty": event.get(
                        "penalty",
                        0.0,
                    ),
                }
            )

        return neighbors

    def get_edge_cost(self, edge):
        return (
            edge["travel_time"]
            + edge.get(
                "penalty",
                0.0,
            )
        )

    def find_nearest_node(self, latitude, longitude):
        if self.graph is None:
            raise RuntimeError(
                "Graph has not been loaded."
            )

        latitude = float(latitude)
        longitude = float(longitude)

        nearest_node = None
        nearest_distance = float("inf")

        for node_id, data in self.graph.nodes(
            data=True,
        ):
            try:
                node_latitude = float(
                    data["latitude"]
                )

                node_longitude = float(
                    data["longitude"]
                )
            except (
                KeyError,
                TypeError,
                ValueError,
            ):
                continue

            latitude_difference = (
                node_latitude - latitude
            )

            longitude_difference = (
                node_longitude - longitude
            )

            distance = (
                latitude_difference ** 2
                + longitude_difference ** 2
            )

            if distance < nearest_distance:
                nearest_distance = distance
                nearest_node = node_id

        if nearest_node is None:
            raise RuntimeError(
                "Could not find a nearby road node."
            )

        return nearest_node

    def apply_penalty_to_edge(
        self,
        source,
        target,
        key,
        penalty,
    ):
        edge_id = (
            str(source),
            str(target),
            str(key),
        )

        self._edge_events[edge_id] = {
            "blocked": False,
            "penalty": float(penalty),
        }

    def block_edge(
        self,
        source,
        target,
        key,
    ):
        edge_id = (
            str(source),
            str(target),
            str(key),
        )

        self._edge_events[edge_id] = {
            "blocked": True,
            "penalty": 0.0,
        }

    def clear_dynamic_events(self):
        self._edge_events.clear()

    def get_edge_between_nodes(
        self,
        source,
        target,
    ):
        if self.graph is None:
            raise RuntimeError(
                "Graph has not been loaded."
            )

        edge_data = self.graph.get_edge_data(
            source,
            target,
        )

        if not edge_data:
            return None

        best_key = None
        best_data = None
        best_travel_time = float("inf")

        for key, data in edge_data.items():
            try:
                travel_time = float(
                    data.get(
                        "travel_time",
                        float("inf"),
                    )
                )
            except (
                TypeError,
                ValueError,
            ):
                continue

            if travel_time < best_travel_time:
                best_travel_time = travel_time
                best_key = key
                best_data = data

        if best_key is None:
            return None

        return {
            "source": source,
            "target": target,
            "key": best_key,
            "data": best_data,
        }

    def get_edges_by_osm_way_id(
        self,
        osm_way_id,
    ):
        """
        Find every graph edge belonging to
        the specified OSM way.

        The GraphML stores OSM way IDs as strings.
        """

        if self.graph is None:
            raise RuntimeError(
                "Graph has not been loaded."
            )

        osm_way_id = str(osm_way_id)

        matching_edges = []

        for source, target, key, data in self.graph.edges(
            keys=True,
            data=True,
        ):
            graph_osmid = data.get("osmid")

            if graph_osmid is None:
                continue

            if str(graph_osmid) != osm_way_id:
                continue

            matching_edges.append(
                {
                    "source": source,
                    "target": target,
                    "key": key,
                }
            )

        return matching_edges

    def block_osm_way(
        self,
        osm_way_id,
    ):
        """
        Block every graph edge associated with
        an OSM way ID.

        Returns the number of blocked edges.
        """

        matching_edges = (
            self.get_edges_by_osm_way_id(
                osm_way_id
            )
        )

        for edge in matching_edges:
            self.block_edge(
                source=edge["source"],
                target=edge["target"],
                key=edge["key"],
            )

        return len(matching_edges)

    def apply_penalty_to_osm_way(
        self,
        osm_way_id,
        penalty,
    ):
        """
        Apply a travel-time penalty to every
        graph edge associated with an OSM way ID.

        Returns the number of affected edges.
        """

        matching_edges = (
            self.get_edges_by_osm_way_id(
                osm_way_id
            )
        )

        for edge in matching_edges:
            self.apply_penalty_to_edge(
                source=edge["source"],
                target=edge["target"],
                key=edge["key"],
                penalty=penalty,
            )

        return len(matching_edges)

    def find_nearest_osm_way(
        self,
        latitude,
        longitude,
        max_candidates=15,
    ):
        """
        Resolve the nearest road edge / OSM way to a geographic coordinate (lat, lon).
        Calculates perpendicular distance to candidate edge line segments.
        Returns a dict containing osm_way_id, distance_meters, name, highway, etc.
        """
        if self.graph is None:
            raise RuntimeError("Graph has not been loaded.")

        lat = float(latitude)
        lon = float(longitude)

        # Collect candidate nearest nodes
        node_dists = []
        for nid, data in self.graph.nodes(data=True):
            try:
                nlat = float(data["latitude"])
                nlon = float(data["longitude"])
            except (KeyError, TypeError, ValueError):
                continue
            d_sq = (nlat - lat) ** 2 + (nlon - lon) ** 2
            node_dists.append((d_sq, nid))

        node_dists.sort(key=lambda item: item[0])
        candidates = node_dists[:max_candidates]

        cos_lat = math.cos(math.radians(20.0))
        best_edge = None
        min_dist = float("inf")
        checked_edges = set()

        for _, nid in candidates:
            incident_edges = list(
                self.graph.out_edges(nid, keys=True, data=True)
            ) + list(self.graph.in_edges(nid, keys=True, data=True))

            for u, v, k, d in incident_edges:
                edge_key = (str(u), str(v), str(k))
                if edge_key in checked_edges:
                    continue
                checked_edges.add(edge_key)

                osmid = d.get("osmid")
                if not osmid:
                    continue

                try:
                    u_data = self.graph.nodes[u]
                    v_data = self.graph.nodes[v]
                    u_lat = float(u_data["latitude"])
                    u_lon = float(u_data["longitude"])
                    v_lat = float(v_data["latitude"])
                    v_lon = float(v_data["longitude"])
                except (KeyError, TypeError, ValueError):
                    continue

                # Project point to segment in approximate local meters
                px_m = (lon - u_lon) * 111320.0 * cos_lat
                py_m = (lat - u_lat) * 110540.0
                vx_m = (v_lon - u_lon) * 111320.0 * cos_lat
                vy_m = (v_lat - u_lat) * 110540.0

                seg_len_sq = vx_m * vx_m + vy_m * vy_m
                if seg_len_sq == 0:
                    dist = math.sqrt(px_m * px_m + py_m * py_m)
                else:
                    t = max(0.0, min(1.0, (px_m * vx_m + py_m * vy_m) / seg_len_sq))
                    dist_x = px_m - (vx_m * t)
                    dist_y = py_m - (vy_m * t)
                    dist = math.sqrt(dist_x * dist_x + dist_y * dist_y)

                if dist < min_dist:
                    min_dist = dist
                    best_edge = {
                        "osm_way_id": int(osmid),
                        "distance_meters": round(dist, 2),
                        "name": str(d.get("name") or ""),
                        "highway": str(d.get("highway") or ""),
                        "source_node": str(u),
                        "target_node": str(v),
                        "speed_limit": d.get("maxspeed"),
                    }

        return best_edge