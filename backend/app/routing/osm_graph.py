import time

import networkx as nx
import osmnx as ox


class NashikRoadGraph:
    def __init__(self):
        self.graph = None

    def load(self):
        print("========================================")
        print("DOWNLOADING NASHIK ROAD NETWORK")
        print("========================================")

        # Show OSMnx progress in the terminal.
        ox.settings.log_console = True

        # Cache successful HTTP responses locally.
        ox.settings.use_cache = True
        ox.settings.cache_folder = "cache"

        # Increase timeout for large road-network queries.
        ox.settings.requests_timeout = 300

        # Use an alternative Overpass instance.
        ox.settings.overpass_url = (
            "https://overpass.kumi.systems/api"
        )

        print("Overpass endpoint:")
        print(ox.settings.overpass_url)

        print("Request timeout:")
        print(f"{ox.settings.requests_timeout} seconds")

        print("Starting download...")
        print()

        try:
            self.graph = ox.graph_from_place(
                "Nashik, Maharashtra, India",
                network_type="drive",
                simplify=True,
            )
        except Exception as error:
            print()
            print("========================================")
            print("ROAD NETWORK DOWNLOAD FAILED")
            print("========================================")
            print(f"Error: {error}")
            raise

        print()
        print("========================================")
        print("NASHIK ROAD NETWORK LOADED")
        print("========================================")
        print(f"Nodes: {self.graph.number_of_nodes()}")
        print(f"Edges: {self.graph.number_of_edges()}")

        return self.graph

    def save(self, path):
        if self.graph is None:
            raise RuntimeError(
                "Graph has not been loaded yet."
            )

        ox.save_graphml(
            self.graph,
            filepath=path,
        )

        print(f"Graph saved to: {path}")

    def load_saved(self, path):
        self.graph = ox.load_graphml(path)

        print("========================================")
        print("SAVED NASHIK GRAPH LOADED")
        print("========================================")
        print(f"Nodes: {self.graph.number_of_nodes()}")
        print(f"Edges: {self.graph.number_of_edges()}")

        return self.graph

    def nearest_node(
        self,
        latitude,
        longitude,
    ):
        if self.graph is None:
            raise RuntimeError(
                "Graph has not been loaded."
            )

        return ox.distance.nearest_nodes(
            self.graph,
            X=longitude,
            Y=latitude,
        )

    def shortest_route(
        self,
        start_latitude,
        start_longitude,
        end_latitude,
        end_longitude,
    ):
        if self.graph is None:
            raise RuntimeError(
                "Graph has not been loaded."
            )

        start_node = self.nearest_node(
            start_latitude,
            start_longitude,
        )

        end_node = self.nearest_node(
            end_latitude,
            end_longitude,
        )

        return nx.shortest_path(
            self.graph,
            start_node,
            end_node,
            weight="length",
        )