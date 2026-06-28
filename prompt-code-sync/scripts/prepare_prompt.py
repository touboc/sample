# cd /d C:\Users\U752296\Documents\06\23\python
# python C:\Users\U752296\Documents\06\23\python\prepare_prompt.py

# prepare_prompt.py

import sys
from pathlib import Path

try:
    import pyperclip
except ImportError:
    print("Please install pyperclip: pip install pyperclip")
    sys.exit(1)

def main():
    if len(sys.argv) != 2:
        print("Usage: python prepare_prompt.py <prompt_md_file>")
        sys.exit(1)
        
    md_path = Path(sys.argv[1])
    
    if not md_path.is_file():
        print(f"Markdown file not found: {md_path}")
        sys.exit(1)
        
    content = md_path.read_text(encoding="utf-8")
    pyperclip.copy(content)
    print(f"Prompt copied to clipboard from: {md_path}")

if __name__ == "__main__":
    main()
