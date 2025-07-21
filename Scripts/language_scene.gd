extends Control

var is_controller_focused = false
var properties_config = ConfigFile.new()

# Load data from a file.
var properties_file = properties_config.load("res://Ressources/PropertieFile/properties.cfg")

func _ready():
	setup_window_mod()
	check_is_language_selected()
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
	properties_config.set_value("Launch", "is_first_launch", false)
	properties_config.save("res://Ressources/PropertieFile/properties.cfg")
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_en_button_pressed():
	properties_config.set_value("Languages", "is_english", true)
	properties_config.set_value("Launch", "is_first_launch", false)
	properties_config.save("res://Ressources/PropertieFile/properties.cfg")
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_fr_button_focus_entered():
	$ButtonSound.play()


func _on_en_button_focus_entered():
	$ButtonSound.play()
	
	
func setup_window_mod():
	if properties_config.get_value("WindowMod", "is_fullscreen"):
		var player_viewport = get_viewport().size
		DisplayServer.window_set_size(player_viewport)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		properties_config.set_value("WindowMod", "is_fullscreen", true)
	else:
		DisplayServer.window_set_size(Vector2i(1280,720))
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		properties_config.set_value("WindowMod", "is_fullscreen", false)
	properties_config.save("res://Ressources/PropertieFile/properties.cfg")
	
func check_is_language_selected():
	if !properties_config.get_value("Launch", "is_first_launch"):
		call_deferred("go_to_menu")
	
func go_to_menu():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
