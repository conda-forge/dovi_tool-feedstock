import json
import os
import sys
from pathlib import Path


package = sys.argv[1]
record = next(
    (Path(os.environ["PREFIX"]) / "conda-meta").glob(f"{package}-*.json"), None
)
if record is None:
    raise SystemExit(f"Could not find {package} package record")

bad = [
    path
    for path in json.loads(record.read_text())["files"]
    if path.lower().endswith(".a")
    or (path.lower().endswith(".lib") and not path.lower().endswith(".dll.lib"))
]

if bad:
    raise SystemExit(
        f"Unexpected static libraries found in {package} package:\n  "
        + "\n  ".join(bad)
    )
