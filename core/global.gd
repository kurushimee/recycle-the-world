extends Node


## Waits for [param seconds] amount of seconds.
## Usage: [code]await Global.wait_for(1.0)[/code]
func wait_for(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
