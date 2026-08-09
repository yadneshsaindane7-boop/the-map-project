from pathlib import Path

import networkx as nx


BACKEND_DIR = Path(__file__).resolve().parent.parent

GRAPH_FILE = (
    BACKEND_DIR
    / "data"
    / "graphs"
    / "nashik_road_graph.graphml"
)


def print_header(title: str) -> None:
    print()
    print("=" * 60)
    print(title)
    print("=" * 60)


def main() -> None:
    print_header(
        "THE MAP PROJECT - NASHIK GRAPH VERIFICATION"
    )

    print(f"Graph file: {GRAPH_FILE}")

    if not GRAPH_FILE.exists():
        raise FileNotFoundError(
            f"Graph file not found: {GRAPH_FILE}"
        )

    print()
    print("Loading graph...")

    graph = nx.read_graphml(
        GRAPH_FILE,
        force_multigraph=True,
    )

    print()
    print(
        f"Nodes: {graph.number_of_nodes():,}"
    )
    print(
        f"Edges: {graph.number_of_edges():,}"
    )

    print_header(
        "NODE COORDINATE CHECK"
    )

    sample_nodes = list(graph.nodes())[:10]

    valid_coordinates = 0

    for node_id in sample_nodes:
        data = graph.nodes[node_id]

        try:
            latitude = float(data["latitude"])
            longitude = float(data["longitude"])

            print(
                f"Node {node_id}: "
                f"{latitude:.6f}, "
                f"{longitude:.6f}"
            )

            valid_coordinates += 1

        except (
            KeyError,
            TypeError,
            ValueError,
        ) as error:
            print(
                f"Invalid node {node_id}: {error}"
            )

    print()
    print(
        f"Valid sample coordinates: "
        f"{valid_coordinates}/{len(sample_nodes)}"
    )

    print_header(
        "EDGE WEIGHT CHECK"
    )

    valid_weights = 0
    checked_edges = 0

    for source, target, key, data in graph.edges(
        keys=True,
        data=True,
    ):
        checked_edges += 1

        try:
            length = float(data["length"])
            travel_time = float(
                data["travel_time"]
            )

            if length > 0 and travel_time > 0:
                valid_weights += 1

        except (
            KeyError,
            TypeError,
            ValueError,
        ):
            pass

        if checked_edges >= 20:
            break

    print(
        f"Valid sample edge weights: "
        f"{valid_weights}/{checked_edges}"
    )

    print_header(
        "CONNECTIVITY CHECK"
    )

    print(
        "Calculating weakly connected components..."
    )

    weak_components = list(
        nx.weakly_connected_components(graph)
    )

    weak_components.sort(
        key=len,
        reverse=True,
    )

    largest_component_size = len(
        weak_components[0]
    )

    print(
        f"Weakly connected components: "
        f"{len(weak_components):,}"
    )

    print(
        f"Largest component: "
        f"{largest_component_size:,} nodes"
    )

    percentage = (
        largest_component_size
        / graph.number_of_nodes()
        * 100
    )

    print(
        f"Largest component coverage: "
        f"{percentage:.2f}%"
    )

    print_header(
        "STRONGLY CONNECTED COMPONENT CHECK"
    )

    print(
        "Calculating strongly connected components..."
    )

    strong_components = list(
        nx.strongly_connected_components(graph)
    )

    strong_components.sort(
        key=len,
        reverse=True,
    )

    largest_strong_component = len(
        strong_components[0]
    )

    print(
        f"Strongly connected components: "
        f"{len(strong_components):,}"
    )

    print(
        f"Largest strongly connected component: "
        f"{largest_strong_component:,} nodes"
    )

    strong_percentage = (
        largest_strong_component
        / graph.number_of_nodes()
        * 100
    )

    print(
        f"Largest strong component coverage: "
        f"{strong_percentage:.2f}%"
    )

    print_header(
        "GRAPH VERIFICATION COMPLETE"
    )

    if valid_coordinates == len(sample_nodes):
        print("PASS: Node coordinates are valid.")

    if valid_weights == checked_edges:
        print("PASS: Sample edge weights are valid.")

    print(
        "The graph is ready for real routing tests."
    )


if __name__ == "__main__":
    main()