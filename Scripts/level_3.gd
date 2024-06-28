extends Node2D

var is_commands_panel_open
var is_paused

var start_position_x = -615
var start_position_y = -1212

var save_position_x = -615
var save_position_y = -1212

var finish_position_x = -4842
var finish_position_y = 245

var config = ConfigFile.new()
# Load data from a file.
var config_file = config.load("res://Ressources/PropertieFile/properties.cfg")

var queue = preload("res://Ressources/Save_game.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	queue.is_level_1 = false
	queue.is_level_2 = false
	queue.is_level_3 = true
	queue.load()
	$Player.get_child(0).get_child(0).get_child(0).get_child(1).instantiate(queue.file_data)
	$Player/CommandsUI.hide()
	$Player/Pause.hide()
	is_commands_panel_open = false
	is_paused = false
	$Player/CommandsUI.player_have_dash = true
	$Player.have_dash_ability = true
	$Player.can_double_jump = false
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	handle_commands_panel()
	handle_pause()
		
	if Input.is_action_just_pressed("restart_save") and save_position_x == start_position_x and $Player.position.x != finish_position_x and !is_commands_panel_open and !is_paused:
		restart_scene()
	if Input.is_action_just_pressed("restart_save") and save_position_x != start_position_x and $Player.position.x != finish_position_x and !is_commands_panel_open and !is_paused:
		$Player.set_physics_process(false)
		$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
		$Player.position.x = save_position_x
		$Player.position.y = save_position_y
		$Player.set_physics_process(true)
		$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)
		
	if Input.is_action_just_pressed("restart_level") and $Player.position.x != finish_position_x and !is_commands_panel_open and !is_paused:
		restart_scene()
		save_position_x = start_position_x
		save_position_y = start_position_y
		
func handle_pause():
	if $Player.position.x == finish_position_x and $Player.position.y == finish_position_y:
		pass
	else:
		if !is_paused and !is_commands_panel_open and Input.is_action_just_pressed("pause") and $Player.position.x != start_position_x:
			$Player/Pause.show()
			disable_patrol_groups()
			$Player.set_physics_process(false)
			$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
			is_paused = true
		elif !is_paused and !is_commands_panel_open and Input.is_action_just_pressed("pause") and $Player.position.x == start_position_x:
			$Player/Pause.show()
			disable_patrol_groups()
			$Player.set_physics_process(false)
			is_paused = true
		elif is_paused and Input.is_action_just_pressed("pause") and $Player.position.x != start_position_x:
			$Player/Pause.hide()
			enable_patrol_groups()
			$Player.set_physics_process(true)
			$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)
			is_paused = false
		elif is_paused and Input.is_action_just_pressed("pause") and $Player.position.x == start_position_x:
			$Player/Pause.hide()
			enable_patrol_groups()
			$Player.set_physics_process(true)
			is_paused = false
		elif is_paused and Input.is_action_just_pressed("menu_when_finish"):
			is_paused = false
			get_tree().change_scene_to_file("res://Scenes/menu.tscn")
			
func handle_commands_panel():
	if $Player.position.x == finish_position_x and $Player.position.y == finish_position_y:
		pass
	else:
		if !is_commands_panel_open and !is_paused and Input.is_action_just_pressed("open_commands") and $Player.position.x != start_position_x:
			$Player/CommandsUI.show()
			disable_patrol_groups()
			$Player.set_physics_process(false)
			$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
			is_commands_panel_open = true
		elif !is_commands_panel_open and !is_paused and Input.is_action_just_pressed("open_commands") and $Player.position.x == start_position_x:
			$Player/CommandsUI.show()
			disable_patrol_groups()
			$Player.set_physics_process(false)
			$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
			is_commands_panel_open = true
		elif is_commands_panel_open and Input.is_action_just_pressed("open_commands") and $Player.position.x != start_position_x:
			$Player/CommandsUI.hide()
			enable_patrol_groups()
			$Player.set_physics_process(true)
			$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)
			is_commands_panel_open = false
		elif is_commands_panel_open and Input.is_action_just_pressed("open_commands") and $Player.position.x == start_position_x:
			$Player/CommandsUI.hide()
			enable_patrol_groups()
			$Player.set_physics_process(true)
			is_commands_panel_open = false
		elif is_commands_panel_open and Input.is_action_just_pressed("close_commands"):
			$Player/CommandsUI.hide()
			enable_patrol_groups()
			$Player.set_physics_process(true)
			$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)
			is_commands_panel_open = false
			
func restart_scene():
	if !is_commands_panel_open:
		get_tree().reload_current_scene()
	else:
		pass
		
func disable_patrol_groups():
	for member in get_tree().get_nodes_in_group("spike_on_patrol"):
			member.set_process(false)
	for member in get_tree().get_nodes_in_group("platform_on_patrol"):
			member.set_process(false)
		
func enable_patrol_groups():
	for member in get_tree().get_nodes_in_group("spike_on_patrol"):
			member.set_process(true)
	for member in get_tree().get_nodes_in_group("platform_on_patrol"):
			member.set_process(true)
			
func _on_start_area_player_exited_start_area():
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)


func _on_ability_player_entered():
	$Player.can_double_jump = true
	$Ability.get_child(0).text = "         You can \n double jump now !"


func _on_save_point_player_entered():
	save_position_x = $Player.position.x
	save_position_y = $Player.position.y
	print(save_position_x)
	print(save_position_y)


func _on_spike_spike_hit():
	disable_patrol_groups()
	display_dead_sprite_and_pause_timer_until_respawn()
	await get_tree().create_timer(1.0).timeout;
	if save_position_x == start_position_x:
		call_deferred("restart_scene")
	else:
		put_player_to_save_position_and_unpause_timer()
		
func display_dead_sprite_and_pause_timer_until_respawn():
	$Player.set_physics_process(false)
	$Player.get_child(1).animation = "dead"
	$Player.get_child(5).text = "OH NO !"
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
	
func put_player_to_save_position_and_unpause_timer():
	$Player.set_physics_process(true)
	$Player.get_child(5).text = ""
	$Player.get_child(1).animation = "stay"
	$Player.position = Vector2(save_position_x,save_position_y)
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)
	reset_patrols_progress()
	enable_patrol_groups()
	
func reset_patrols_progress():
	for member in get_tree().get_nodes_in_group("spike_on_patrol"):
			member.get_parent().progress = 0
	for member in get_tree().get_nodes_in_group("platform_on_patrol"):
			member.get_parent().progress = 0
