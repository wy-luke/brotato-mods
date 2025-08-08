extends Node

const MOD_DIR = "wuli-ScorePerPlayer/"
const MOD_LOG = "wuli-ScorePerPlayer"

var dir = ""
var ext_dir = ""

func _init(modLoader = ModLoader):
	ModLoaderUtils.log_info("Init", MOD_LOG)

	dir = modLoader.UNPACKED_DIR + MOD_DIR
	ext_dir = dir + "extensions/" # ! any script extensions should go in this folder, and should follow the same folder structure as vanilla

	# Add extensions
	modLoader.install_script_extension(ext_dir + "ui/menus/pages/main_menu.gd")


func _ready():
	ModLoaderUtils.log_info("Ready", MOD_LOG)
