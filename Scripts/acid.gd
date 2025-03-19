extends AnimatedSprite2D

var stats_config= ConfigFile.new()
var stats_file = stats_config.load("res://Ressources/PropertieFile/stats.cfg")

signal acid_hit
# Called when the node enters the scene tree for the first time.
func _ready():
	self.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		var number_of_death = stats_config.get_value("Stats", "death_number")
		stats_config.set_value("Stats", "death_number", number_of_death+1)
		var number_of_acid_death = stats_config.get_value("Stats", "acid_death_number")
		stats_config.set_value("Stats", "acid_death_number", number_of_acid_death+1)
		stats_config.save("res://Ressources/PropertieFile/stats.cfg")
		acid_hit.emit()
