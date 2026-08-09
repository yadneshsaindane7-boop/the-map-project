import sys
from pathlib import Path


BACKEND_ROOT = Path(__file__).resolve().parent.parent

if str(BACKEND_ROOT) not in sys.path:
    sys.path.insert(0, str(BACKEND_ROOT))


from app.routing.osm_graph import NashikRoadGraph


def main():
    graph_manager = NashikRoadGraph()

    graph_manager.load()

    output_directory = (
        BACKEND_ROOT
        / "data"
        / "nashik"
    )

    output_directory.mkdir(
        parents=True,
        exist_ok=True,
    )

    output_file = (
        output_directory
        / "nashik_drive.graphml"
    )

    graph_manager.save(
        str(output_file),
    )

    print("========================================")
    print("DOWNLOAD COMPLETE")
    print("========================================")
    print(f"File: {output_file}")


if __name__ == "__main__":
    main()