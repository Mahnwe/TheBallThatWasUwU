extends Control

var is_controller_focused = false
var properties_config = ConfigFile.new()

# Load data from a file.
var properties_file = properties_config.load("res://Ressources/PropertieFile/properties.cfg")

func _ready():
	$FrButton.grab_focus()
	
	
func _process(_delta):
	wait_for_focus()
	

func wait_for_focus():
	for member in get_tree().get_nodes_in_group("language_buttons"):
		if member.is_hovered():
			member.grab_focus()
			is_controller_focused = true


func _on_fr_button_pressed():
	properties_config.set_value("Languages", "is_english", false)
	properties_config.save("res://Ressources/PropertieFile/properties.cfg")
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_en_button_pressed():
	properties_config.set_value("Languages", "is_english", true)
	properties_config.save("res://Ressources/PropertieFile/properties.cfg")
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_fr_button_focus_entered():
	$ButtonSound.play()


func _on_en_button_focus_entered():
	$ButtonSound.play()
