class_name Player
extends CharacterBody3D

const WALK_SPEED = 6.9
const ROTATION_SPEED = 12.5

@export_group("Nodes")
@export var body: Node3D
@export var camera_pivot: Node3D


func _physics_process(delta: float) -> void:
	_add_gravity(delta)
	_handle_movement(delta)
	move_and_slide()


func _add_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta


## Gets user input and changes character's velocity and rotation appropriately.
func _handle_movement(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	var direction: Vector3 = (camera_pivot.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * WALK_SPEED
		velocity.z = direction.z * WALK_SPEED
		body.rotation.y = _rotation_towards(direction, delta)
	else:
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
		velocity.z = move_toward(velocity.z, 0, WALK_SPEED)


func _rotation_towards(direction: Vector3, delta: float) -> float:
	var target_rotation: float = atan2(direction.x, direction.z)
	return lerp_angle(body.rotation.y, target_rotation, ROTATION_SPEED * delta)
