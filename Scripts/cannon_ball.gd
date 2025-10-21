extends Node2D

signal cannon_ball_touch_object
var is_ball_explode
var is_ball_going_left
var has_touch_player
var ball_speed = 0
@export var rotation_speed = 2500


# Called when the node enters the scene tree for the first time.
func _ready():
	set_volume()
	if get_parent().is_in_water:
		$Sprite2D.self_modulate.a = 0.5
	is_ball_explode = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_ball_going_left and !is_ball_explode:
		self.position.x -= ball_speed
		self.rotate((delta / 10) * deg_to_rad(rotation_speed))
	if !is_ball_going_left and !is_ball_explode:
		self.position.x += ball_speed
		self.rotate((delta / 10) * deg_to_rad(rotation_speed))


func _on_area_2d_body_entered(body):
	set_process(false)
	$Explosion.play()
	if body.name == "Player" and !is_ball_explode:
		body.set_physics_process(false)
		body.player_killer_name = "Cannon"
		has_touch_player = true
	else:
		has_touch_player = false
	$Sprite2D.texture = load("res://Arts/CanonSprite/ExplosionSprite-removebg-preview.png")
	await get_tree().create_timer(0.25).timeout
	is_ball_explode = true
	cannon_ball_touch_object.emit()
	
func set_volume():
	for member in get_tree().get_nodes_in_group("sound_effect_group"):
		member.volume_db = $SaveManager.get_properties_value("effectVolume","effectVolumeSet")
