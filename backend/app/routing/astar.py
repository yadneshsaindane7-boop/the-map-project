import heapq
import math


class AStarRouter:
    def __init__(self, graph):
        self.graph = graph

    def _heuristic(
        self,
        current_node,
        goal_node,
    ):
        current = self.graph.get_coordinates(
            current_node,
        )

        goal = self.graph.get_coordinates(
            goal_node,
        )

        if current is None or goal is None:
            return 0.0

        latitude_difference = (
            current[0] - goal[0]
        )

        longitude_difference = (
            current[1] - goal[1]
        )

        straight_line_distance = math.sqrt(
            latitude_difference ** 2
            + longitude_difference ** 2
        )

        return straight_line_distance

    def find_route(
        self,
        start_node,
        goal_node,
    ):
        if start_node not in self.graph.get_nodes():
            raise ValueError(
                f"Start node does not exist: "
                f"{start_node}"
            )

        if goal_node not in self.graph.get_nodes():
            raise ValueError(
                f"Goal node does not exist: "
                f"{goal_node}"
            )

        open_set = []

        heapq.heappush(
            open_set,
            (
                0.0,
                start_node,
            ),
        )

        came_from = {}

        g_score = {
            start_node: 0.0,
        }

        visited = set()

        while open_set:
            _, current_node = heapq.heappop(
                open_set,
            )

            if current_node in visited:
                continue

            if current_node == goal_node:
                return self._reconstruct_route(
                    came_from,
                    current_node,
                    g_score[current_node],
                )

            visited.add(current_node)

            for edge in self.graph.get_neighbors(
                current_node,
            ):
                neighbor = edge["to"]

                if edge["blocked"]:
                    continue

                if neighbor in visited:
                    continue

                edge_cost = self.graph.get_edge_cost(
                    edge,
                )

                tentative_g_score = (
                    g_score[current_node]
                    + edge_cost
                )

                current_neighbor_score = (
                    g_score.get(
                        neighbor,
                        float("inf"),
                    )
                )

                if (
                    tentative_g_score
                    < current_neighbor_score
                ):
                    came_from[neighbor] = current_node

                    g_score[neighbor] = (
                        tentative_g_score
                    )

                    priority = (
                        tentative_g_score
                        + self._heuristic(
                            neighbor,
                            goal_node,
                        )
                    )

                    heapq.heappush(
                        open_set,
                        (
                            priority,
                            neighbor,
                        ),
                    )

        return None

    def _reconstruct_route(
        self,
        came_from,
        current_node,
        total_cost,
    ):
        path = [current_node]

        while current_node in came_from:
            current_node = came_from[current_node]
            path.append(current_node)

        path.reverse()

        return {
            "path": path,
            "total_cost": total_cost,
        }