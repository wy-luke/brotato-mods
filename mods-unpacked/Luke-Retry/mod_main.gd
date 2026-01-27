extends Node

const LUKE_RETRY_DIR := "Luke-Retry"
const LUKE_RETRY_LOG_NAME := "Luke-Retry:Main"

var mod_dir_path := ""
var extensions_dir_path := ""

func _init() -> void:
	mod_dir_path = ModLoaderMod.get_unpacked_dir().plus_file(LUKE_RETRY_DIR)
	extensions_dir_path = mod_dir_path.plus_file("extensions")
	ModLoaderMod.install_script_extension(extensions_dir_path.plus_file("singletons/run_data.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.plus_file("ui/menus/run/base_end_run.gd"))
	add_translations()

func _ready() -> void:
	ModLoaderLog.info("Ready!", LUKE_RETRY_LOG_NAME)

func add_translations() -> void:
	var translations_dir_path := mod_dir_path.plus_file("translations")
	ModLoaderMod.add_translation(translations_dir_path.plus_file("translations.en.translation"))
	ModLoaderMod.add_translation(translations_dir_path.plus_file("translations.zh_Hans_CN.translation"))
