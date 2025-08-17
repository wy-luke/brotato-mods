extends Node

const MOD_DIR = "DoDaLi-ShowDPS/"
const BFX_LOG_MOD_MAIN = "DoDaLi-ShowDPS"

var dir = ""
var ext_dir = ""

func _init():
	ModLoaderLog.info("Init", BFX_LOG_MOD_MAIN)
	dir = ModLoaderMod.get_unpacked_dir() + MOD_DIR
	ext_dir = dir + "extensions/"

	# Add extensions
	var extensions = [
		"singletons/run_data.gd",
		"entities/units/enemies/enemy.gd",
		"ui/hud/show_dps.gd",
	]

	for path in extensions:
		ModLoaderMod.install_script_extension(ext_dir + path)


func _ready():
	ModLoaderLog.info("Done", BFX_LOG_MOD_MAIN)
