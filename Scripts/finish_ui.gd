extends Control

signal next_level_pressed
@export var is_UI_showing = false
var is_controller_focused

# Called when the node enters the scene tree for the first time.
func _ready():
	is_controller_focused = false
	is_UI_showing = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_UI_showing:
		display_tooltip_when_button_focus()
		for member in get_tree().get_nodes_in_group("finish_button"):
			member.focus_mode = FOCUS_ALL
		wait_for_focus()
		
		
func wait_for_focus():
	if is_UI_showing:
		for member in get_tree().get_nodes_in_group("finish_button"):
			if member.is_hovered():
				member.grab_focus()
				is_controller_focused = true
			
			
func _on_next_level_pressed():
	next_level_pressed.emit()


func _on_button_focus_entered():
	if $ButtonSound.finished:
		$ButtonSound.play()
		is_controller_focused = true


func _on_next_level_mouse_exited():
	$FinishNextLevelButton.release_focus()
	is_controller_focused = false


func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_menu_mouse_exited():
	$FinishMenuButton.release_focus()
	is_controller_focused = false
	
func display_tooltip_when_button_focus():
	if is_UI_showing:
		for member in get_tree().get_nodes_in_group("finish_button"):
			if member.has_focus():
				member.get_child(0).show()
			else:
				member.get_child(0).hide()


func _on_finish_next_level_button_gui_input(event):
	if $FinishNextLevelButton.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_up"):
			accept_event() # prevent the normal focus-stuff from happening
			$FinishMenuButton.grab_focus()
		elif event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right"):
			accept_event() # prevent the normal focus-stuff from happening
			$FinishMenuButton.grab_focus()


func _on_finish_menu_button_gui_input(event):
	if $FinishMenuButton.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		is_controller_focused = true
		if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_up"):
			accept_event() # prevent the normal focus-stuff from happening
			$FinishNextLevelButton.grab_focus()
		elif event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right"):
			accept_event() # prevent the normal focus-stuff from happening
			$FinishNextLevelButton.grab_focus()
			
			
func _setup_timer_label_display(player_timer):
	$TimeLabel.text = _format_seconds(player_timer)
	
func _format_seconds(time : float) -> String:
	var minutes := time / 60
	var seconds := fmod(time, 60)
	var milliseconds := fmod(time, 1) * 100

	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]


func _on_finish_next_level_button_mouse_entered():
	$FinishNextLevelButton.grab_focus()
	is_controller_focused = true


func _on_finish_menu_button_mouse_entered():
	$FinishMenuButton.grab_focus()
	is_controller_focused = true
