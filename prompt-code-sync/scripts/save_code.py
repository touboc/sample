# cd /d C:\Users\U752296\Documents\06\23\python
# python C:\Users\U752296\Documents\06\23\python\save_code.py

import sys
from pathlib import Path
import pyperclip

def main():
    if len(sys.argv) != 2:
        print("Usage: python save_code.py <feature>")
        sys.exit(1)
        
    feature = sys.argv[1]
    code = pyperclip.paste()
    
    if not code.strip():
        print("Clipboard is empty or contains no code.")
        sys.exit(1)
        
    suffix = feature.split("-")[-1]
    BASE_PY_DIR = Path(r"C:\Users\U752296\Videos\python")
    py_path = BASE_PY_DIR / Path(f"{suffix}.py")
    py_path.write_text(code, encoding="utf-8")
    
    print(f"Saved code to: {py_path}")

if __name__ == "__main__":
    main()
