按键	功能  
z	使用 fzf 模糊搜索文件  
s	使用 fd 搜索文件名  
S	使用 ripgrep 搜索文件内容  
Z	使用 zoxide 搜索历史目录  
  
  
如果之后想要图标，  
装一个带 Nerd Font 的日文等宽字体，  
到 Windows Terminal 里选上，我再帮你把图标段删掉恢复。  
  
  
所以 Ctrl+P、Z（fzf 模糊搜索）和 z（zoxide 智能跳转）这三个快捷键现在应该可以用了  
No directory history found ,check zoxide&s doc to set it up and restart yazi.  
  
///  
7-Zip 已加进 PATH：C:\Program Files\7-Zip。Yazi 现在检测到了 7z 22.01，压缩包内容预览可以用了。  
yazi 已加进 PATH：C:\My\daily\2026\11\23\yazi。新开终端后直接输入 yazi 就能启动，版本是 26.1.4。  
YAZI_FILE_ONE 已永久设置：指向 C:\Program Files\Git\usr\bin\file.exe，文件类型识别正常。  
  
///  
fzf 和 zoxide  
  
winget install --id junegunn.fzf -e  
winget install --id ajeetdsouza.zoxide -e  
winget install --id 7zip.7zip -e  
  
"C:\Program Files\7-Zip\7zFM.exe"  
  
软件	默认安装路径  
fzf	%LOCALAPPDATA%\Microsoft\WinGet\Packages\ 下对应的软件目录  
C:\Users\user\AppData\Local\Microsoft\WinGet\Packages\junegunn.fzf_Microsoft.Winget.Source_8wekyb3d8bbwe\fzf.exe  
zoxide	%LOCALAPPDATA%\Microsoft\WinGet\Packages\ 下对应的软件目录  
7-Zip	C:\Program Files\7-Zip\  
  
  
# Yazi 完整配置文件  
  
配置目录在 `%AppData%\yazi\config`，把下面三个文件分别存进去即可。如果某个选项在你的版本里报错，删掉那一行，或者对照官方文档 yazi-rs.github.io。  
C:\Users\user\AppData\Roaming\yazi\config  
  
C:\My\daily\2026\11\23\yazi\yazi.exe  
  
## 文件一：yazi.toml  
  
管理界面布局、排序、预览、打开方式和任务调度。  
  
```toml  
[mgr]  
# 三栏布局：父目录、当前目录、预览  
 ratio = [1, 3, 4]  
 sort_by = "natural"  
 sort_sensitive = false  
 sort_reverse = false  
 sort_dir_first = true  
 sort_translit = true  
 linemode = "size"  
 show_hidden = true  
 show_symlink = true  
 scrolloff = 5  
 mouse_events = ["click", "scroll", "touch", "move"]  
 title_format = "Yazi: {cwd}"  
  
[preview]  
 tab_size = 2  
 max_width = 1000  
 max_height = 1000  
 cache_dir = ""  
 image_delay = 30  
 image_filter = "triangle"  
 image_quality = 75  
 sixel_fraction = 15  
 ueberzug_scale = 1  
 ueberzug_offset = [0, 0, 0, 0]  
  
[opener]  
 edit = [  
 { run = 'code "%*"', desc = "VS Code", orphan = true, for = "windows" },  
 { run = 'notepad "%*"', desc = "记事本", block = true, for = "windows" },  
]  
 open = [  
 { run = 'start "" "%1"', desc = "系统默认打开", orphan = true, for = "windows" },  
]  
 reveal = [  
 { run = 'explorer /select,"%1"', desc = "在资源管理器中显示", orphan = true, for = "windows" },  
]  
 extract = [  
 { run = '7z x "%1"', desc = "解压到当前目录", block = true, for = "windows" },  
]  
 play = [  
 { run = 'start "" "%1"', desc = "播放", orphan = true, for = "windows" },  
]  
  
[open]  
 rules = [  
 { name = "*/", use = ["edit", "open", "reveal"] },  
 { mime = "text/*", use = ["edit", "reveal"] },  
 { mime = "image/*", use = ["open", "reveal"] },  
 { mime = "video/*", use = ["play", "reveal"] },  
 { mime = "audio/*", use = ["play", "reveal"] },  
 { mime = "application/zip", use = ["extract", "reveal"] },  
 { mime = "application/x-7z-compressed", use = ["extract", "reveal"] },  
 { mime = "application/x-rar", use = ["extract", "reveal"] },  
 { mime = "application/json", use = ["edit", "reveal"] },  
 { name = "*", use = ["open", "reveal"] },  
]  
  
[tasks]  
 micro_workers = 10  
 macro_workers = 10  
 bizarre_retry = 5  
 image_alloc = 536870912  
 image_bound = [0, 0]  
 suppress_preload = false  
  
[plugin]  
  
[input]  
 cursor_blink = true  
  
[confirm]  
 trash_title = "确定把 {n} 个文件移到回收站？"  
 delete_title = "确定永久删除 {n} 个文件？"  
 overwrite_title = "文件已存在，是否覆盖？"  
 quit_title = "还有任务在运行，确定退出？"  
  
[log]  
 enabled = false  
```  
  
## 文件二：keymap.toml  
  
管理快捷键。下面的写法是在默认键位基础上追加自定义键，原有的 hjkl 等操作保持不变。  
  
```toml  
[mgr]  
prepend_keymap = [  
 # 快速跳转常用目录  
 { on = ["g", "h"], run = "cd ~", desc = "回到用户目录" },  
 { on = ["g", "d"], run = "cd ~/Downloads", desc = "下载目录" },  
 { on = ["g", "o"], run = "cd ~/Documents", desc = "文档目录" },  
 { on = ["g", "t"], run = "cd ~/Desktop", desc = "桌面" },  
 { on = ["g", "c"], run = "cd ~/.config", desc = "配置目录" },  
  
 # 删除与回收站  
 { on = ["d"], run = "remove", desc = "移到回收站" },  
 { on = ["D"], run = "remove --permanently", desc = "永久删除" },  
  
 # 标签页  
 { on = ["t"], run = "tab_create --current", desc = "新建标签页" },  
 { on = ["w"], run = "tab_close", desc = "关闭标签页" },  
 { on = ["["], run = "tab_switch -1 --relative", desc = "上一个标签页" },  
 { on = ["]"], run = "tab_switch 1 --relative", desc = "下一个标签页" },  
  
 # 排序快捷键  
 { on = [",", "n"], run = ["sort natural --reverse=no", "linemode size"], desc = "按自然顺序" },  
 { on = [",", "m"], run = ["sort mtime --reverse", "linemode mtime"], desc = "按修改时间，新的在前" },  
 { on = [",", "s"], run = ["sort size --reverse", "linemode size"], desc = "按大小，大的在前" },  
 { on = [",", "e"], run = "sort extension", desc = "按扩展名" },  
  
 # 系统操作  
 { on = ["<C-r>"], run = "reveal", desc = "定位到当前文件" },  
 { on = ["<C-s>"], run = "shell --block --confirm", desc = "在当前目录打开 shell" },  
 { on = ["<C-h>"], run = "hidden toggle", desc = "切换显示隐藏文件" },  
 { on = ["<C-p>"], run = "plugin fzf", desc = "用 fzf 模糊跳转" },  
 { on = ["z"], run = "plugin zoxide", desc = "用 zoxide 智能跳转" },  
 { on = ["Z"], run = "plugin fzf", desc = "用 fzf 搜索文件" },  
]  
  
[tasks]  
prepend_keymap = [  
 { on = ["<Esc>"], run = "close", desc = "关闭任务面板" },  
]  
  
[input]  
prepend_keymap = [  
 { on = ["<Esc>"], run = "close", desc = "退出输入框" },  
]  
```  
  
## 文件三：theme.toml  
  
管理配色和图标。下面是一套深色主题，覆盖了主要界面元素。  
  
```toml  
[flavor]  
# 如果装了主题包可以在这里指定，留空则使用下面的自定义配色  
 dark = ""  
 light = ""  
  
[mgr]  
 cwd = { fg = "#7dcfff", bold = true }  
 hovered = { reversed = true }  
 preview_hovered = { underline = true }  
 find_keyword = { fg = "#e0af68", bold = true, italic = true }  
 find_position = { fg = "#bb9af7", bg = "reset", bold = true, italic = true }  
 marker_copied = { fg = "#9ece6a", bg = "#9ece6a" }  
 marker_cut = { fg = "#f7768e", bg = "#f7768e" }  
 marker_marked = { fg = "#7dcfff", bg = "#7dcfff" }  
 marker_selected = { fg = "#e0af68", bg = "#e0af68" }  
 count_copied = { fg = "#1a1b26", bg = "#9ece6a" }  
 count_cut = { fg = "#1a1b26", bg = "#f7768e" }  
 count_selected = { fg = "#1a1b26", bg = "#e0af68" }  
 border_symbol = "│"  
 border_style = { fg = "#3b4261" }  
 syntect_theme = ""  
  
[tabs]  
 active = { fg = "#1a1b26", bg = "#7aa2f7", bold = true }  
 inactive = { fg = "#a9b1d6", bg = "#3b4261" }  
 sep_inner = { open = "", close = "" }  
 sep_outer = { open = "", close = "" }  
  
[mode]  
 normal_main = { fg = "#1a1b26", bg = "#7aa2f7", bold = true }  
 normal_alt = { fg = "#7aa2f7", bg = "#3b4261" }  
 select_main = { fg = "#1a1b26", bg = "#9ece6a", bold = true }  
 select_alt = { fg = "#9ece6a", bg = "#3b4261" }  
 unset_main = { fg = "#1a1b26", bg = "#bb9af7", bold = true }  
 unset_alt = { fg = "#bb9af7", bg = "#3b4261" }  
  
[status]  
 overall = { bg = "#1a1b26" }  
 sep_left = { open = "", close = "" }  
 sep_right = { open = "", close = "" }  
 perm_sep = { fg = "#3b4261" }  
 perm_type = { fg = "#7aa2f7" }  
 perm_read = { fg = "#e0af68" }  
 perm_write = { fg = "#f7768e" }  
 perm_exec = { fg = "#9ece6a" }  
 progress_label = { fg = "#c0caf5", bold = true }  
 progress_normal = { fg = "#7aa2f7", bg = "#3b4261" }  
 progress_error = { fg = "#f7768e", bg = "#3b4261" }  
  
[which]  
 cols = 3  
 mask = { bg = "#1a1b26" }  
 cand = { fg = "#7dcfff" }  
 rest = { fg = "#565f89" }  
 desc = { fg = "#bb9af7" }  
 separator = "  "  
 separator_style = { fg = "#565f89" }  
  
[confirm]  
 border = { fg = "#7aa2f7" }  
 title = { fg = "#7aa2f7", bold = true }  
 body = { fg = "#c0caf5" }  
 list = { fg = "#a9b1d6" }  
 btn_yes = { reversed = true }  
 btn_no = {}  
 btn_labels = ["  [Y]es  ", "  (N)o  "]  
  
[spot]  
 border = { fg = "#7aa2f7" }  
 title = { fg = "#7aa2f7" }  
 tbl_col = { fg = "#7dcfff" }  
 tbl_cell = { fg = "#1a1b26", bg = "#e0af68" }  
  
[notify]  
 title_info = { fg = "#9ece6a" }  
 title_warn = { fg = "#e0af68" }  
 title_error = { fg = "#f7768e" }  
  
[input]  
 border = { fg = "#7aa2f7" }  
 title = {}  
 value = {}  
 selected = { reversed = true }  
  
[pick]  
 border = { fg = "#7aa2f7" }  
 active = { fg = "#bb9af7", bold = true }  
 inactive = {}  
  
[cmp]  
 border = { fg = "#7aa2f7" }  
 active = { reversed = true }  
 inactive = {}  
  
[tasks]  
 border = { fg = "#7aa2f7" }  
 title = {}  
 hovered = { fg = "#bb9af7", underline = true }  
  
[help]  
 on = { fg = "#7dcfff" }  
 run = { fg = "#bb9af7" }  
 desc = { fg = "#c0caf5" }  
 hovered = { bg = "#3b4261", bold = true }  
 footer = { fg = "#1a1b26", bg = "#c0caf5" }  
  
[filetype]  
 rules = [  
 # 图片、视频、音频  
 { mime = "image/*", fg = "#7dcfff" },  
 { mime = "video/*", fg = "#e0af68" },  
 { mime = "audio/*", fg = "#e0af68" },  
 # 压缩包  
 { mime = "application/zip", fg = "#f7768e" },  
 { mime = "application/x-7z-compressed", fg = "#f7768e" },  
 { mime = "application/x-rar", fg = "#f7768e" },  
 { mime = "application/x-tar", fg = "#f7768e" },  
 # 文档  
 { mime = "application/pdf", fg = "#bb9af7" },  
 # 空文件、失效链接、可执行文件、目录  
 { mime = "inode/empty", fg = "#565f89" },  
 { name = "*", is = "orphan", bg = "#f7768e" },  
 { name = "*", is = "exec", fg = "#9ece6a" },  
 { name = "*/", fg = "#7aa2f7", bold = true },  
]  
```  
  
三个文件存好后重新打开 yazi 就会生效。如果启动报错，按错误提示里的行号删掉对应配置项再试。  
