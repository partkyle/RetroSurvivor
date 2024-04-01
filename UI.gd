extends CanvasLayer

@onready var kill_label := $VBoxContainer/Kills
@onready var stats_label := $VBoxContainer/Stats

@onready var level_label := $Progress/ColorRect/Level
@onready var xp_bar := $Progress/XpBar


var current_xp := 0 :
	set(value):
		current_xp = value
		xp_bar.value = value

var xp_to_next_level := 0 :
	set(value):
		xp_to_next_level = value
		xp_bar.max_value = xp_to_next_level

var level := 0 :
	set(value):
		level = value
		level_label.text = '%d' % [level]


func _process(delta: float):
	kill_label.text = LevelStats.stats_text()
	stats_label.text = PlayerStats.stats_text()

	current_xp = PlayerStats.xp
	xp_to_next_level = PlayerStats.xp_to_next_level
	level = PlayerStats.level
