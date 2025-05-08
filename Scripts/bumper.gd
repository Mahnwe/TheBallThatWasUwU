extends Node2D

var is_trigger
signal player_hit_bumper

func _ready():
	is_trigger = false
	
func _process(_delta):
	pass

func _on_bumper_trigger_body_entered(body):
	if body.name == "Player":
		if !is_trigger:
			$AnimatedSprite2D.play()
			is_trigger = true
			player_hit_bumper.emit()


func _on_animated_sprite_2d_animation_finished():
	is_trigger = false
