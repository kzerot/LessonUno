extends Node2D
class_name Map

var player: PlayerCharacter

func init(params: Dictionary):
	if "entry" in params and $Entries.has_node(params.entry):
		spawn_player($Entries.get_node(params.entry))
	elif $Entries.get_child_count() > 0:
		spawn_player($Entries.get_child(0))
	else:
		printerr("Have no entry points! The Gods cursed us!")
		
func spawn_player(position: Node2D):
	player = load("res://Scenes/Characters/Playable/Wizzard.tscn").instantiate()
	$Characters.add_child(player)
	$Camera.player = player
