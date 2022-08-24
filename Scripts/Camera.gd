extends Camera2D

var player: Node2D
var desired_position : Vector2

func _physics_process(delta):
#	if player and desired_position.distance_squared_to(player.position) > 20*20:
#		desired_position = desired_position.lerp(player.position, 0.1)
	if player:
		position.x = floor(player.position.x)
		position.y = floor(player.position.y)
		printt(position, player.position)
