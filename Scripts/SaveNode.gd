extends StaticBody2D

signal player_entered
var is_already_active
# Called when the node enters the scene tree for the first time.
func _ready():
	is_already_active = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_save_area_body_entered(body):
	if body.name == "Player" and !is_already_active:
		is_already_active = true
		$SaveSound.play()
		player_entered.emit()
		$SavedLabel.text = "POSITION SAVED"
		await get_tree().create_timer(2).timeout
		$SavedLabel.text = ""
