extends Node

const LUKE_DMGPERPLAYER_DIR := "Luke-DmgPerPlayer"
const LUKE_DMGPERPLAYER_LOG_NAME := "Luke-DmgPerPlayer:Main"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""

func _init() -> void:
	mod_dir_path = ModLoaderMod.get_unpacked_dir().plus_file(LUKE_DMGPERPLAYER_DIR)
	extensions_dir_path = mod_dir_path.plus_file("extensions")

	ModLoaderMod.install_script_extension(extensions_dir_path.plus_file("main.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.plus_file("singletons/run_data.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.plus_file("entities/units/enemies/enemy.gd"))
	add_translations()

func _ready() -> void:
	ModLoaderLog.info("Ready!", LUKE_DMGPERPLAYER_LOG_NAME)

func add_translations() -> void:
	translations_dir_path = mod_dir_path.plus_file("translations")
	ModLoaderMod.add_translation(translations_dir_path.plus_file("translations.en.translation"))
	ModLoaderMod.add_translation(translations_dir_path.plus_file("translations.zh_Hans_CN.translation"))
