@icon("res://objects/interactable/icons/interactable.png")
class_name Interactable
extends Area3D

@export var is_interactable := true
## Time for holding the interaction. If zero, the interaction will be instant.
@export var hold_time := 0.0

@export_group("Nodes")
## The meshes to which the highlight outline will apply.
@export var _meshes: Array[MeshInstance3D]

var interact := func(_player: Player) -> void: pass

@onready var _outline_material := Preloads.outline_material


func set_highlight(enable: bool) -> void:
	for mesh in _meshes:
		mesh.material_overlay = _outline_material if enable else null
