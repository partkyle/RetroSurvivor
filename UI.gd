extends CanvasLayer

@onready var kill_label := $VBoxContainer/Kills
@onready var alive_label := $VBoxContainer/Alive
@onready var total_label := $VBoxContainer/Total
@onready var xp_label := $VBoxContainer/Xp

@onready var level_label := $Progress/ColorRect/Level
@onready var xp_bar := $Progress/XpBar

var kills := 0 :
	set(value):
		kills = value
		kill_label.text = 'Kills: %d' % [kills]

var alive := 0 :
	set(value):
		alive = value
		alive_label.text = 'Alive: %d' % [alive]

var total := 0 :
	set(value):
		total = value
		total_label.text = 'Total: %d' % [total]

var xp := 0 :
	set(value):
		xp = value
		xp_label.text = 'XP: %d' % [xp]


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


func _on_signal_bus_enemy_died(enemy):
	kills += 1
	alive -= 1


func _on_signal_bus_enemy_spawned(enemy):
	alive += 1
	total += 1

func _on_player_level_up(_level):
	level = _level

func _on_player_gain_xp(_xp, _xp_to_next_level):
	xp += _xp
	current_xp = _xp
	xp_to_next_level = _xp_to_next_level
