extends Node2D
signal cannon_ball_touch_object
var is_ball_explode
var is_ball_going_left
var has_touch_player
var ball_speed = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	is_ball_explode = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_ball_going_left and !is_ball_explode:
		self.position.x -= ball_speed
	if !is_ball_going_left and !is_ball_explode:
		self.position.x += ball_speed


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		body.set_physics_process(false)
	set_process(false)
	$Sprite2D.texture = load("res://Arts/CanonSprite/ExplosionSprite-removebg-preview.png")
	await get_tree().create_timer(0.25).timeout
	is_ball_explode = true
	if body.name == "Player":
		has_touch_player = true
	else:
		has_touch_player = false
	cannon_ball_touch_object.emit()
