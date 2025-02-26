extends StaticBody2D

signal player_entered
@export var sprite_id = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	if sprite_id == 0:
		$Sprite2D.texture = load("res://Arts/AbilitySprite/DashAbilitySprite-removebg-preview.png")
	elif sprite_id == 1:
		$Sprite2D.texture = load("res://Arts/AbilitySprite/DoubleJumpAbilitySprite-removebg-preview.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		$AbilitySound.play()
		player_entered.emit()
		$BubbleTooltip.show()
		$Label2.hide()
		for n in 6:
			$Sprite2D.hide()
			await get_tree().create_timer(0.2).timeout;
			$Sprite2D.show()
			await get_tree().create_timer(0.2).timeout;
		queue_free()
