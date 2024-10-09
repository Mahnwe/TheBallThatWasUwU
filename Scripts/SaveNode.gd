extends StaticBody2D

signal player_entered
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_save_area_body_entered(body):
	if body.name == "Player":
		$SaveSound.play()
		player_entered.emit()
		$SavedLabel.text = "POSITION SAVED"
		await get_tree().create_timer(2).timeout
		$SavedLabel.text = ""
