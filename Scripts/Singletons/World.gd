extends Node

# Наши константы
const MAP_ROOT = "res://Scenes/Maps/"

# Тут хранится наша текущая сцена. Это был очень важный комментарий.
var current_scene : Node

# Мы не будем пользоваться встроенной командой change scene. Но узнать, какая сцена
# у нас идёт изначально, хотелось бы. 
func _ready():
	current_scene = get_tree().current_scene

# Небольшой хелпер - чтобы не писать каждый раз полностью название карты.
func change_map(map_name: String, params={}):
	var path = MAP_ROOT.plus_file(map_name + ".tscn")
	change_scene(path, params)
	
# Код смены сцены
func change_scene(path: String, params={}):
	if ResourceLoader.exists(path):
		if is_instance_valid(current_scene):
			current_scene.queue_free()
		# Для тяжелых сцен где-то в этом месте можно было бы воткнуть лоадер, но
		# у нас всё грузится практически моментально - поэтому пока "покатит".
		current_scene = load(path).instantiate()
		get_tree().root.add_child(current_scene)
		# Для смены карты, к примеру, нам нужно знать, где спавнить игрока. 
		# В такие моменты нас спасёт вызов init с переданными параметрами!
		if current_scene.has_method("init"):
			current_scene.call_deferred("init", params)
	else:
		printerr("No such scene: ", path)
