extends Node3D

@export var damage_popup : PackedScene

func popup_damage(event: DamageEvent):
	var d := damage_popup.instantiate()
	d.text = '%d' % event.damage
	add_child(d)
	d.global_position = event.global_position

func _on_signal_bus_damage_dealt(event: DamageEvent):
	popup_damage(event)


func _on_player_deal_damage(event):
	popup_damage(event)