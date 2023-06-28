extends Node

const MOD_DIR = "MincedMeatMole-EnemySettings/"
const NERF_CROC_LOG = "MincedMeatMole-EnemySettings"

var dir = ""
var ext_dir = ""
var trans_dir = ""


func _init(modLoader = ModLoader):
	ModLoaderLog.info("Init", NERF_CROC_LOG)
	dir = ModLoaderMod.get_unpacked_dir() + MOD_DIR



func _ready()->void:
	var croc_data = load("res://entities/units/enemies/027/27_stats.tres")
	croc_data.health_increase_each_wave = 1

	ModLoaderLog.info("Ready", NERF_CROC_LOG)
