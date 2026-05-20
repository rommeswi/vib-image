import re, pathlib

p = pathlib.Path('/usr/local/share/neo-ai/main.py')
src = p.read_text()
src = re.sub(
    r"(\s*)config_path = os\.path\.join\(script_dir, 'config', 'config\.yaml'\)",
    r"\1user_config = os.path.expanduser('~/.config/neo-ai/config.yaml')\n"
    r"\1config_path = user_config if os.path.exists(user_config) else os.path.join(script_dir, 'config', 'config.yaml')",
    src
)
p.write_text(src)
