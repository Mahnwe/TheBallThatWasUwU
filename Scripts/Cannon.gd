extends Node2D

var cannon_ball = preload("res://Scenes/cannon_ball.tscn")

@export var is_going_left = true

var cannon_ball_inst
var cannon_ball_has_touch_player
signal player_dead_by_cannon_ball

@export var flip_value = 0
@export var ball_speed = 0
@export var is_in_water = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_volume()
	if is_in_water:
		$Sprite2D.self_modulate.a = 0.5
	if flip_value != 0:
		$Sprite2D.flip_h = true
	shoot_cannon_ball()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if cannon_ball_inst.is_ball_explode == true:
		on_cannon_ball_exploding()
		remove_cannon_ball()
		shoot_cannon_ball()
	
	
func shoot_cannon_ball():
	cannon_ball_inst = cannon_ball.instantiate()
	add_child(cannon_ball_inst)
	$CannonSound.play()
	cannon_ball_inst.ball_speed = ball_speed
	cannon_ball_inst.cannon_ball_touch_object.connect(on_cannon_ball_exploding)
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
	
func remove_cannon_ball():
	self.remove_child(cannon_ball_inst)
	cannon_ball_inst.free()
	
func pause_cannon():
	set_process(false)
	if(self.get_child(3) != null):
		self.get_child(3).set_process(false)
	
func unpause_cannon():
	set_process(true)
	if(self.get_child(3) != null):
		self.get_child(3).set_process(true)
		
func set_volume():
	for member in get_tree().get_nodes_in_group("sound_effect_group"):
		member.volume_db = $SaveManager.get_properties_value("effectVolume","effectVolumeSet")
