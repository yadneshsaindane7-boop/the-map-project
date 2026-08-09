import sys
from pathlib import Path


BACKEND_DIR = (
    Path(__file__).resolve().parent.parent
)

if str(BACKEND_DIR) not in sys.path:
    sys.path.insert(
        0,
        str(BACKEND_DIR),
    )


from app.routing.real_router import RealNashikRouter


START_LATITUDE = 19.9975
START_LONGITUDE = 73.7898

END_LATITUDE = 20.0110
END_LONGITUDE = 73.7908


def print_header(title):
    print()
    print("=" * 70)
    print(title)
    print("=" * 70)


def calculate_route(router):
    return router.find_route(
        start_latitude=START_LATITUDE,
        start_longitude=START_LONGITUDE,
        end_latitude=END_LATITUDE,
        end_longitude=END_LONGITUDE,
    )


def route_edge_list(
    graph_manager,
    path,
):
    edges = []

    for index in range(
        len(path) - 1
    ):
        source = path[index]
        target = path[index + 1]

        edge = (
            graph_manager.get_edge_between_nodes(
                source,
                target,
            )
        )

        if edge is not None:
            edges.append(edge)

    return edges


def route_changed(
    first_route,
    second_route,
):
    return (
        first_route["path"]
        != second_route["path"]
    )


def print_route_summary(
    label,
    result,
):
    print()
    print(label)

    print(
        f"Nodes: "
        f"{len(result['path'])}"
    )

    print(
        f"Coordinates: "
        f"{len(result['coordinates'])}"
    )

    print(
        f"Cost: "
        f"{result['total_cost']:.2f} seconds"
    )

    print(
        f"ETA: "
        f"{result['total_cost'] / 60:.2f} minutes"
    )


def main():
    print_header(
        "THE MAP PROJECT - DYNAMIC NASHIK ROUTING TEST"
    )

    router = RealNashikRouter()

    print()
    print("LOADING REAL NASHIK ROAD GRAPH...")

    router.load()

    graph_manager = router.graph_manager

    print_header(
        "TEST 1 - NORMAL ROUTE"
    )

    normal_route = calculate_route(
        router
    )

    if normal_route is None:
        print(
            "FAIL: Normal route could not be found."
        )
        return

    print_route_summary(
        "NORMAL ROUTE RESULT",
        normal_route,
    )

    normal_edges = route_edge_list(
        graph_manager,
        normal_route["path"],
    )

    print(
        f"Route edges available: "
        f"{len(normal_edges)}"
    )

    if not normal_edges:
        print(
            "FAIL: Could not extract "
            "edges from normal route."
        )
        return

    # Select an edge around the middle of the route.
    selected_index = (
        len(normal_edges) // 2
    )

    selected_edge = normal_edges[
        selected_index
    ]

    print()
    print(
        "Selected dynamic event edge:"
    )

    print(
        f"Source: "
        f"{selected_edge['source']}"
    )

    print(
        f"Target: "
        f"{selected_edge['target']}"
    )

    print(
        f"Edge key: "
        f"{selected_edge['key']}"
    )

    print_header(
        "TEST 2 - ACCIDENT PENALTY"
    )

    graph_manager.apply_penalty_to_edge(
        source=selected_edge["source"],
        target=selected_edge["target"],
        key=selected_edge["key"],
        penalty=3600.0,
    )

    accident_route = calculate_route(
        router
    )

    if accident_route is None:
        print(
            "FAIL: No route found after "
            "accident penalty."
        )
        return

    print_route_summary(
        "ACCIDENT ROUTE RESULT",
        accident_route,
    )

    accident_changed = route_changed(
        normal_route,
        accident_route,
    )

    print()
    print(
        "Did the route change after "
        f"accident penalty? "
        f"{accident_changed}"
    )

    if accident_changed:
        print(
            "PASS: Accident penalty caused "
            "the router to choose a different route."
        )
    else:
        print(
            "WARNING: Route did not change. "
            "The selected edge may not have a "
            "reasonable alternative."
        )

    print_header(
        "TEST 3 - ROAD CLOSURE"
    )

    graph_manager.clear_dynamic_events()

    graph_manager.block_edge(
        source=selected_edge["source"],
        target=selected_edge["target"],
        key=selected_edge["key"],
    )

    closure_route = calculate_route(
        router
    )

    if closure_route is None:
        print(
            "FAIL: No alternative route exists "
            "after closing the selected edge."
        )
        return

    print_route_summary(
        "ROAD CLOSURE ROUTE RESULT",
        closure_route,
    )

    closure_changed = route_changed(
        normal_route,
        closure_route,
    )

    print()
    print(
        "Did the route change after "
        f"road closure? "
        f"{closure_changed}"
    )

    if closure_changed:
        print(
            "PASS: Closed road was avoided "
            "and an alternative route was found."
        )
    else:
        print(
            "FAIL: Route did not change after "
            "blocking a route edge."
        )

    graph_manager.clear_dynamic_events()

    print_header(
        "FINAL RESULT"
    )

    print(
        f"Normal route nodes: "
        f"{len(normal_route['path'])}"
    )

    print(
        f"Accident route nodes: "
        f"{len(accident_route['path'])}"
    )

    print(
        f"Closure route nodes: "
        f"{len(closure_route['path'])}"
    )

    print()
    print(
        f"Accident avoidance working: "
        f"{accident_changed}"
    )

    print(
        f"Road closure avoidance working: "
        f"{closure_changed}"
    )

    print_header(
        "DYNAMIC NASHIK ROUTING TEST COMPLETE"
    )


if __name__ == "__main__":
    main()