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

    def sync_active_events(self, restrictions):
        """
        Synchronizes active road restrictions (closures and penalties)
        into the in-memory NashikRoadGraph.

        restrictions: List of ActiveSegmentRestriction or dicts with keys:
          - osm_way_id
          - is_closed
          - penalty_seconds
        """
        if self.graph_manager.graph is None:
            raise RuntimeError("Graph has not been loaded. Call load() first.")

        # Always start from clean state to avoid accumulating stale restrictions
        self.graph_manager.clear_dynamic_events()

        blocked_ways = 0
        penalized_ways = 0

        for item in restrictions:
            if hasattr(item, "osm_way_id"):
                osm_way_id = item.osm_way_id
                is_closed = item.is_closed
                penalty_seconds = item.penalty_seconds
            else:
                osm_way_id = item.get("osm_way_id")
                is_closed = item.get("is_closed", False)
                penalty_seconds = float(item.get("penalty_seconds", 0.0))

            if not osm_way_id:
                continue

            if is_closed:
                count = self.graph_manager.block_osm_way(osm_way_id)
                if count > 0:
                    blocked_ways += 1
            elif penalty_seconds > 0:
                count = self.graph_manager.apply_penalty_to_osm_way(
                    osm_way_id,
                    penalty_seconds,
                )
                if count > 0:
                    penalized_ways += 1

        return {
            "total_restrictions_processed": len(restrictions),
            "blocked_ways_applied": blocked_ways,
            "penalized_ways_applied": penalized_ways,
        }

    def find_nearest_osm_way(self, latitude, longitude):
        """
        Finds the nearest OSM way in the graph to the specified coordinates.
        """
        if self.graph_manager.graph is None:
            raise RuntimeError("Graph has not been loaded. Call load() first.")

        return self.graph_manager.find_nearest_osm_way(
            latitude=latitude,
            longitude=longitude,
        )