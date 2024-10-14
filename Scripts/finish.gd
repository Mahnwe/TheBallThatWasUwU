extends StaticBody2D

signal player_entered
signal next_level_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	$WellDoneLabel.hide()
	$FinishUI.hide()
	$FinishUI.get_child(0).hide()
	$FinishUI.get_child(1).hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player_entered.emit()
		$WellDoneLabel.show()
		$FinishUI.is_UI_showing = true
		$FinishUI.show()
		$FinishUI.get_child(0).show()
		$FinishUI.get_child(1).show()

func _on_finish_ui_next_level_pressed():
	next_level_pressed.emit()
