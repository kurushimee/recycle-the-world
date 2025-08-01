class_name Utils
extends Object
## An always available class for various utilities. All methods must be static.


## Подключает сигнал [param from] к [param to] если он ещё не подключен.
static func safe_connect(from: Signal, to: Callable) -> void:
	if not from.is_connected(to):
		from.connect(to)
