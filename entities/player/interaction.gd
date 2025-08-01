extends Area3D

signal hold_started
signal hold_progressed(progress: float)
signal hold_ended

var _can_interact := true

var _current_interactions: Array[Interactable]
var _nearest_interaction: Interactable:
	get:
		return _current_interactions.front()

var _hold_interaction: Interactable
var _hold_time := 0.0


#region Built-in
func _init() -> void:
	Utils.safe_connect(area_entered, _on_area_entered)
	Utils.safe_connect(area_exited, _on_area_exited)


func _physics_process(delta: float) -> void:
	if _current_interactions.is_empty(): return

	_update_interactions()
	# Continuously checks for interactions to allow holding down the button.
	_try_interacting(delta)
#endregion


#region Interactions
func _update_interactions() -> void:
	var last_nearest := _nearest_interaction
	_current_interactions.sort_custom(Utils.sort_by_nearest.bind(global_position))
	if _nearest_interaction != last_nearest:
		last_nearest.set_highlight(false)

	if _nearest_interaction.is_interactable:
		_nearest_interaction.set_highlight(true)


func _try_interacting(delta: float) -> void:
	if not _can_interact: return
	if not _nearest_interaction: return

	if Input.is_action_pressed(&"interact"):
		if not _hold_interaction:
			_start_hold()
		_advance_hold(delta)
	else:
		_reset_hold()


func _interact(interaction: Interactable) -> void:
	_can_interact = false
	await interaction.interact.call(owner)
	_can_interact = true
#endregion


#region Hold
func _start_hold() -> void:
	_hold_interaction = _nearest_interaction
	_hold_time = 0.0
	hold_started.emit()


func _advance_hold(delta: float) -> void:
	_hold_time += delta
	hold_progressed.emit(_hold_time / _hold_interaction.hold_time)

	if _hold_time >= _hold_interaction.hold_time:
		_interact(_hold_interaction)
		_reset_hold()
		hold_ended.emit()


func _reset_hold() -> void:
	_hold_interaction = null
#endregion


#region Signal Handlers
func _on_area_entered(area: Interactable) -> void:
	assert(area is Interactable)
	_current_interactions.push_back(area)


func _on_area_exited(area: Interactable) -> void:
	assert(area is Interactable)

	if area == _hold_interaction:
		_reset_hold()

	_current_interactions.erase(area)
	area.set_highlight(false)
#endregion
