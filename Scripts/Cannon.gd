extends Node2D

var cannon_ball = preload("res://Scenes/cannon_ball.tscn")
@export var is_going_left = true
var cannon_ball_inst
var cannon_ball_has_touch_player
signal player_dead_by_cannon_ball
@export var flip_value = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if flip_value != 0:
		$Sprite2D.flip_h = true
	shoot_cannon_ball()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if cannon_ball_inst.is_ball_explode == true:
		on_cannon_ball_exploding()
		shoot_cannon_ball()
	
	
func shoot_cannon_ball():
	cannon_ball_inst = cannon_ball.instantiate()
	add_child(cannon_ball_inst)
	cannon_ball_inst.cannon_ball_touch_object.connect(on_cannon_ball_exploding)
	print("ball is created")
	if is_going_left:
		cannon_ball_inst.position.x = -61
		cannon_ball_inst.position.y = -18
		cannon_ball_inst.is_ball_going_left = true
	else:
		cannon_ball_inst.position.x = 61
		cannon_ball_inst.position.y = -18
		cannon_ball_inst.is_ball_going_left = false
		
func on_cannon_ball_exploding():
	if cannon_ball_inst.has_touch_player == true:
		cannon_ball_has_touch_player = true
		set_process(false)
		player_dead_by_cannon_ball.emit()
	if cannon_ball_inst.has_touch_player == false:
		cannon_ball_has_touch_player = false
	remove_cannon_ball()
	print("ball explode")
	
func remove_cannon_ball():
	self.remove_child(cannon_ball_inst)

