@tool
@icon("res://objects/collectable_body/icons/collectable.png")
class_name CollectableBody
extends StaticBody3D

const COLLECT_DURATION = 0.5
const ARC_HEIGHT = 1.25

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
	tween.tween_property(self, "rotation", rotation + Vector3(randf_range(-TAU, TAU), TAU * 2, 0), COLLECT_DURATION)
	tween.tween_method(_arc_movement.bind(player, global_position), 0.0, 1.0, COLLECT_DURATION)

	tween.tween_callback(queue_free).set_delay(COLLECT_DURATION)


func _arc_movement(progress: float, player: Player, start_pos: Vector3) -> void:
	var target_pos := player.global_position
	var mid_point: Vector3 = (start_pos + target_pos) / 2
	mid_point.y += ARC_HEIGHT

	# Quadratic Bezier curve: B(t) = (1-t)²P₀ + 2(1-t)tP₁ + t²P₂
	var t := progress
	var one_minus_t := 1.0 - t

	global_position = (one_minus_t * one_minus_t * start_pos) + \
										(2.0 * one_minus_t * t * mid_point) + \
										(t * t * target_pos)


func _get_configuration_warnings() -> PackedStringArray:
	if not _interactable:
		return ["CollectableBody requires an Interactable component"]
	return []
