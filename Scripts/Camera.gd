extends Camera2D

var player: Node2D

func _physics_process(delta):
	if player:
		position.x = floor(player.position.x)
		position.y = floor(player.position.y)

