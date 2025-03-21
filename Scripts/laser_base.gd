extends Sprite2D

var stats_config= ConfigFile.new()
var stats_file = stats_config.load("res://Ressources/PropertieFile/stats.cfg")

@export var beam_x_scale = 0
@export var beam_y_position = 0
@export var charge_timer = 0.0
@export var beam_timer = 0.0

signal laser_touched_player

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_laser_beam()
	$LaserBeam/Area2D.monitorable = false
	$LaserBeam.visible = false
	first_charge_beam()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	final_charge_trigger()
	
func setup_laser_beam():
	if beam_x_scale != 0:
		$LaserBeam.scale.x *= beam_x_scale
	$LaserBeam.position.y -= beam_y_position
	$ChargeTimer.set_wait_time(charge_timer)
	$BeamTimer.set_wait_time(beam_timer)
	
	
func first_charge_beam():
	$ChargeTimer.start()
	$LaserCharge.visible = true
	$LaserCharge.play()
	
func final_charge_trigger():
	if $ChargeTimer.time_left <= 1.5:
		$LaserCharge.animation = "final_charge"
		$LaserCharge.play()

func _on_beam_timer_timeout():
	$ChargeTimer.start()
	$LaserBeam.visible = false
	$LaserBeam/Area2D.monitoring = false
	$LaserCharge.visible = true
	$LaserCharge.animation = "laser_charge"
	$LaserCharge.play()

func _on_charge_timer_timeout():
	$BeamTimer.start()
	$LaserCharge.visible = false
	$LaserBeam.visible = true
	$LaserBeam/Area2D.monitoring = true
	$LaserBeam.play()


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		var number_of_death = stats_config.get_value("Stats", "death_number")
		stats_config.set_value("Stats", "death_number", number_of_death+1)
		var number_of_laser_death = stats_config.get_value("Stats", "laser_death_number")
		stats_config.set_value("Stats", "laser_death_number", number_of_laser_death+1)
		stats_config.save("res://Ressources/PropertieFile/stats.cfg")
		laser_touched_player.emit()
