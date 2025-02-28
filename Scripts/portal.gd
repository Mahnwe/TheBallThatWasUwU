extends Area2D

var degrees_per_second = 360.0
@export var is_in_water = false
@export var portal_in = false
var player_teleported = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if is_in_water:
		$Sprite2D.self_modulate.a = 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_portal(delta)
	
func rotate_portal(delta):
	$Sprite2D.rotate((delta / 100) * deg_to_rad(degrees_per_second))
	

func _on_body_entered(body):
	if body.name == "Player":
		if portal_in:
			$Sprite2D.animation = "Enter"
			$Sprite2D.play()
			await $Sprite2D.animation_finished
		else:
			$Sprite2D.animation = "Exit"
			$Sprite2D.play()
			await $Sprite2D.animation_finished
		$Sprite2D.animation = "Idle"
