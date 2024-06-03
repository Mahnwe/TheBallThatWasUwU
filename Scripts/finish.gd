extends StaticBody2D

signal player_entered
signal player_exited

# Called when the node enters the scene tree for the first time.
func _ready():
	$WellDoneLabel.hide()
	$FinishLabelNextLevel.hide()
	$FinishLabelMenu.hide()
	$ColorRect.hide()
	$ColorRect2.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player_entered.emit()
		$WellDoneLabel.show()
		await get_tree().create_timer(1.5).timeout
		$FinishLabelNextLevel.show()
		$FinishLabelMenu.show()
		$ColorRect.show()
		$ColorRect2.show()
