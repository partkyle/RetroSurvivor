extends Control

signal select_powerup(powerup: PowerUp, rarity: PowerUp.Rarity)


@onready var signal_bus := %SignalBus

@onready var ui_choices : Array[Choice] = [
	%Choice1,
	%Choice2,
	%Choice3,
]

@export var choices : Array[PowerUp]

func _ready():
	# set up a reference to this parent so we can send signals back
	for c in ui_choices:
		c.set_control_parent(self)
	setup_choices()

	PlayerStats.level_up.connect(_on_player_level_up)
	select_powerup.connect(PlayerStats.select_powerup)



var previous_level := 1

func _on_player_level_up(level):
	if level != previous_level:
		signal_bus.pause_game.emit()
		setup_choices()
		previous_level = level
		show()

		if Settings.auto_level:
			ui_choices[0]._control_parent.emit_signal('select_powerup', ui_choices[0]._powerup, ui_choices[0]._rarity)

func setup_choices():
	for i in ui_choices.size():
		var c := ui_choices[i]
		c.set_powerup(random_powerup(), random_rarity())


func random_powerup() -> PowerUp:
	return choices.pick_random()

func random_rarity() -> PowerUp.Rarity:
	var r := randf()

	if r < 0.05:
		return PowerUp.Rarity.LEGENDARY
	elif r < 0.25:
		return PowerUp.Rarity.EPIC
	elif r < 0.60:
		return PowerUp.Rarity.RARE

	return PowerUp.Rarity.COMMON


func _on_select_powerup(powerup, rarity):
	hide()
	signal_bus.unpause_game.emit()


func _on_auto_level_check_box_toggled(toggled_on: bool) -> void:
	Settings.auto_level = toggled_on
