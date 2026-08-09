from app.routing.astar import AStarRouter
from app.routing.nashik_graph import NashikRoadGraph


class RealNashikRouter:
    def __init__(self):
        self.graph_manager = NashikRoadGraph()
        self.router = None

    def load(self):
        self.graph_manager.load()

        self.router = AStarRouter(
            self.graph_manager
        )

        return self

    def find_route(
        self,
        start_latitude,
        start_longitude,
        end_latitude,
        end_longitude,
    ):
        if self.router is None:
            raise RuntimeError(
                "Router has not been loaded. "
                "Call load() first."
            )

        start_node = (
            self.graph_manager.find_nearest_node(
                start_latitude,
                start_longitude,
            )
        )

        end_node = (
            self.graph_manager.find_nearest_node(
                end_latitude,
                end_longitude,
            )
        )

        print()
        print("Nearest start node:")
        print(start_node)

        print()
        print("Nearest destination node:")
        print(end_node)

        result = self.router.find_route(
            start_node,
            end_node,
        )

        if result is None:
            return None

        path = result["path"]

        coordinates = []

        for node_id in path:
            coordinate = (
                self.graph_manager.get_coordinates(
                    node_id
                )
            )

            if coordinate is not None:
                coordinates.append(
                    {
                        "latitude": coordinate[0],
                        "longitude": coordinate[1],
                    }
                )

        return {
            "start_node": start_node,
            "end_node": end_node,
            "path": path,
            "coordinates": coordinates,
            "total_cost": result["total_cost"],
        }