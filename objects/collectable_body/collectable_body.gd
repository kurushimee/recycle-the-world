@tool
@icon("res://objects/collectable_body/icons/collectable.png")
class_name CollectableBody
extends StaticBody3D

const COLLECT_DURATION = 0.8

@export var _interactable: Interactable:
	set(value):
		_interactable = value
		if _interactable:
			_interactable.interact = collect
		if Engine.is_editor_hint():
			_get_configuration_warnings()


func _ready() -> void:
	if Engine.is_editor_hint():
		_get_configuration_warnings()
		return


func collect(player: Player) -> void:
	collision_layer = 0

	var tween := create_tween()
	tween.set_parallel(true)

	tween.tween_property(self, "scale", Vector3.ZERO, COLLECT_DURATION).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "rotation", rotation + Vector3(randf_range(-TAU, TAU), TAU * 3, 0), COLLECT_DURATION)
	tween.tween_method(_arc_movement.bind(player, global_position), 0.0, 1.0, COLLECT_DURATION)

	tween.tween_callback(queue_free).set_delay(COLLECT_DURATION)


func _arc_movement(progress: float, player: Player, start_pos: Vector3) -> void:
	var target_pos: Vector3 = player.global_position
	var mid_point: Vector3 = (start_pos + target_pos) / 2
	mid_point.y += 2.0 * (1.0 - abs(progress - 0.5) * 2.0) # Arc height

	var p1: Vector3 = start_pos.lerp(mid_point, progress * 2.0)
	var p2: Vector3 = mid_point.lerp(target_pos, (progress - 0.5) * 2.0)
	global_position = p1 if progress < 0.5 else p2


func _get_configuration_warnings() -> PackedStringArray:
	if not _interactable:
		return ["CollectableBody requires an Interactable component"]
	return []
