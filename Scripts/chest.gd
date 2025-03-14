extends Node2D

var config = ConfigFile.new()

# Load data from a file.
var config_file = config.load("res://Ressources/PropertieFile/properties.cfg")

var level_number=0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func set_level_number(number_from_level):
	level_number = number_from_level
	
func save_level_chest_picked():
	if level_number == 1:
		config.set_value("Chests", "level_one_chest", true)
	if level_number == 2:
		config.set_value("Chests", "level_two_chest", true)
	if level_number == 3:
		config.set_value("Chests", "level_three_chest", true)
	if level_number == 4:
		config.set_value("Chests", "level_four_chest", true)
	if level_number == 5:
		config.set_value("Chests", "level_five_chest", true)
	config.save("res://Ressources/PropertieFile/properties.cfg")


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		var current_chest_number = config.get_value("Chests", "chestNumber")
		var new_chest_number = current_chest_number+1
		config.set_value("Chests", "chestNumber", new_chest_number)
		config.save("res://Ressources/PropertieFile/properties.cfg")
		save_level_chest_picked()
		for n in 6:
			self.hide()
			await get_tree().create_timer(0.2).timeout;
			self.show()
			await get_tree().create_timer(0.2).timeout;
		queue_free()
	
func chest_already_picked():
	queue_free()
