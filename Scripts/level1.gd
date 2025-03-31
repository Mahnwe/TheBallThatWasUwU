extends Node2D

var is_paused

var start_position_x = -1512
var start_position_y = 327

var save_position_x = -1512
var save_position_y = 327

var finish_position_x = -1827
var finish_position_y = 324

var queue = preload("res://Ressources/Save_game.gd").new()

var stats_config= ConfigFile.new()
var stats_file = stats_config.load("res://Ressources/PropertieFile/stats.cfg")

var config = ConfigFile.new()
# Load data from a file.
var config_file = config.load("res://Ressources/PropertieFile/properties.cfg")

# Called when the node enters the scene tree for the first time.
func _ready():
	queue.is_level_1 = true
	queue.is_level_2 = false
	queue.is_level_3 = false
	queue.is_level_4 = false
	queue.is_level_5 = false
	queue.is_level_6 = false
	queue.load()
	$Chest.set_level_number(1)
	if config.get_value("Chests", "level_one_chest"):
		$Chest.chest_already_picked()
	set_volume()
	$Player.get_child(0).get_child(0).get_child(0).get_child(1).instantiate(queue.file_data)
	$Player/Pause.hide()
	$Player/Pause.get_child(0).hide()
	$Player/Pause.get_child(1).hide()
	$Player/Pause.get_child(2).hide()
	$Player/Pause.get_child(3).hide()
	$Player/Pause.get_child(4).hide()
	$Player.get_child(0).get_child(0).get_child(0).get_child(1).hide()
	is_paused = false
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
	set_up_signs()
	$Level1Music.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if !is_paused and Input.is_action_just_pressed("restart_save") and save_position_x == start_position_x and $Player.position.x != finish_position_x and !is_paused:
		restart_scene()
	if !is_paused and Input.is_action_just_pressed("restart_save") and save_position_x != start_position_x and $Player.position.x != finish_position_x and !is_paused:
		$Player.set_physics_process(false)
		$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
		$Player.position.x = save_position_x
		$Player.position.y = save_position_y
		$Player.set_physics_process(true)
		$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)
		
	if Input.is_action_just_pressed("restart_level") and $Player.position.x != finish_position_x and !is_paused:
		restart_scene()
		save_position_x = start_position_x
		save_position_y = start_position_y
		
	if is_paused:
		$Player/Pause.is_paused = true
		is_paused = true
	handle_pause()
	handle_player_actions_when_level_finished()
		
func handle_player_actions_when_level_finished():
	if $Player.position.x == finish_position_x and $Player.position.y == finish_position_y and Input.is_action_just_pressed("next_level"):
		get_tree().change_scene_to_file("res://Scenes/level2.tscn")
	if $Player.position.x == finish_position_x and $Player.position.y == finish_position_y and Input.is_action_just_pressed("menu_when_finish"):
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")

	
func handle_pause():
	if $Player.position.x == finish_position_x and $Player.position.y == finish_position_y:
		pass
	else:
		if is_paused and $Player/Pause.is_commands_display == true:
			$Player.get_child(0).get_child(0).get_child(0).hide()
		elif is_paused and $Player/Pause.is_commands_display == false:
			$Player.get_child(0).get_child(0).get_child(0).show()
		if !is_paused and Input.is_action_just_pressed("pause") and $Player.position.x != start_position_x:
			toggle_pause()
		elif !is_paused and Input.is_action_just_pressed("pause") and $Player.position.x == start_position_x:
			toggle_pause()
		elif is_paused and $Player/Pause.is_commands_display == false and $Player.position.x != start_position_x and Input.is_action_just_pressed("pause") or Input.is_action_just_pressed("restart_save"):
			untoggle_pause()
		elif is_paused and $Player/Pause.is_commands_display == false and $Player.position.x == start_position_x and Input.is_action_just_pressed("pause") or Input.is_action_just_pressed("restart_save"):
			untoggle_pause()
		elif is_paused and Input.is_action_just_pressed("menu_when_finish"):
			is_paused = false
			get_tree().change_scene_to_file("res://Scenes/menu.tscn")
			
func restart_scene():
	get_tree().reload_current_scene()
	
			
func _on_spike_spike_hit():
	display_dead_sprite_and_pause_timer_until_respawn("OH NO !")
	await get_tree().create_timer(1.0).timeout;
	if save_position_x == start_position_x:
		call_deferred("restart_scene")
	else:
		put_player_to_save_position_and_unpause_timer()
	
	
func _on_save_point_player_entered():
	save_position_x = $Player.position.x
	save_position_y = $Player.position.y
	
func _on_finish_player_entered():
	$Player.position.x = finish_position_x
	$Player.position.y = finish_position_y
	$Player.get_child(0).get_child(0).get_child(1).hide()
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
	queue.sort_ascending($Player.get_child(0).get_child(0).get_child(0).get_child(0).time_elapsed)
	queue.saveData()
	$Player.get_child(0).get_child(0).get_child(0).get_child(1).instantiate(queue.file_data)
	config.set_value("levels", "is_level_one_finished", true)
	config.save("res://Ressources/PropertieFile/properties.cfg")
	$Player.get_child(1).animation = "stay"
	$Player.set_physics_process(false)
	await get_tree().create_timer(1.0).timeout
	$Finish/FinishUI.is_UI_showing = true
	$Finish/FinishUI.get_child(0).show()
	$Finish/FinishUI.get_child(1).show()
	$Finish/FinishUI.get_child(2).show()
	$Finish/FinishUI.get_child(3).show()
	$Finish/FinishUI.get_child(4).show()
	$Player.get_child(0).get_child(0).get_child(0).get_child(1).show()
	$Finish/FinishUI._setup_timer_label_display($Player.get_child(0).get_child(0).get_child(0).get_child(0).time_elapsed)
	var number_of_level_finished = stats_config.get_value("Stats", "finished_level_number")
	stats_config.set_value("Stats", "finished_level_number", number_of_level_finished+1)
	var number_of_level_one_finished = stats_config.get_value("Stats", "level_one_finished_number")
	stats_config.set_value("Stats", "level_one_finished_number", number_of_level_one_finished+1)
	stats_config.save("res://Ressources/PropertieFile/stats.cfg")


func _on_start_area_player_exited_start_area():
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)

func display_dead_sprite_and_pause_timer_until_respawn(message):
	$Player.set_physics_process(false)
	$Player.velocity.x = 0
	$Player.velocity.y = 0
	$Player.get_child(1).animation = "dead"
	$Player.get_child(4).text = message
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
	
func put_player_to_save_position_and_unpause_timer():
	$Player.set_physics_process(true)
	$Player.get_child(4).text = ""
	$Player.get_child(1).animation = "stay"
	$Player.position = Vector2(save_position_x,save_position_y)
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)


func _on_game_area_player_exited_game_area():
	display_dead_sprite_and_pause_timer_until_respawn("Out of game zone !")
	await get_tree().create_timer(0.5).timeout;
	if save_position_x == start_position_x:
		call_deferred("restart_scene")
	else:
		put_player_to_save_position_and_unpause_timer()
		

func set_up_signs():
	_on_triple_sign_set_up_sign_label()
	_on_triple_sign_2_set_up_sign_label()

func _on_triple_sign_set_up_sign_label():
	$TripleSign.get_child(1).text = "Easy way"
	$TripleSign.get_child(2).text = "Hard way"
	$TripleSign.get_child(3).text = "Dead way"


func _on_triple_sign_2_set_up_sign_label():
	$TripleSign2.get_child(2).text = "Hard way"
	$TripleSign2.get_child(3).text = "Easy way"
	


func _on_pause_continue_is_clicked():
	if $Player.position.x != start_position_x:
		untoggle_pause()
	elif $Player.position.x == start_position_x:
		$PauseMusic.stop()
		$Level1Music.stream_paused = false
		$Player/Pause.hide()
		$Player/Pause.get_child(0).hide()
		$Player/Pause.get_child(1).hide()
		$Player/Pause.get_child(2).hide()
		$Player/Pause.get_child(3).hide()
		$Player/Pause.get_child(4).hide()
		$Player.get_child(0).get_child(0).get_child(1).show()
		$Player.get_child(0).get_child(0).get_child(0).get_child(1).hide()
		$Player.set_physics_process(true)
		is_paused = false
		$Player/Pause.is_paused = false
		$Player/Pause.is_controller_focused = false


func _on_trigger_dead_way_music_body_entered(body):
	if body.name == "Player" and $DeadWayMusic.playing == false:
		$Level1Music.stop()
		$DeadWayMusic.play()


func _on_pause_music_finished():
	$PauseMusic.play()
	
func set_volume():
	for member in get_tree().get_nodes_in_group("music_group"):
		member.volume_db = config.get_value("musicVolume","musicVolumeSet")
	for member in get_tree().get_nodes_in_group("sound_effect_group"):
		member.volume_db = config.get_value("effectVolume","effectVolumeSet")
		
func toggle_pause():
	$Player/Pause.show()
	$Player/Pause.get_child(0).show()
	$Player/Pause.get_child(1).show()
	$Player/Pause.get_child(2).show()
	$Player/Pause.get_child(3).show()
	$Player/Pause.get_child(4).show()
	$Player.get_child(0).get_child(0).get_child(0).get_child(1).show()
	$Level1Music.stream_paused = true
	$DeadWayMusic.stream_paused = true
	$PauseMusic.play()
	$Player.get_child(0).get_child(0).get_child(1).hide()
	$Player.set_physics_process(false)
	$Player/Pause.set_current_timer_when_paused($Player.get_child(0).get_child(0).get_child(0).get_child(0).time_elapsed)
	if $Player.position.x != start_position_x and $Player.position.y != start_position_y:
		$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
	is_paused = true
	$Player/Pause.is_paused = true
	$Player/Pause.get_child(1).get_child(1).grab_focus()
	
func untoggle_pause():
	$Player/Pause.hide()
	$Player/Pause.get_child(0).hide()
	$Player/Pause.get_child(1).hide()
	$Player/Pause.get_child(2).hide()
	$Player/Pause.get_child(3).hide()
	$Player/Pause.get_child(4).hide()
	$Player.get_child(0).get_child(0).get_child(0).get_child(1).hide()
	$PauseMusic.stop()
	$Level1Music.stream_paused = false
	$DeadWayMusic.stream_paused = false
	$Player.get_child(0).get_child(0).get_child(1).show()
	$Player.set_physics_process(true)
	if $Player.position.x != start_position_x and $Player.position.y != start_position_y:
		$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)
	is_paused = false
	$Player/Pause.is_paused = false
	$Player/Pause.is_controller_focused = false


func _on_trigger_level_music_body_entered(body):
	if body.name == "Player" and $DeadWayMusic.playing == true:
		$DeadWayMusic.stop()
		$Level1Music.play()


func _on_finish_next_level_pressed():
	if $Player.position.x == finish_position_x and $Player.position.y == finish_position_y:
		get_tree().change_scene_to_file("res://Scenes/level2.tscn")
