extends StaticBody2D

signal player_entered
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player_entered.emit()
		$Label.show()
		for n in 8:
			$Sprite2D.hide()
			await get_tree().create_timer(0.2).timeout;
			$Sprite2D.show()
			await get_tree().create_timer(0.2).timeout;
		self.hide()
