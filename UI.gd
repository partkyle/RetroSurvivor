extends CanvasLayer

@onready var kill_label := $VBoxContainer/Kills
@onready var alive_label := $VBoxContainer/Alive
@onready var total_label := $VBoxContainer/Total

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


func _on_signal_bus_enemy_died(enemy):
	kills += 1
	alive -= 1


func _on_signal_bus_enemy_spawned(enemy):
	alive += 1
	total += 1
