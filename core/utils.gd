class_name Utils
extends Object
## An always available class for various utilities. All methods must be static.


## Подключает сигнал [param from] к [param to] если он ещё не подключен.
static func safe_connect(from: Signal, to: Callable) -> void:
	if not from.is_connected(to):
		from.connect(to)


## Отключает сигнал [param from] от [param to] если он подключен.
static func safe_disconnect(from: Signal, to: Callable) -> void:
	if from.is_connected(to):
		from.disconnect(to)


static func sort_by_nearest(a: Node3D, b: Node3D, from: Vector3) -> bool:
	var a_dist: float = from.distance_to(a.global_position)
	var b_dist: float = from.distance_to(b.global_position)
	return a_dist < b_dist
