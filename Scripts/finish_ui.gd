extends Control

signal next_level_pressed
@export var is_UI_showing = false
var is_controller_focused

# Called when the node enters the scene tree for the first time.
func _ready():
	is_controller_focused = false
	is_UI_showing = false
	$Blur.hide()
	$FinishNextLevelButton.hide()
	$FinishMenuButton.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_UI_showing:
		if !is_controller_focused and Input.is_action_pressed("ui_down"):
			$FinishNextLevelButton.grab_focus()
		elif !is_controller_focused and Input.is_action_pressed("ui_right"):
			$FinishNextLevelButton.grab_focus()
		elif !is_controller_focused and Input.is_action_pressed("ui_up"):
			$FinishMenuButton.grab_focus()
		elif !is_controller_focused and Input.is_action_pressed("ui_left"):
			$FinishMenuButton.grab_focus()
		wait_for_focus()
		
		
func wait_for_focus():
	for member in get_tree().get_nodes_in_group("finish_button"):
		if member.is_hovered():
			member.grab_focus()
			is_controller_focused = true
			
			
func _on_next_level_pressed():
	next_level_pressed.emit()


func _on_button_focus_entered():
	if $ButtonSound.is_playing == false:
		$ButtonSound.play()


func _on_next_level_mouse_exited():
	$FinishNextLevelButton.release_focus()
	is_controller_focused = false


func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_menu_mouse_exited():
	$FinishMenuButton.release_focus()
	is_controller_focused = false


func _on_finish_next_level_button_gui_input(event):
	if $FinishNextLevelButton.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_left"):
			accept_event() # prevent the normal focus-stuff from happening
			$FinishMenuButton.grab_focus()
		elif event.is_action_pressed("ui_up"):
			accept_event()
			$FinishMenuButton.grab_focus()
		elif event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right"):
			accept_event() # prevent the normal focus-stuff from happening
			$FinishMenuButton.grab_focus()


func _on_finish_menu_button_gui_input(event):
	if $FinishMenuButton.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_left"):
			accept_event() # prevent the normal focus-stuff from happening
			$FinishNextLevelButton.grab_focus()
		elif event.is_action_pressed("ui_up"):
			accept_event()
			$FinishNextLevelButton.grab_focus()
		elif event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right"):
			accept_event() # prevent the normal focus-stuff from happening
			$FinishNextLevelButton.grab_focus()
