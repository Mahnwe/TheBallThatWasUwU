extends Control

var level_1 = preload("res://Scenes/level1.tscn")
var is_controller_focused = false
var config = ConfigFile.new()

# Load data from a file.
var config_file = config.load("res://Ressources/PropertieFile/properties.cfg")
var is_level_one_finished = config.get_value("levels","is_level_one_finished")
var is_level_two_finished = config.get_value("levels","is_level_two_finished")
var is_level_three_finished = config.get_value("levels","is_level_three_finished")
# Called when the node enters the scene tree for the first time.
func _ready():
	if !is_level_one_finished:
		$Level2Button.focus_mode = FOCUS_NONE
	else:
		$Level2Button.focus_mode = FOCUS_ALL
	if !is_level_two_finished:
		$Level3Button.focus_mode = FOCUS_NONE
	else:
		$Level3Button.focus_mode = FOCUS_ALL


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	wait_for_focus()
		
func wait_for_focus():
	for member in get_tree().get_nodes_in_group("MenuButtons"):
		if member.is_hovered():
			member.grab_focus()
			is_controller_focused = false
	if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down") and !is_controller_focused:
		$Level1Button.grab_focus()
		is_controller_focused = true


func _on_level_1_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/level1.tscn")


func _on_level_2_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/level2.tscn")


func _on_level_3_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/level3.tscn")


func _on_level_1_button_gui_input(event):
	if has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		if event.is_action_pressed("ui_up", true):
			accept_event() # prevent the normal focus-stuff from happening
			$Level3Button.grab_focus()
		elif event.is_action_pressed("ui_down", true):
			accept_event() # prevent the normal focus-stuff from happening
			$Level2Button.grab_focus()


func _on_level_2_button_gui_input(event):
	if has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		if event.is_action_pressed("ui_up", true):
			accept_event() # prevent the normal focus-stuff from happening
			$Level1Button.grab_focus()
		elif event.is_action_pressed("ui_down", true):
			accept_event() # prevent the normal focus-stuff from happening
			$Level3Button.grab_focus()


func _on_level_3_button_gui_input(event):
	if has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		if event.is_action_pressed("ui_up", true):
			accept_event() # prevent the normal focus-stuff from happening
			$Level2Button.grab_focus()
		elif event.is_action_pressed("ui_down", true):
			accept_event() # prevent the normal focus-stuff from happening
			$Level1Button.grab_focus()