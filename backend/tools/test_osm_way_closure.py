import sys
from pathlib import Path


BACKEND_ROOT = Path(__file__).resolve().parents[1]

if str(BACKEND_ROOT) not in sys.path:
    sys.path.insert(
        0,
        str(BACKEND_ROOT),
    )


from app.routing.real_router import RealNashikRouter


START_LATITUDE = 19.9975
START_LONGITUDE = 73.7898

END_LATITUDE = 20.0110
END_LONGITUDE = 73.7908


def calculate_route(router):
    graph = router.graph_manager

    start_node = graph.find_nearest_node(
        START_LATITUDE,
        START_LONGITUDE,
    )

    end_node = graph.find_nearest_node(
        END_LATITUDE,
        END_LONGITUDE,
    )

    result = router.router.find_route(
        start_node,
        end_node,
    )

    if result is None:
        raise RuntimeError(
            "No route found."
        )

    path = result["path"]

    coordinates = []

    for node_id in path:
        coordinate = graph.get_coordinates(
            node_id
        )

        if coordinate is not None:
            coordinates.append(
                {
                    "latitude": coordinate[0],
                    "longitude": coordinate[1],
                }
            )

    return {
        "path": path,
        "coordinates": coordinates,
        "total_cost": result["total_cost"],
    }


def get_route_osm_ways(router, route):
    graph = router.graph_manager

    osm_way_ids = []

    for index in range(
        len(route["path"]) - 1
    ):
        source = route["path"][index]
        target = route["path"][index + 1]

        edge = graph.get_edge_between_nodes(
            source,
            target,
        )

        if edge is None:
            continue

        osm_way_id = edge["data"].get(
            "osmid"
        )

        if osm_way_id is None:
            continue

        osm_way_id = str(osm_way_id)

        if osm_way_id not in osm_way_ids:
            osm_way_ids.append(
                osm_way_id
            )

    return osm_way_ids


def print_route(label, result):
    print()
    print(label)
    print("-" * 60)

    print(
        f"Nodes: {len(result['path'])}"
    )

    print(
        f"Coordinates: "
        f"{len(result['coordinates'])}"
    )

    print(
        f"Cost: "
        f"{result['total_cost']:.2f} seconds"
    )


def main():
    print("=" * 70)
    print("THE MAP PROJECT - OSM WAY CLOSURE TEST")
    print("=" * 70)

    router = RealNashikRouter()

    print()
    print("LOADING REAL NASHIK ROAD GRAPH...")

    router.load()

    graph = router.graph_manager

    print()
    print("=" * 70)
    print("TEST 1 - NORMAL ROUTE")
    print("=" * 70)

    normal_result = calculate_route(
        router
    )

    print_route(
        "NORMAL ROUTE",
        normal_result,
    )

    print()
    print("=" * 70)
    print("TEST 2 - FIND OSM WAYS ON ROUTE")
    print("=" * 70)

    route_osm_ways = get_route_osm_ways(
        router,
        normal_result,
    )

    print()
    print(
        f"Unique OSM ways on route: "
        f"{len(route_osm_ways)}"
    )

    for osm_way_id in route_osm_ways:
        print(
            f"  - {osm_way_id}"
        )

    if not route_osm_ways:
        print()
        print(
            "FAIL: No OSM way IDs found "
            "on the route."
        )
        return

    # Select an OSM way from the middle
    # portion of the route.
    selected_index = (
        len(route_osm_ways) // 2
    )

    test_osm_way_id = route_osm_ways[
        selected_index
    ]

    print()
    print(
        f"Selected OSM way for closure: "
        f"{test_osm_way_id}"
    )

    matching_edges = (
        graph.get_edges_by_osm_way_id(
            test_osm_way_id
        )
    )

    print(
        f"Matching graph edges: "
        f"{len(matching_edges)}"
    )

    print()
    print("=" * 70)
    print("TEST 3 - BLOCK OSM WAY")
    print("=" * 70)

    blocked_count = (
        graph.block_osm_way(
            test_osm_way_id
        )
    )

    print()
    print(
        f"Blocked graph edges: "
        f"{blocked_count}"
    )

    print()
    print("=" * 70)
    print("TEST 4 - ROUTE AFTER OSM WAY CLOSURE")
    print("=" * 70)

    closure_result = calculate_route(
        router
    )

    print_route(
        "OSM WAY CLOSURE ROUTE",
        closure_result,
    )

    route_changed = (
        normal_result["path"]
        != closure_result["path"]
    )

    print()
    print(
        "Did the route change after "
        f"blocking OSM way? {route_changed}"
    )

    if route_changed:
        print(
            "PASS: OSM way closure caused "
            "the router to choose a "
            "different route."
        )
    else:
        print(
            "FAIL: Route did not change."
        )

    print()
    print("=" * 70)
    print("TEST 5 - CLEAR DYNAMIC EVENTS")
    print("=" * 70)

    graph.clear_dynamic_events()

    restored_result = calculate_route(
        router
    )

    restored = (
        normal_result["path"]
        == restored_result["path"]
    )

    print()
    print(
        f"Original route restored: "
        f"{restored}"
    )

    print()
    print("=" * 70)
    print("FINAL RESULT")
    print("=" * 70)

    print(
        f"Normal route nodes: "
        f"{len(normal_result['path'])}"
    )

    print(
        f"Closure route nodes: "
        f"{len(closure_result['path'])}"
    )

    print(
        f"Restored route nodes: "
        f"{len(restored_result['path'])}"
    )

    print()

    print(
        "OSM way lookup working: "
        f"{len(matching_edges) > 0}"
    )

    print(
        "OSM way closure working: "
        f"{route_changed}"
    )

    print(
        "Dynamic event clearing working: "
        f"{restored}"
    )

    print()
    print("=" * 70)
    print("OSM WAY CLOSURE TEST COMPLETE")
    print("=" * 70)


if __name__ == "__main__":
    main()