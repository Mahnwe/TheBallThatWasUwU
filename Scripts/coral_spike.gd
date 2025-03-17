extends StaticBody2D

var stats_config= ConfigFile.new()
var stats_file = stats_config.load("res://Ressources/PropertieFile/stats.cfg")

signal spike_hit
var parent_name
@export var speed = 300
# Called when the node enters the scene tree for the first time.
func _ready():
	parent_name = get_parent()
	$Sprite2D.self_modulate.a = 0.8

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_patrol(delta)

func _on_spike_area_body_entered(body):
	if body.name == "Player":
		var number_of_death = stats_config.get_value("Stats", "death_number")
		stats_config.set_value("Stats", "death_number", number_of_death+1)
		var number_of_coral_death = stats_config.get_value("Stats", "coral_death_number")
		stats_config.set_value("Stats", "coral_death_number", number_of_coral_death+1)
		stats_config.save("res://Ressources/PropertieFile/stats.cfg")
		spike_hit.emit()
		
func _patrol(delta):
	if parent_name.get_name() == "PathFollow2D":
		parent_name.progress += speed * delta
