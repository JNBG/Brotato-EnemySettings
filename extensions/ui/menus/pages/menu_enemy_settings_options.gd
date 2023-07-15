extends Control

const ENEMY_SETTINGS_SAVE_FILE = "user://enemy_settings_save_file.save"
var enemy_settings_save_data  = {}
var current_selected_alien
var current_selected_alien_name

const stats_to_manipulate = [
	{
		"stat": "health",
		"selector": "BaseHealth",
		"type": "SpinBox"
	},{
		"stat": "health_increase_each_wave",
		"selector": "HealthIncrease",
		"type": "SpinBox"
	},{
		"stat": "speed",
		"selector": "Speed",
		"type": "SpinBox"
	},{
		"stat": "damage",
		"selector": "BaseDamage",
		"type": "SpinBox"
	},{
		"stat": "damage_increase_each_wave",
		"selector": "DamageIncrease",
		"type": "SpinBox"
	},{
		"stat": "value",
		"selector": "Value",
		"type": "SpinBox"
	},{
		"stat": "knockback_resistance",
		"selector": "KnockbackResistance",
		"type": "SpinBox"
	},{
		"stat": "can_drop_consumables",
		"selector": "CanDropConsumables",
		"type": "CheckButton"
	},{
		"stat": "always_drop_consumables",
		"selector": "AlwaysDropConsumables",
		"type": "CheckButton"
	},{
		"stat": "base_drop_chance",
		"selector": "BaseDropChance",
		"type": "SpinBox"
	},{
		"stat": "item_drop_chance",
		"selector": "ItemDropChance",
		"type": "SpinBox"
	}
]
const aliens = [
	{
		"name": "Baby Alien",
		"number": "001"
	},{
		"name": "Chaser",
		"number": "002"
	},{
		"name": "Spitter",
		"number": "003"
	},{
		"name": "Charger",
		"number": "004"
	},{
		"name": "Pursuer",
		"number": "005"
	},{
		"name": "Bruiser",
		"number": "006"
	},{
		"name": "Buffer",
		"number": "007"
	},{
		"name": "Fly",
		"number": "008"
	},{
		"name": "Healer",
		"number": "012"
	},{
		"name": "Looter",
		"number": "013"
	},{
		"name": "Helmet Alien",
		"number": "014"
	},{
		"name": "Fin Alien",
		"number": "015"
	},{
		"name": "Spawner",
		"number": "016"
	},{
		"name": "Junkie",
		"number": "017"
	},{
		"name": "Horned Bruiser",
		"number": "018"
	},{
		"name": "Horned Charger",
		"number": "019"
	},{
		"name": "Slasher Egg",
		"number": "023"
	},{
		"name": "Slasher",
		"number": "024"
	},{
		"name": "Tentacle",
		"number": "025"
	},{
		"name": "Lamprey",
		"number": "026"
	}
]
const elites_bosses = [
	{
		"name": "Predator",
		"number": "010"
	},{
		"name": "Invoker",
		"number": "011"
	},{
		"name": "Rhino",
		"number": "020"
	},{
		"name": "Butcher",
		"number": "021"
	},{
		"name": "Monk",
		"number": "022"
	},{
		"name": "Croco",
		"number": "027"
	},{
		"name": "Colossus",
		"number": "028"
	},{
		"name": "Insect",
		"number": "032"
	},{
		"name": "Mom",
		"number": "033"
	},{
		"name": "Demon",
		"number": "034"
	}
]

signal back_button_pressed

onready var back_button = $"%BackButton"
onready var alien_form = $"%AlienFormHolderInner"
onready var alien_info_wrapper = $"%AlienFormWrapper"
onready var reset_button = $"%ResetButton"
onready var alien_name = $"%Name"
onready var alien_buttons = $"%AlienButtons"
onready var elites_bosses_buttons = $"%ElitesBossesButtons"

func _ready():
	pass

func init():
	back_button.grab_focus()
	back_button.connect("pressed", self, "_on_BackButton_pressed")

	_enemy_settings_load_data()

	for alien in aliens:
		alien_buttons.get_node(alien.name.replace(" ","")+"Button").connect("pressed", self, "_on_enemy_button_pressed", [alien.name, alien.number])
		if _alien_was_modified(alien.number):
			alien_buttons.get_node(alien.name.replace(" ","")+"Button/IsModified").visible = true
		else:
			alien_buttons.get_node(alien.name.replace(" ","")+"Button/IsModified").visible = false

	for elite_boss in elites_bosses:
		elites_bosses_buttons.get_node(elite_boss.name.replace(" ","")+"Button").connect("pressed", self, "_on_enemy_button_pressed", [elite_boss.name, elite_boss.number])
		if _alien_was_modified(elite_boss.number):
			elites_bosses_buttons.get_node(elite_boss.name.replace(" ","")+"Button/IsModified").visible = true
		else:
			elites_bosses_buttons.get_node(elite_boss.name.replace(" ","")+"Button/IsModified").visible = false

	reset_button.connect("pressed", self, "_on_reset_button_pressed")

	for single_stat in stats_to_manipulate:
		alien_info_wrapper.get_node("Inputs/"+single_stat.selector+"/"+single_stat.type).connect("value_changed", self, "_save_single_value", [single_stat.stat]);
		alien_info_wrapper.get_node("Inputs/"+single_stat.selector+"/"+single_stat.type).connect("toggled", self, "_save_single_value", [single_stat.stat]);


func _on_enemy_button_pressed(name, alienid):

	current_selected_alien = alienid;
	current_selected_alien_name = name;
	var base_stats = load("res://mods-unpacked/MincedMeatMole-EnemySettings/ui/enemies/"+alienid+"/init_"+str(int(alienid))+"_stats.tres");
	alien_name.text = name

	for single_stat in stats_to_manipulate:

		var val = base_stats[single_stat.stat]
		var base = base_stats[single_stat.stat]
		if alienid in enemy_settings_save_data:
			if single_stat.stat in enemy_settings_save_data[alienid]:
				val = enemy_settings_save_data[alienid][single_stat.stat]

		if (single_stat.stat == "base_drop_chance" or single_stat.stat == "item_drop_chance"):
			val = val*100
			base = base*100

		if (single_stat.type == "SpinBox"):
			alien_info_wrapper.get_node("Inputs/"+single_stat.selector+"/"+single_stat.type).value = val
			alien_info_wrapper.get_node("Defaults/"+single_stat.selector+"/Initial").text = str(base)
		if (single_stat.type == "CheckButton"):
			alien_info_wrapper.get_node("Inputs/"+single_stat.selector+"/"+single_stat.type).pressed = val
			if (base_stats[single_stat.stat]):
				alien_info_wrapper.get_node("Defaults/"+single_stat.selector+"/Initial").text = tr("ENEMY_SETTINGS_YES")
			else:
				alien_info_wrapper.get_node("Defaults/"+single_stat.selector+"/Initial").text = tr("ENEMY_SETTINGS_NO")


	alien_form.visible = true
	if _alien_was_modified(alienid):
		reset_button.visible = true

	var alien_data = load("res://entities/units/enemies/"+current_selected_alien+"/"+str(int(current_selected_alien))+"_stats.tres")

	for single_stat in stats_to_manipulate:
		var input = alien_info_wrapper.get_node("Inputs/"+single_stat.selector+"/"+single_stat.type)
		var val
		if !current_selected_alien in enemy_settings_save_data:
			enemy_settings_save_data[current_selected_alien] = {}
		if (single_stat.type == "SpinBox"):
			val = input.value
		if (single_stat.type == "CheckButton"):
			val = input.pressed

		if (single_stat.stat == "base_drop_chance" or single_stat.stat == "item_drop_chance"):
			val = val/100

		alien_data[single_stat.stat] = val
		enemy_settings_save_data[current_selected_alien][single_stat.stat] = val

	var alien_button_ismod = alien_buttons.get_node(current_selected_alien_name.replace(" ","")+"Button/IsModified")
	var elite_boss_button_ismod = elites_bosses_buttons.get_node(current_selected_alien_name.replace(" ","")+"Button/IsModified")
	var alien_was_modified = _alien_was_modified(current_selected_alien)
	if (alien_button_ismod != null):
		if alien_was_modified:
			alien_button_ismod.visible = true
		else:
			alien_button_ismod.visible = false
	if (elite_boss_button_ismod != null):
		if alien_was_modified:
			elite_boss_button_ismod.visible = true
		else:
			elite_boss_button_ismod.visible = false

	if alien_was_modified:
		reset_button.visible = true


	_enemy_settings_save_data()

func _save_single_value(value, stat):
	var alien_data = load("res://entities/units/enemies/"+current_selected_alien+"/"+str(int(current_selected_alien))+"_stats.tres")

	if !current_selected_alien in enemy_settings_save_data:
		enemy_settings_save_data[current_selected_alien] = {}
	if (stat == "base_drop_chance" or stat == "item_drop_chance"):
		value = value/100

	alien_data[stat] = value
	enemy_settings_save_data[current_selected_alien][stat] = value

	var alien_button_ismod = alien_buttons.get_node(current_selected_alien_name.replace(" ","")+"Button/IsModified")
	var elite_boss_button_ismod = elites_bosses_buttons.get_node(current_selected_alien_name.replace(" ","")+"Button/IsModified")
	var alien_was_modified = _alien_was_modified(current_selected_alien)
	if (alien_button_ismod != null):
		if alien_was_modified:
			alien_button_ismod.visible = true
		else:
			alien_button_ismod.visible = false
	if (elite_boss_button_ismod != null):
		if alien_was_modified:
			elite_boss_button_ismod.visible = true
		else:
			elite_boss_button_ismod.visible = false

	if alien_was_modified:
		reset_button.visible = true
		
	_enemy_settings_save_data()


func _on_reset_button_pressed():
	var alien_data = load("res://entities/units/enemies/"+current_selected_alien+"/"+str(int(current_selected_alien))+"_stats.tres")
	var default_data = load("res://mods-unpacked/MincedMeatMole-EnemySettings/ui/enemies/"+current_selected_alien+"/init_"+str(int(current_selected_alien))+"_stats.tres");

	for single_stat in stats_to_manipulate:
		if !current_selected_alien in enemy_settings_save_data:
			enemy_settings_save_data[current_selected_alien] = {}

		alien_data[single_stat.stat] = default_data[single_stat.stat]
		enemy_settings_save_data[current_selected_alien][single_stat.stat] = default_data[single_stat.stat]

	_enemy_settings_save_data()
	_on_enemy_button_pressed(current_selected_alien_name, current_selected_alien)

	var alien_button_ismod = alien_buttons.get_node(current_selected_alien_name.replace(" ","")+"Button/IsModified")
	if (alien_button_ismod != null):
		alien_button_ismod.visible = false
	var elite_boss_button_ismod = elites_bosses_buttons.get_node(current_selected_alien_name.replace(" ","")+"Button/IsModified")
	if (elite_boss_button_ismod != null):
		elite_boss_button_ismod.visible = false

	reset_button.visible = false

func _alien_was_modified(number):
	var isModified = false
	if number in enemy_settings_save_data:
		var base_stats = load("res://mods-unpacked/MincedMeatMole-EnemySettings/ui/enemies/"+number+"/init_"+str(int(number))+"_stats.tres")
		for single_stat in stats_to_manipulate:
			var visibleDot = false
			var labelDot = alien_info_wrapper.get_node("Labels/"+single_stat.selector+"/Label/IsModified")
			if single_stat.stat in enemy_settings_save_data[number]:
				if str(enemy_settings_save_data[number][single_stat.stat]) != str(base_stats[single_stat.stat]):
					isModified = true
					visibleDot = true
			if visibleDot:
				labelDot.visible = true
			else:
				labelDot.visible = false
	else:
		for single_stat in stats_to_manipulate:
			alien_info_wrapper.get_node("Labels/"+single_stat.selector+"/Label/IsModified").visible = false
	return isModified

func _enemy_settings_save_data():
	var file = File.new()
	file.open(ENEMY_SETTINGS_SAVE_FILE, File.WRITE)
	file.store_var(enemy_settings_save_data)
	file.close()


func _enemy_settings_load_data():
	var file = File.new()
	if not file.file_exists(ENEMY_SETTINGS_SAVE_FILE):
		enemy_settings_save_data = {}
		_enemy_settings_save_data()
	file.open(ENEMY_SETTINGS_SAVE_FILE, File.READ)
	enemy_settings_save_data = file.get_var()
	file.close()

func _on_BackButton_pressed():
	_on_enemy_button_pressed("Baby Alien", "001")
	alien_form.visible = false
	reset_button.visible = false
	emit_signal("back_button_pressed")
