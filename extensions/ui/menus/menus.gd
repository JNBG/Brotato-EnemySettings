extends "res://ui/menus/menus.gd"

var _menu_enemy_settings_options

func _ready():
	_menu_enemy_settings_options = preload("res://mods-unpacked/MincedMeatMole-EnemySettings/ui/menus/enemy_settings_menu.tscn").instance()
	_menu_enemy_settings_options.hide()
	add_child(_menu_enemy_settings_options)
	
	var _error_back_mods_options = _menu_enemy_settings_options.connect("back_button_pressed", self, "on_enemy_settings_back_button_pressed")
	var _error_mods_choose_options = _menu_choose_options.connect("enemy_settings_button_pressed", self, "on_enemy_settings_button_pressed")

func on_enemy_settings_back_button_pressed()->void :
	switch(_menu_enemy_settings_options, _menu_choose_options)

func on_enemy_settings_button_pressed()->void :
	switch(_menu_choose_options, _menu_enemy_settings_options)
