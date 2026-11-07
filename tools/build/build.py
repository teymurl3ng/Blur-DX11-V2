"""[Blur2PC] Standard x64 Release build, usable from Windows and shell wrappers."""
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys

root = Path(__file__).resolve().parents[2]
os.chdir(root)
work = root / "_work/build"
work.mkdir(parents=True, exist_ok=True)
cache_path = work / "vs/CMakeCache.txt"
cache = cache_path.read_text(errors="replace") if cache_path.exists() else ""
def cached(name):
    match = re.search(r"^" + name + r":[^=]*=(.*)$", cache, re.MULTILINE)
    return match.group(1).strip() if match else ""
cmake = os.environ.get("BLUR_CMAKE") or shutil.which("cmake") or cached("CMAKE_COMMAND")
if not cmake:
    raise SystemExit("Set BLUR_CMAKE to the Visual Studio CMake executable.")
generator = os.environ.get("BLUR_GENERATOR") or cached("CMAKE_GENERATOR") or "Visual Studio 17 2022"
def run(name, args):
    path = work / (name + ".log")
    with path.open("w") as log:
        result = subprocess.run(args, stdout=log, stderr=subprocess.STDOUT)
    print(name, "exit", result.returncode, flush=True)
    if result.returncode:
        print(path.read_text(errors="replace")[-6000:])
        raise SystemExit(result.returncode)
j = "tools/jam2cmake/"
manifest = "_work/build/targets_pc_speed.json"
run("extract", [sys.executable,j+"jamextract.py","--top",".","--root","code/amax/game/jamfile.jam",
               "--target","WIN32","--platform","PC","--build","Speed","--out",manifest])
headers = [str(p) for directory in ("code/mercury/library","code/amax/game")
           for p in Path(directory).rglob("*") if p.suffix.lower() in (".cp",".cv",".sp")]
run("headers", [sys.executable,j+"cpgen.py",*headers])
run("shaders", [sys.executable,j+"shadergen.py","--json",manifest,"--out","_work/build/gen/shaders"])
run("lua", [sys.executable,j+"luabundle.py","--json",manifest,"--out","_work/build/gen/blobs/amax_lua_bundle.cpp"])
run("targets", [sys.executable,j+"gen_cmake.py","--json",manifest,"--out","cmake/targets.cmake"])
run("configure", [cmake,"-S",".","-B","_work/build/vs","-G",generator,"-A","x64",
                  "-DPython3_EXECUTABLE=" + sys.executable])
run("amax", [cmake,"--build","_work/build/vs","--config","Release","--target","Amax","--","-m:2","-v:m","-nologo"])
subprocess.run([sys.executable,j+"errsum.py",str(work/"amax.log")],check=True)
