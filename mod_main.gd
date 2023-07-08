extends Node

const MOD_DIR = "MincedMeatMole-EnemySettings/"
const ENEMY_SETTINGS_LOG = "MincedMeatMole-EnemySettings"
const ENEMY_SETTINGS_SAVE_FILE = "user://enemy_settings_save_file.save"

var dir = ""
var ext_dir = ""
var trans_dir = ""
var enemy_settings_save_data  = {}


func _init(modLoader = ModLoader):
	ModLoaderLog.info("Init", ENEMY_SETTINGS_LOG)
	dir = ModLoaderMod.get_unpacked_dir() + MOD_DIR
	
	# Add Extensions
	ModLoaderMod.install_script_extension(dir + "extensions/ui/menus/pages/menu_choose_options.gd")
	ModLoaderMod.install_script_extension(dir + "extensions/ui/menus/menus.gd")
	
	# Add localizations
	ModLoaderMod.add_translation(dir + "translations/enemy_setting_translations.en.translation")
	ModLoaderMod.add_translation(dir + "translations/enemy_setting_translations.de.translation")


func _ready()->void:
	_enemy_settings_load_data()
	if (enemy_settings_save_data != null):
		for enemy in enemy_settings_save_data:
			var alien_data = load("res://entities/units/enemies/"+enemy+"/"+str(int(enemy))+"_stats.tres")
			for value in enemy_settings_save_data[enemy]:
				alien_data[value] = enemy_settings_save_data[enemy][value]
	
	ModLoaderLog.info("Ready", ENEMY_SETTINGS_LOG)

func _enemy_settings_load_data():
	var file = File.new()
	if not file.file_exists(ENEMY_SETTINGS_SAVE_FILE):
		enemy_settings_save_data = {}
	file.open(ENEMY_SETTINGS_SAVE_FILE, File.READ)
	enemy_settings_save_data = file.get_var()
	file.close()
