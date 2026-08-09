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

    def get_coordinates(
        self,
        node_id,
    ):
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

    def get_neighbors(
        self,
        node_id,
    ):
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

    def get_edge_cost(
        self,
        edge,
    ):
        return (
            edge["travel_time"]
            + edge.get(
                "penalty",
                0.0,
            )
        )

    def find_nearest_node(
        self,
        latitude,
        longitude,
    ):
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