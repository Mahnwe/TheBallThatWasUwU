extends StaticBody2D

signal player_exited_start_area
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		player_exited_start_area.emit()
