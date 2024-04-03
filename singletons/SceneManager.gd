extends Node

signal load_new_scene(reset: bool)

var current_scene : Node = null

var arena_scene = "res://levels/arena.tscn"

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

	load_new_scene.connect(load_handler)

func load_handler(reset: bool):
	if reset:
		reset_arena()
	else:
		load_arena()

func reset_arena():
	LevelStats.reset()
	PlayerStats.reset()
	goto_scene(arena_scene)

func load_arena():
	LevelStats.next_level()
	goto_scene(arena_scene)

# taken from the Godot Documentation
func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	preload_scene(arena_scene)
	call_deferred("_deferred_goto_scene")


var preloaded_scene : Resource = null
func preload_scene(path):
	preloaded_scene = ResourceLoader.load(path)


func _deferred_goto_scene():
	# It is now safe to remove the current scene.
	current_scene.free()

	# Instance the new scene.
	current_scene = preloaded_scene.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene
