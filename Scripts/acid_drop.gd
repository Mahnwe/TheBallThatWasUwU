extends Node2D

var stats_config= ConfigFile.new()
var stats_file = stats_config.load("res://Ressources/PropertieFile/stats.cfg")

var drop_exploded
signal drop_touched
@export var speed = 200
# Called when the node enters the scene tree for the first time.
func _ready():
	drop_exploded = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().progress_ratio == 0 and $WaitTimer.time_left == 0.0:
		drop_exploded = false
		$AnimatedSprite2D.animation = "AcidDrop"
		get_parent().progress += speed * delta
	check_for_explosion_animation()


func check_for_explosion_animation():
	if(get_parent().progress_ratio == 1):
		$AnimatedSprite2D.animation = "AcidExplosion"
		$AnimatedSprite2D.play()
		await $AnimatedSprite2D.animation_finished
		drop_exploded = true
		var random = RandomNumberGenerator.new()
		random.randomize()
		$WaitTimer.start(random.randf())


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		body.player_killer_name = "Acid"
		drop_touched.emit()
