extends Node

var time_elapsed := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	time_elapsed = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_elapsed += delta
	
func _format_seconds(time : float) -> String:
	var hours := time / 3600
	var minutes := time / 60
	var seconds := fmod(time, 60)

	return "%02dh:%02dm:%02ds" % [hours, minutes, seconds]
