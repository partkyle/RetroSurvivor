class_name Choice
extends Node

@onready var panel := %Panel
@onready var title := %Title
@onready var icon := %Icon
@onready var description := %Description

@export var stylebox : StyleBox

var _powerup : PowerUp
var _rarity : PowerUp.Rarity
var _control_parent : Node

func _ready():
	panel.add_theme_stylebox_override("panel", stylebox)

func set_control_parent(parent: Node):
	_control_parent = parent


func set_powerup(powerup: PowerUp, rarity: PowerUp.Rarity):
	_powerup = powerup
	_rarity = rarity
	icon.texture = powerup.icon

	stylebox.border_color = PowerUp.RARITY_TO_COLOR[rarity]

	title.text = powerup.name
	description.text = powerup.get_description(rarity)


func _on_panel_gui_input(event):
	if event is InputEventMouseButton:
		_control_parent.emit_signal('select_powerup', _powerup, _rarity)
