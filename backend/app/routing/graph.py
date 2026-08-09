class RoadGraph:
    def __init__(self):
        self._edges = {}
        self._coordinates = {}

    def add_node(self, node_id, latitude, longitude):
        self._coordinates[node_id] = (
            latitude,
            longitude,
        )

        if node_id not in self._edges:
            self._edges[node_id] = []

    def add_edge(
        self,
        from_node,
        to_node,
        base_cost,
        bidirectional=True,
        road_id=None,
    ):
        if from_node not in self._edges:
            self._edges[from_node] = []

        if to_node not in self._edges:
            self._edges[to_node] = []

        edge = {
            "to": to_node,
            "base_cost": float(base_cost),
            "road_id": road_id,
            "blocked": False,
            "penalty_multiplier": 1.0,
        }

        self._edges[from_node].append(edge)

        if bidirectional:
            reverse_edge = {
                "to": from_node,
                "base_cost": float(base_cost),
                "road_id": road_id,
                "blocked": False,
                "penalty_multiplier": 1.0,
            }

            self._edges[to_node].append(reverse_edge)

    def get_neighbors(self, node_id):
        return self._edges.get(node_id, [])

    def get_coordinates(self, node_id):
        return self._coordinates.get(node_id)

    def get_nodes(self):
        return list(self._edges.keys())

    def block_road(self, road_id):
        for edges in self._edges.values():
            for edge in edges:
                if edge["road_id"] == road_id:
                    edge["blocked"] = True

    def unblock_road(self, road_id):
        for edges in self._edges.values():
            for edge in edges:
                if edge["road_id"] == road_id:
                    edge["blocked"] = False

    def apply_penalty(
        self,
        road_id,
        multiplier,
    ):
        for edges in self._edges.values():
            for edge in edges:
                if edge["road_id"] == road_id:
                    edge["penalty_multiplier"] = float(
                        multiplier,
                    )

    def clear_penalty(self, road_id):
        for edges in self._edges.values():
            for edge in edges:
                if edge["road_id"] == road_id:
                    edge["penalty_multiplier"] = 1.0

    def get_edge_cost(self, edge):
        if edge["blocked"]:
            return float("inf")

        return (
            edge["base_cost"]
            * edge["penalty_multiplier"]
        )