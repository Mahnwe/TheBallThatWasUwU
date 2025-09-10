extends Sprite2D

var properties_config = ConfigFile.new()
# Load data from a file.
var properties_file = properties_config.load("res://Ressources/PropertieFile/properties.cfg")

var is_paused

@export var beam_x_scale = 0.0
@export var beam_y_position = 0.0
@export var charge_timer = 0.0
@export var beam_timer = 0.0
@export var wait_timer = 0.0

signal laser_touched_player

# Called when the node enters the scene tree for the first time.
func _ready():
	set_volume()
	is_paused = false
	setup_laser_beam()
	$LaserBeam/Area2D.monitorable = false
	$LaserBeam.visible = false
	$LaserBeam/Area2D/CollisionShape2D.disabled = true
	if wait_timer != 0.0:
		$WaitTimer.start(wait_timer)
	else:
		first_charge_beam()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	final_charge_trigger()
	if is_paused:
		for member in get_tree().get_nodes_in_group("laser_timer"):
			member.set_paused(true)
		$LaserSound.stream_paused = true
		$LaserChargeSound.stream_paused = true
	else:
		for member in get_tree().get_nodes_in_group("laser_timer"):
			member.set_paused(false)
		$LaserSound.stream_paused = false
		$LaserChargeSound.stream_paused = false
	
func setup_laser_beam():
	if beam_x_scale != 0.0:
		$LaserBeam.scale.x *= beam_x_scale
	$LaserBeam.position.y -= beam_y_position
	$ChargeTimer.set_wait_time(charge_timer)
	$BeamTimer.set_wait_time(beam_timer)
	
	
func first_charge_beam():
	$ChargeTimer.start()
	$LaserCharge.visible = true
	$LaserCharge.play()
	$LaserChargeSound.play()
	
func final_charge_trigger():
	if $ChargeTimer.time_left <= 1.5:
		$LaserCharge.animation = "final_charge"
		$LaserCharge.play()

func _on_beam_timer_timeout():
	$LaserSound.stop()
	$ChargeTimer.start()
	$LaserBeam/Area2D.monitoring = false
	$LaserBeam.visible = false
	$LaserCharge.visible = true
	$LaserCharge.animation = "laser_charge"
	$LaserCharge.play()
	$LaserChargeSound.play()

func _on_charge_timer_timeout():
	$LaserChargeSound.stop()
	$BeamTimer.start()
	$LaserCharge.visible = false
	$LaserBeam.visible = true
	$LaserBeam/Area2D/CollisionShape2D.disabled = false
	$LaserBeam/Area2D.monitoring = true
	$LaserBeam.play()
	$LaserSound.play()


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		body.player_killer_name = "Laser"
		laser_touched_player.emit()


func _on_wait_timer_timeout():
	first_charge_beam()


func _on_laser_sound_finished():
	if $BeamTimer.time_left != 0.0:
		$LaserSound.play()


func _on_laser_charge_sound_finished():
	if $ChargeTimer.time_left != 0.0:
		$LaserChargeSound.play()
		
func set_volume():
	for member in get_tree().get_nodes_in_group("sound_effect_group"):
		member.volume_db = properties_config.get_value("effectVolume","effectVolumeSet")
