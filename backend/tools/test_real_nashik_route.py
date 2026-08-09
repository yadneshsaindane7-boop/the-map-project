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


def print_header(title):
    print()
    print("=" * 60)
    print(title)
    print("=" * 60)


def main():
    print_header(
        "THE MAP PROJECT - REAL NASHIK ROUTING TEST"
    )

    router = RealNashikRouter()

    print()
    print("STEP 1 - LOADING ROAD GRAPH")

    router.load()

    print()
    print("STEP 2 - CALCULATING ROUTE")

    # Nashik test locations.
    start_latitude = 19.9975
    start_longitude = 73.7898

    end_latitude = 20.0110
    end_longitude = 73.7908

    print()
    print(
        f"Start: "
        f"{start_latitude}, "
        f"{start_longitude}"
    )

    print(
        f"Destination: "
        f"{end_latitude}, "
        f"{end_longitude}"
    )

    result = router.find_route(
        start_latitude=start_latitude,
        start_longitude=start_longitude,
        end_latitude=end_latitude,
        end_longitude=end_longitude,
    )

    print_header(
        "ROUTING RESULT"
    )

    if result is None:
        print("NO ROUTE FOUND")
        return

    print(
        f"Start graph node: "
        f"{result['start_node']}"
    )

    print(
        f"Destination graph node: "
        f"{result['end_node']}"
    )

    print(
        f"Route nodes: "
        f"{len(result['path']):,}"
    )

    print(
        f"Route coordinates: "
        f"{len(result['coordinates']):,}"
    )

    print(
        f"Total routing cost: "
        f"{result['total_cost']:.2f} seconds"
    )

    print(
        f"Estimated travel time: "
        f"{result['total_cost'] / 60:.2f} minutes"
    )

    print()
    print("First 5 route coordinates:")

    for coordinate in result[
        "coordinates"
    ][:5]:
        print(
            f"  {coordinate['latitude']:.6f}, "
            f"{coordinate['longitude']:.6f}"
        )

    print()
    print("Last 5 route coordinates:")

    for coordinate in result[
        "coordinates"
    ][-5:]:
        print(
            f"  {coordinate['latitude']:.6f}, "
            f"{coordinate['longitude']:.6f}"
        )

    print_header(
        "REAL NASHIK ROUTING TEST COMPLETE"
    )

    print("PASS: Custom A* found a route.")


if __name__ == "__main__":
    main()