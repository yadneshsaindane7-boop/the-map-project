from app.routing.astar import AStarRouter
from app.routing.graph import RoadGraph


def create_test_graph():
    graph = RoadGraph()

    graph.add_node("A", 0, 0)
    graph.add_node("B", 0, 1)
    graph.add_node("C", 0, 2)

    graph.add_node("D", 1, 0)
    graph.add_node("E", 1, 1)
    graph.add_node("F", 1, 2)

    graph.add_edge(
        "A",
        "B",
        base_cost=1,
        road_id="road_ab",
    )

    graph.add_edge(
        "B",
        "C",
        base_cost=1,
        road_id="road_bc",
    )

    graph.add_edge(
        "C",
        "F",
        base_cost=1,
        road_id="road_cf",
    )

    graph.add_edge(
        "A",
        "D",
        base_cost=2,
        road_id="road_ad",
    )

    graph.add_edge(
        "D",
        "E",
        base_cost=2,
        road_id="road_de",
    )

    graph.add_edge(
        "E",
        "F",
        base_cost=2,
        road_id="road_ef",
    )

    return graph


def test_normal_route():
    graph = create_test_graph()
    router = AStarRouter(graph)

    route = router.find_route(
        "A",
        "F",
    )

    assert route is not None
    assert route["path"] == [
        "A",
        "B",
        "C",
        "F",
    ]
    assert route["total_cost"] == 3


def test_route_changes_after_accident_penalty():
    graph = create_test_graph()

    graph.apply_penalty(
        "road_bc",
        multiplier=10,
    )

    router = AStarRouter(graph)

    route = router.find_route(
        "A",
        "F",
    )

    assert route is not None
    assert route["path"] == [
        "A",
        "D",
        "E",
        "F",
    ]
    assert route["total_cost"] == 6


def test_route_avoids_closed_road():
    graph = create_test_graph()

    graph.block_road(
        "road_bc",
    )

    router = AStarRouter(graph)

    route = router.find_route(
        "A",
        "F",
    )

    assert route is not None
    assert route["path"] == [
        "A",
        "D",
        "E",
        "F",
    ]
    assert route["total_cost"] == 6