extends Area2D

var degrees_per_second = 360.0
@export var is_in_water = false
@export var portal_in = false
var player_teleported
# Called when the node enters the scene tree for the first time.
func _ready():
	player_teleported = false
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
			player_teleported = true
			$Sprite2D.scale.x /= 2.0
			$Sprite2D.scale.y /= 2.0
			await get_tree().create_timer(0.3).timeout
			$Sprite2D.scale.x *= 2.0
			$Sprite2D.scale.y *= 2.0
		if !portal_in:
			if player_teleported:
				print("pouet")
				$Sprite2D.scale.x *= 1.5
				$Sprite2D.scale.y *= 1.5
				await get_tree().create_timer(0.2).timeout
				player_teleported = false
				$Sprite2D.scale.x /= 1.5
				$Sprite2D.scale.y /= 1.5
