# cd /d C:\Users\U752296\Documents\06\23\python
# python C:\Users\U752296\Documents\06\23\python\commit_feature.py

import sys
import subprocess
from pathlib import Path
from datetime import datetime

def run(cmd):
    print(">", " ".join(cmd))
    subprocess.run(cmd, check=True)

def main():
    if len(sys.argv) != 2:
        print("Usage: python commit_feature.py <feature_name>")
        sys.exit(1)
        
    feature = sys.argv[1]
    BASE_MD_DIR = Path(r"C:\Users\U752296\Music\obs\MyObs")
    md_path = BASE_MD_DIR / Path(f"{feature}.md")
    BASE_PY_DIR = Path(r"C:\Users\U752296\Videos\python")
    
    suffix = feature.split("-")[-1]
    py_path = BASE_PY_DIR / Path(f"{suffix}.py")
    # py_path = BASE_PY_DIR / Path(f"{feature}.py")
    
    if not md_path.is_file():
        print(f"Markdown file not found: {md_path}")
        sys.exit(1)
        
    if not py_path.is_file():
        print(f"Python file not found: {py_path}")
        sys.exit(1)
        
    # svn add (ignore errors if already added)
    for path in (md_path, py_path):
        try:
            run(["svn", "add", str(path)])
        except subprocess.CalledProcessError:
            print(f"svn add failed (maybe already added): {path}")
            
    # svn commit
    timestamp = datetime.now().strftime("%Y%m%d-%H%M%S-%f")[:22]  # trims microseconds to milliseconds
    msg = f"Update timestamp: {timestamp}"
    #run(["svn", "commit", "-m", msg])
    for path in (md_path, py_path):
        run(["svn", "commit", str(path), "-m", msg])
        
    print("SVN commit completed.")

if __name__ == "__main__":
    main()
