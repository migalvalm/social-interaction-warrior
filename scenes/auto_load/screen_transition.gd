extends CanvasLayer

signal transitioned_halfway

var skip_emit: bool = false

func transition():
	$AnimationPlayer.play('default')
	await transitioned_halfway
	$AnimationPlayer.play_backwards('default')

func transition_to_scene(scene_path: String, unpause_tree: bool = false) -> void:
	transition()
	await transitioned_halfway
	if unpause_tree: get_tree().paused = false
	get_tree().change_scene_to_file(scene_path)

func emit_transition_halfway():
	transitioned_halfway.emit()
