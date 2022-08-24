@tool
extends Character
class_name PlayerCharacter
# override
func before_move(delta):
	direction = Input.get_vector(
		StringName("left"), 
		StringName("right"), 
		StringName("up"), 
		StringName("down")).normalized()

# override
func after_move(delta):
	pass
