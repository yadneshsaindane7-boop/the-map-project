from fastapi import APIRouter
from fastapi import HTTPException
from fastapi import Request
from pydantic import BaseModel
from pydantic import Field


router = APIRouter()


class RouteRequest(BaseModel):
    start_latitude: float = Field(
        ...,
        ge=-90,
        le=90,
        description="Starting latitude",
    )

    start_longitude: float = Field(
        ...,
        ge=-180,
        le=180,
        description="Starting longitude",
    )

    end_latitude: float = Field(
        ...,
        ge=-90,
        le=90,
        description="Destination latitude",
    )

    end_longitude: float = Field(
        ...,
        ge=-180,
        le=180,
        description="Destination longitude",
    )


@router.get("/routing/status")
def routing_status(request: Request):
    routing_engine = getattr(
        request.app.state,
        "routing_engine",
        None,
    )

    if routing_engine is None:
        return {
            "status": "loading",
            "message": "Routing engine is not ready yet.",
        }

    graph = routing_engine.graph_manager.graph

    return {
        "status": "ready",
        "engine": "Custom A* Router",
        "graph_nodes": (
            graph.number_of_nodes()
            if graph is not None
            else 0
        ),
        "graph_edges": (
            graph.number_of_edges()
            if graph is not None
            else 0
        ),
    }


@router.get("/routing/nearest-way")
def get_nearest_way(
    latitude: float,
    longitude: float,
    request: Request,
):
    routing_engine = getattr(
        request.app.state,
        "routing_engine",
        None,
    )

    if routing_engine is None:
        raise HTTPException(
            status_code=503,
            detail="Routing engine is not ready yet.",
        )

    try:
        way_info = routing_engine.find_nearest_osm_way(
            latitude=latitude,
            longitude=longitude,
        )
    except Exception as error:
        raise HTTPException(
            status_code=500,
            detail=f"Failed to resolve nearest road: {str(error)}",
        )

    if way_info is None:
        raise HTTPException(
            status_code=404,
            detail="No nearby road edge found for the selected coordinates.",
        )

    return {
        "success": True,
        **way_info,
    }


@router.post("/routing/route")
def calculate_route(
    route_request: RouteRequest,
    request: Request,
):
    routing_engine = getattr(
        request.app.state,
        "routing_engine",
        None,
    )

    if routing_engine is None:
        raise HTTPException(
            status_code=503,
            detail=(
                "Routing engine is not ready yet."
            ),
        )

    # Synchronize active road events from Supabase if connected
    road_event_service = getattr(
        request.app.state,
        "road_event_service",
        None,
    )
    if road_event_service and road_event_service.is_connected():
        try:
            restrictions = road_event_service.fetch_active_restrictions()
            routing_engine.sync_active_events(restrictions)
        except Exception:
            # Database or network issues must not crash or corrupt routing
            pass

    try:
        result = routing_engine.find_route(
            start_latitude=(
                route_request.start_latitude
            ),
            start_longitude=(
                route_request.start_longitude
            ),
            end_latitude=(
                route_request.end_latitude
            ),
            end_longitude=(
                route_request.end_longitude
            ),
        )

    except ValueError as error:
        raise HTTPException(
            status_code=400,
            detail=str(error),
        )

    except RuntimeError as error:
        raise HTTPException(
            status_code=503,
            detail=str(error),
        )

    except Exception as error:
        raise HTTPException(
            status_code=500,
            detail=(
                "Failed to calculate route: "
                f"{str(error)}"
            ),
        )

    if result is None:
        raise HTTPException(
            status_code=404,
            detail=(
                "No route could be found between "
                "the selected locations."
            ),
        )

    total_cost_seconds = float(
        result["total_cost"]
    )

    return {
        "success": True,
        "start_node": result["start_node"],
        "end_node": result["end_node"],
        "route_node_count": len(
            result["path"]
        ),
        "coordinate_count": len(
            result["coordinates"]
        ),
        "total_cost_seconds": (
            total_cost_seconds
        ),
        "estimated_duration_minutes": round(
            total_cost_seconds / 60,
            2,
        ),
        "coordinates": (
            result["coordinates"]
        ),
    }