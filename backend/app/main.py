from contextlib import asynccontextmanager

from fastapi import FastAPI

from app.api.routes.routing import router as routing_router
from app.routing.real_router import RealNashikRouter


@asynccontextmanager
async def lifespan(app: FastAPI):
    print()
    print("=" * 60)
    print("THE MAP PROJECT BACKEND")
    print("=" * 60)
    print()
    print("Loading custom Nashik routing engine...")
    print()

    routing_engine = RealNashikRouter()
    routing_engine.load()

    from app.services.road_event_service import RoadEventService
    road_event_service = RoadEventService()

    if road_event_service.is_connected():
        print("Synchronizing active road events from Supabase...")
        try:
            restrictions = road_event_service.fetch_active_restrictions()
            stats = routing_engine.sync_active_events(restrictions)
            print(f"Road events synchronized: {stats}")
        except Exception as e:
            print(f"Warning: Failed initial event sync: {e}")
    else:
        print("Running in offline mode (no active Supabase connection).")

    app.state.routing_engine = routing_engine
    app.state.road_event_service = road_event_service

    print()
    print("Routing engine ready.")
    print()
    print("=" * 60)
    print()

    yield

    print()
    print("Shutting down The Map Project backend...")
    print()


app = FastAPI(
    title="The Map Project API",
    description=(
        "Custom road routing and dynamic road-event API "
        "for The Map Project."
    ),
    version="1.0.0",
    lifespan=lifespan,
)


@app.get("/")
def root():
    return {
        "message": "The Map Project backend is running.",
        "routing_engine": "Custom A* Nashik Road Router",
        "status": "ready",
    }


@app.get("/health")
def health():
    return {
        "status": "healthy",
        "service": "The Map Project Backend",
    }


app.include_router(
    routing_router,
    prefix="/api",
    tags=["Routing"],
)