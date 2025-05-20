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


func _on_velocity_return_area_body_entered(body):
	if body.name == "Player":
		set_y_check_velocity(body)
		set_x_check_velocity(body)
			
func set_y_check_velocity(body):
	if body.velocity.y <= 0.0:
		body.velocity_y_bumper_check = body.jump_force-100
	elif body.velocity.y >= 0.1 and body.velocity.y <= 690.0:
		body.velocity_y_bumper_check = body.jump_force-100
	else:
		body.velocity_y_bumper_check = body.velocity.y * -1
		
func set_x_check_velocity(body):
	if body.velocity.x < 0.0:
		body.velocity_x_bumper_check = body.speed * 1
	elif body.velocity.x > 0.0:
		body.velocity_x_bumper_check = body.speed * -1
