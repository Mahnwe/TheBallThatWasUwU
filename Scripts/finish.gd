extends StaticBody2D

signal player_entered

# Called when the node enters the scene tree for the first time.
func _ready():
	$WellDoneLabel.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player_entered.emit()
		$WellDoneLabel.show()
