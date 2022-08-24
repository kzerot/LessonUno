extends Resource
class_name CharacterData
@export_category(Visual)
@export
var texture: Texture2D
@export
var rows: int
@export
var cols: int
@export
var animations: Array[Resource]

@export_category(Data)
@export
var name: StringName

@export
var max_hp: int = 10
