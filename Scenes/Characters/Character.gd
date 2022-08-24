@tool
extends CharacterBody2D
class_name Character

@export_file("*.json")
var character_data :
	set(value):
		if value == null or typeof(value) != TYPE_STRING: 
			return
		print("Parsing json")
		var json = JSON.new()
		var file = File.new()
		if file.open(value, File.READ) == OK:
			if json.parse(file.get_as_text()) == OK:
				load_character(json.get_data())
				character_data = value
			else:
				printerr("Can't parse json! ", value)
				printerr(json.get_error_line())
				printerr(json.get_error_message())
		else:
			printerr("Can't open json! ", value)
	get:
		return character_data
		
@onready
var image: Sprite2D = $Image
@onready
var anim: AnimationPlayer = $AnimationPlayer

# Стандартные характеристики персонажа
var hp = 10
var max_hp = 10

var speed = 100
var direction = Vector2()

func _ready():
	if Engine.is_editor_hint():
		set_physics_process(false)

# Тут мы берём наш ресурс с персонажем (любители json'a могут просто запарсить его)
# И добавляем анимации. Данная функция - для редактора, чтобы было проще работать дальше. 
func load_character(data: Dictionary) -> void:
	if not anim: 
		return
	# Грузить будем только в редакторе - это чисто вспомогательная функция
	if not Engine.is_editor_hint():
		return
	# В годо 4ке всё переделали, и сначала нам надо создать библиотеку анимаций, 


	var anim_lib : AnimationLibrary
	if not anim.has_animation_library(StringName("Main")):
		anim_lib = AnimationLibrary.new()
		anim.add_animation_library(StringName("Main"), anim_lib)
	else:
		anim_lib = anim.get_animation_library(StringName("Main"))

	image.texture = load(data.texture)
	image.hframes = data.cols
	image.vframes = data.rows
	for animation_data in data.animations:
		# Remove old track if exists
		var delay = 0.2
		# Берем анимацию, если она уже есть. Нет - создаем новую. 
		var animation: Animation = Animation.new() if not anim_lib.has_animation(animation_data.name)\
									else anim_lib.get_animation(animation_data.name)
		# То же самое с треком для фреймов (самой анимации), удаляем старый трек, создаем новый. 
		var track_index = animation.find_track("Image:frame", Animation.TYPE_VALUE)
		if track_index >= 0:
			animation.remove_track(track_index)
		track_index = animation.add_track(Animation.TYPE_VALUE)			
		animation.track_set_path(track_index, "Image:frame")
		# И банально добавляем значения. 
		for i in range(animation_data.start_frame, animation_data.end_frame + 1):
			animation.track_insert_key(track_index, (i-animation_data.start_frame)*delay, i)
			print("Add anim %d" % i)
		animation.loop_mode = Animation.LOOP_LINEAR if animation_data.loop \
								else Animation.LOOP_NONE
		anim_lib.add_animation(animation_data.name, animation)
		# Очевидно, что длинну анимации тоже нужно подправить.
		animation.length = delay * (animation_data.end_frame - animation_data.start_frame )

	image.transform.origin = Vector2(0,0)
	transform.origin = Vector2(0,0)
	
func _physics_process(delta):
	# velocity мы будем брать у классов наследников
	before_move(delta)
	velocity = direction * speed
	move_and_slide()
	animate()
	after_move(delta)
	#fix_pixels()
	
func fix_pixels():
	position.x = floor(position.x)
	position.y = floor(position.y)
	
func animate():
	if direction.length_squared() <= 0.1:
		# стоим
		if anim.has_animation("Main/Idle"):
			anim.play("Main/Idle")
	else:
		# Идем
		if anim.has_animation("Main/Run"):
			anim.play("Main/Run")
	
	image.flip_h = direction.x < 0
	
# virtual
func before_move(delta):
	pass
	
# also virtual
func after_move(delta):
	pass

