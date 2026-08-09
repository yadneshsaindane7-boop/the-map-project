from pathlib import Path
import shutil


def main():
    backend_dir = Path(__file__).resolve().parent.parent
    data_dir = backend_dir / "data"

    print("\n========== ROUTING DATA CHECK ==========")
    print(f"Backend: {backend_dir}")
    print(f"Data directory: {data_dir}")

    print("\n---------- FOLDERS ----------")

    for folder_name in ["raw", "nashik", "processed", "graphs"]:
        folder = data_dir / folder_name
        folder.mkdir(parents=True, exist_ok=True)

        files = list(folder.iterdir())

        print(f"\n{folder_name}/")
        print(f"Path: {folder}")

        if not files:
            print("Status: EMPTY")
        else:
            print(f"Status: {len(files)} item(s)")
            for file in files:
                if file.is_file():
                    size_mb = file.stat().st_size / (1024 * 1024)
                    print(f"  - {file.name} ({size_mb:.2f} MB)")
                else:
                    print(f"  - {file.name}/")

    print("\n---------- DISK SPACE ----------")

    total, used, free = shutil.disk_usage(backend_dir)

    print(f"Total: {total / (1024 ** 3):.2f} GB")
    print(f"Used:  {used / (1024 ** 3):.2f} GB")
    print(f"Free:  {free / (1024 ** 3):.2f} GB")

    print("\n========== READY ==========\n")


if __name__ == "__main__":
    main()