class_name PowerUp
extends Resource

enum Stat { MOVE_SPEED, ATTACK_SPEED, ATTACK_RANGE, ATTACK_DAMAGE, PICKUP_RADIUS, HEALTH_REGEN, VAMPIRISM }
enum Rarity { COMMON, RARE, EPIC, LEGENDARY }

const RARITY_TO_COLOR = {
	Rarity.COMMON: Color.GRAY,
	Rarity.RARE: Color.NAVY_BLUE,
	Rarity.EPIC: Color.REBECCA_PURPLE,
	Rarity.LEGENDARY: Color.DARK_RED,
}

@export var name : String
@export var stat : Stat
@export var description: String
@export var rarity_scaling: Dictionary = {
	Rarity.COMMON: null,
	Rarity.RARE: null,
	Rarity.EPIC: null,
	Rarity.LEGENDARY: null,
}
@export var icon : Texture2D

func get_description(rarity: Rarity) -> String:
	var display = int(rarity_scaling[rarity] * 100)
	return description % [display]
