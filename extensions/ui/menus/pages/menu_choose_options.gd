extends "res://ui/menus/pages/menu_choose_options.gd"

signal enemy_settings_button_pressed

var _enemy_settings_button

func _ready():
	
	_enemy_settings_button = $Buttons / BackButton.duplicate()
	_enemy_settings_button.connect("pressed", self, "_on_enemy_settings_button_pressed")
	_enemy_settings_button.disconnect("pressed", self, "_on_BackButton_pressed")
	_enemy_settings_button.text = "Enemy Settings"
	var option_buttons = $Buttons.get_children()
	var before_to_last_index = $Buttons.get_child_count() - 2
	var before_to_last = option_buttons[before_to_last_index]
	$Buttons.add_child_below_node(before_to_last, _enemy_settings_button)

func _on_enemy_settings_button_pressed()->void : 
	emit_signal("enemy_settings_button_pressed")

