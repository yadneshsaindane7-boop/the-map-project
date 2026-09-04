import pytest
from app.routing.real_router import RealNashikRouter
from app.services.road_event_service import ActiveSegmentRestriction


@pytest.fixture(scope="module")
def real_router():
    router = RealNashikRouter()
    router.load()
    return router


def test_checkpoint1_nearest_way_coordinates(real_router):
    coord1 = (19.9947454230054, 73.7693669651099)
    res1 = real_router.find_nearest_osm_way(coord1[0], coord1[1])
    assert res1 is not None
    assert "osm_way_id" in res1
    assert res1["osm_way_id"] > 0
    assert res1["distance_meters"] < 50.0  # within 50m of a road

    coord2 = (19.9911379225175, 73.7634754236582)
    res2 = real_router.find_nearest_osm_way(coord2[0], coord2[1])
    assert res2 is not None
    assert "osm_way_id" in res2
    assert res2["osm_way_id"] > 0
    assert res2["distance_meters"] < 50.0

    print(f"\nCoord 1: {coord1} -> {res1}")
    print(f"Coord 2: {coord2} -> {res2}")


def test_checkpoint5_and_7_dynamic_sync_and_routing(real_router):
    start_lat, start_lon = 19.9975, 73.7898
    end_lat, end_lon = 20.0110, 73.7908

    # 1. Normal route
    normal_route = real_router.find_route(start_lat, start_lon, end_lat, end_lon)
    assert normal_route is not None
    assert len(normal_route["path"]) > 1

    # Extract OSM ways on the normal route
    route_osm_ways = []
    for i in range(len(normal_route["path"]) - 1):
        edge = real_router.graph_manager.get_edge_between_nodes(
            normal_route["path"][i],
            normal_route["path"][i + 1],
        )
        if edge and edge["data"].get("osmid"):
            osmid = int(edge["data"]["osmid"])
            if osmid not in route_osm_ways:
                route_osm_ways.append(osmid)

    assert len(route_osm_ways) > 0
    target_osm_way = route_osm_ways[len(route_osm_ways) // 2]

    # 2. Block the way via sync_active_events
    restriction = ActiveSegmentRestriction(
        segment_id="test-seg-1",
        road_event_id="test-event-1",
        osm_way_id=target_osm_way,
        is_closed=True,
        penalty_seconds=0.0,
    )
    sync_stats = real_router.sync_active_events([restriction])
    assert sync_stats["blocked_ways_applied"] >= 1

    blocked_route = real_router.find_route(start_lat, start_lon, end_lat, end_lon)
    assert blocked_route is not None
    assert blocked_route["path"] != normal_route["path"]

    # 3. Apply penalty instead of closure
    penalty_restriction = ActiveSegmentRestriction(
        segment_id="test-seg-2",
        road_event_id="test-event-2",
        osm_way_id=target_osm_way,
        is_closed=False,
        penalty_seconds=3600.0,  # 1 hour penalty
    )
    real_router.sync_active_events([penalty_restriction])
    penalized_route = real_router.find_route(start_lat, start_lon, end_lat, end_lon)
    assert penalized_route is not None
    # Route either changes path or has higher cost
    assert penalized_route["path"] != normal_route["path"] or penalized_route["total_cost"] > normal_route["total_cost"]

    # 4. Clear dynamic events and verify restoration
    real_router.sync_active_events([])
    restored_route = real_router.find_route(start_lat, start_lon, end_lat, end_lon)
    assert restored_route is not None
    assert restored_route["path"] == normal_route["path"]
    assert pytest.approx(restored_route["total_cost"], 0.01) == normal_route["total_cost"]
