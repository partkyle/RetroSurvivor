extends Node

class Stats:
	var level := 0
	var kills := 0
	var total := 0

	var damage_dealt := 0
	var damage_taken := 0

	var start_time := 0
	var end_time := 0

	func _init(_level: int = 1, _start_time = Time.get_ticks_msec()):
		level = _level
		start_time = _start_time

var current_stats = Stats.new()
var stats_log : Array[Stats] = []

var kills :
	get: return current_stats.kills
	set(value): current_stats.kills = value

var total :
	get: return current_stats.total
	set(value): current_stats.total = value

var damage_dealt :
	get: return current_stats.damage_dealt
	set(value): current_stats.damage_dealt = value

var damage_taken :
	get: return current_stats.damage_taken
	set(value): current_stats.damage_taken = value

func next_level():
	print('LevelStats.nextLevel')
	stats_log.push_front(current_stats)
	current_stats = Stats.new(current_stats.level+1)

func reset():
	print('LevelStats.reset')
	stats_log = []
	current_stats = Stats.new()

func stats_text():
	return 'level: %d\n  kills: %d\n  alive: %d\n  total: %d\n  damage_dealt: %d\n  damage_taken: %d\ntotal_damage_dealt: %d\ntotal_damage_taken: %d' % [
		current_stats.level,
		kills,
		total - kills,
		total,
		damage_dealt,
		damage_taken,
		total_damage_dealt(),
		total_damage_taken(),
	]

func total_damage_dealt():
	var total = damage_dealt
	for s in stats_log:
		total += s.damage_dealt
	return total

func total_damage_taken():
	var total = damage_taken
	for s in stats_log:
		total += s.damage_taken
	return total
