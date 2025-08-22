extends AnimatedSprite2D

signal acid_hit
# Called when the node enters the scene tree for the first time.
func _ready():
	self.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		body.player_killer_name = "Acid"
		acid_hit.emit()
