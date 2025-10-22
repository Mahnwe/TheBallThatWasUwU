extends Node2D

const MENU_SCENE : String = "res://Scenes/menu.tscn"
const LEVEL_1_SCENE : String = "res://Scenes/level1.tscn"

var is_paused

var start_position_x = -2281
var start_position_y = -390

var save_position_x = -2281
var save_position_y = -390

var finish_position_x = -1570
var finish_position_y = -27

var queue = preload("res://Ressources/Save_game.gd").new()

var translate_file

var player_is_hit

# Called when the node enters the scene tree for the first time.
func _ready():
	queue.is_level_1 = false
	queue.is_level_2 = false
	queue.is_level_3 = false
	queue.is_level_4 = false
	queue.is_level_5 = false
	queue.is_level_6 = true
	queue.is_level_7 = false
	queue.load()
	$Chest.set_level_number(6)
	if $SaveManager.get_properties_value("Chests", "level_six_chest"):
		$Chest.chest_already_picked()
	set_volume()
	translate_text()
	$Player.get_child(0).get_child(0).get_child(0).get_child(1).instantiate(queue.file_data)
	$Player/Pause.hide()
	$Player/Pause.get_child(0).hide()
	$Player/Pause.get_child(1).hide()
	$Player/Pause.get_child(2).hide()
	$Player/Pause.get_child(3).hide()
	$Player/Pause.get_child(4).hide()
	$Player/Pause.get_child(5).hide()
	$Finish/FinishUI.get_child(0).hide()
	$Finish/FinishUI.get_child(1).hide()
	$Finish/FinishUI.get_child(3).hide()
	$Player.get_child(0).get_child(0).get_child(0).get_child(1).hide()
	is_paused = false
	player_is_hit = false
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
	$Path2D3/PathFollow2D/MetalPlatform.set_process(false)
	$Path2D11/PathFollow2D/MetalPlatform.set_process(false)
	display_advice()
	$Level6Music.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	water_drop_animation(delta)
	check_for_buttons_holding()
		
	if is_paused:
		$Player/Pause.is_paused = true
		is_paused = true
	if player_is_hit or is_paused:
		$Player/ResetBar.is_reset_save_pressed = false
		$Player/ResetBar.is_reset_level_pressed = false
	handle_player_actions_when_level_finished()
	handle_pause()
	
func check_for_buttons_holding():
	if $Player.position.x != finish_position_x and !is_paused and !player_is_hit:
		if Input.is_action_just_pressed("restart_save"):
			$Player/ResetBar.is_reset_save_pressed = true
		if Input.is_action_just_released("restart_save"):
			$Player/ResetBar.is_reset_save_pressed = false
		if Input.is_action_just_pressed("restart_level"):
			$Player/ResetBar.is_reset_level_pressed = true
		if Input.is_action_just_released("restart_level"):
			$Player/ResetBar.is_reset_level_pressed = false
	
func _on_spike_spike_hit():
	disable_patrol_groups()
	disable_drop_groups()
	display_dead_sprite_and_pause_timer_until_respawn("OH NO !")
	play_dead_sound()
	save_deaths_stat()
	await get_tree().create_timer(1.0).timeout;
	if save_position_x == start_position_x:
		call_deferred("restart_scene")
	else:
		put_player_to_save_position_and_unpause_timer()
		
func play_dead_sound():
	var random = RandomNumberGenerator.new()
	random.randomize()
	if random.randf() >= 0.50:
		$DeadSound.play()
	else:
		$DeadSound2.play()
	
func restart_scene():
	saving_time_played()
	get_tree().reload_current_scene()
	
func _on_start_area_player_exited_start_area():
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)
	
func _on_save_point_player_entered():
	save_position_x = $Player.position.x
	save_position_y = $Player.position.y
		
		
func handle_player_actions_when_level_finished():
	if $Player.position.x == finish_position_x and $Player.position.y == finish_position_y and Input.is_action_just_pressed("next_level"):
		saving_time_played()
		$Finish/FinishUI.get_child(5).get_child(0).show()
		$Finish/FinishUI.get_child(5).get_child(0).load(LEVEL_1_SCENE)
	if $Player.position.x == finish_position_x and $Player.position.y == finish_position_y and Input.is_action_just_pressed("menu_when_finish"):
		saving_time_played()
		$Player/Pause.get_child(9).get_child(0).show()
		$Player/Pause.get_child(9).get_child(0).load(MENU_SCENE)
	
func handle_pause():
	if $Player.position.x == finish_position_x and $Player.position.y == finish_position_y:
		pass
	else:
		if is_paused and $Player/Pause.is_commands_display:
			$Player.get_child(0).get_child(0).get_child(0).hide()
		elif is_paused and !$Player/Pause.is_commands_display:
			$Player.get_child(0).get_child(0).get_child(0).show()
		if !is_paused and Input.is_action_just_pressed("pause"):
			toggle_pause()
		elif is_paused and !$Player/Pause.is_commands_display and Input.is_action_just_pressed("pause"):
			untoggle_pause()
		elif is_paused and !$Player/Pause.is_commands_display and Input.is_action_just_pressed("restart_save"):
			untoggle_pause()
		elif is_paused and !$Player/Pause.is_commands_display and Input.is_action_just_pressed("menu_when_finish"):
			is_paused = false
			saving_time_played()
			$Player/Pause.get_child(9).get_child(0).show()
			$Player/Pause.get_child(9).get_child(0).load(MENU_SCENE)
			
func toggle_pause():
	$Player/Pause.show()
	$Player/Pause.get_child(0).show()
	$Player/Pause.get_child(1).show()
	$Player/Pause.get_child(2).show()
	$Player/Pause.get_child(3).show()
	$Player/Pause.get_child(4).show()
	$Player/Pause.get_child(5).show()
	$Player.get_child(0).get_child(0).get_child(0).get_child(1).show()
	$Level6Music.stream_paused = true
	$PauseMusic.play()
	$Player.get_child(0).get_child(0).get_child(1).hide()
	disable_drop_groups()
	disable_patrol_groups()
	pause_laser()
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
	$Player/Pause.get_child(5).hide()
	$Player.get_child(0).get_child(0).get_child(0).get_child(1).hide()
	$PauseMusic.stop()
	$Level6Music.stream_paused = false
	$Player.get_child(0).get_child(0).get_child(1).show()
	enable_drop_groups()
	enable_patrol_groups()
	unpause_laser()
	$Player.set_physics_process(true)
	if $Player.position.x != start_position_x and $Player.position.y != start_position_y:
		$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)
	is_paused = false
	$Player/Pause.is_paused = false
	$Player/Pause.is_controller_focused = false
	
func _on_game_area_player_exited_game_area():
	display_dead_sprite_and_pause_timer_until_respawn("Out of game zone !")
	await get_tree().create_timer(0.5).timeout;
	if save_position_x == start_position_x:
		call_deferred("restart_scene")
	else:
		put_player_to_save_position_and_unpause_timer()
		
func display_dead_sprite_and_pause_timer_until_respawn(message):
	$Player.set_physics_process(false)
	player_is_hit = true
	$Player.velocity.x = 0
	$Player.velocity.y = 0
	$Player.get_child(1).animation = "dead"
	$Player.get_child(4).text = message
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
	
func put_player_to_save_position_and_unpause_timer():
	$Player.position = Vector2(save_position_x,save_position_y)
	$Player.get_child(4).text = ""
	$Player.get_child(1).animation = "stay"
	player_is_hit = false
	$Player.set_physics_process(true)
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)
	enable_drop_groups()
	reset_metal_platform_patrol()
	
func _on_pause_continue_is_clicked():
	if $Player.position.x != start_position_x:
		untoggle_pause()
	elif $Player.position.x == start_position_x:
		$PauseMusic.stop()
		$Level6Music.stream_paused = false
		$Player/Pause.hide()
		$Player/Pause.get_child(0).hide()
		$Player/Pause.get_child(1).hide()
		$Player/Pause.get_child(2).hide()
		$Player/Pause.get_child(3).hide()
		$Player/Pause.get_child(4).hide()
		$Player/Pause.get_child(5).hide()
		$Player.get_child(0).get_child(0).get_child(0).get_child(1).hide()
		$Player.get_child(0).get_child(0).get_child(1).show()
		$Player.set_physics_process(true)
		enable_drop_groups()
		enable_patrol_groups()
		unpause_laser()
		is_paused = false
		$Player/Pause.is_paused = false
		$Player/Pause.is_controller_focused = false
		
func _on_finish_ui_next_level_pressed():
	if $Player.position.x == finish_position_x and $Player.position.y == finish_position_y:
		saving_time_played()
		$Finish/FinishUI.get_child(5).get_child(0).show()
		$Finish/FinishUI.get_child(5).get_child(0).load(LEVEL_1_SCENE)
			
func _on_pause_music_finished():
	$PauseMusic.play()
	
func set_volume():
	for member in get_tree().get_nodes_in_group("music_group"):
		member.volume_db = $SaveManager.get_properties_value("musicVolume","musicVolumeSet")
	for member in get_tree().get_nodes_in_group("sound_effect_group"):
		member.volume_db = $SaveManager.get_properties_value("effectVolume","effectVolumeSet")
		
func disable_patrol_groups():
	for member in get_tree().get_nodes_in_group("platform_on_patrol"):
		member.set_process(false)
		
func enable_patrol_groups():
	if(get_tree() != null):
		for member in get_tree().get_nodes_in_group("platform_on_patrol"):
			if !member.trigger_required:
				member.set_process(true)
		
func water_drop_animation(delta):
	for member in get_tree().get_nodes_in_group("waterdrop_group"):
		if !is_paused:
			if(member.drop_exploded == true):
				member.get_parent().progress_ratio = 0
			if(member.drop_exploded == false):
				member.get_parent().progress += member.speed * delta
			
func disable_drop_groups():
	for member in get_tree().get_nodes_in_group("waterdrop_group"):
		member.set_process(false)
		
func enable_drop_groups():
	if(get_tree() != null):
		for member in get_tree().get_nodes_in_group("waterdrop_group"):
			member.set_process(true)
				
func reset_drop_progress():
	for member in get_tree().get_nodes_in_group("waterdrop_group"):
		member.get_parent().progress = 0


func _on_metal_platform_1_trigger_body_entered(body):
	if body.name == "Player":
		$Path2D3/PathFollow2D/MetalPlatform.set_process(true)
		$Path2D3/PathFollow2D/MetalPlatform.trigger_required = false


func _on_metal_platform_2_body_entered(body):
	if body.name == "Player":
		$Path2D11/PathFollow2D/MetalPlatform.set_process(true)
		$Path2D11/PathFollow2D/MetalPlatform.trigger_required = false
		
func reset_metal_platform_patrol():
	$Path2D11/PathFollow2D.progress_ratio = 0.0
	$Path2D11/PathFollow2D/MetalPlatform.set_process(false)
	

func _on_finish_player_entered():
	$Player.position.x = finish_position_x
	$Player.position.y = finish_position_y
	$Player.get_child(0).get_child(0).get_child(1).hide()
	$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
	queue.sort_ascending($Player.get_child(0).get_child(0).get_child(0).get_child(0).time_elapsed)
	queue.saveData()
	if queue.current_medal >= $SaveManager.get_properties_value("medals", "level_six_medal"):
		$SaveManager.save_properties_value("medals", "level_six_medal", queue.current_medal)
	$Player.get_child(0).get_child(0).get_child(0).get_child(1).instantiate(queue.file_data)
	$SaveManager.save_properties_value("levels", "is_level_six_finished", true)
	$Player.get_child(1).animation = "stay"
	$Player.set_physics_process(false)
	await get_tree().create_timer(2.0).timeout
	$Finish/FinishUI.set_medal_sprite(queue.current_medal)
	$Finish/FinishUI.show()
	$Finish/FinishUI.get_child(0).show()
	$Finish/FinishUI.get_child(1).show()
	$Finish/FinishUI.get_child(3).show()
	$Finish/FinishUI.get_child(0).get_child(0).grab_focus()
	$Player.get_child(0).get_child(0).get_child(0).get_child(1).show()
	$Finish/FinishUI._setup_timer_label_display($Player.get_child(0).get_child(0).get_child(0).get_child(0).time_elapsed)
	$Finish/FinishUI.is_UI_showing = true
	var number_of_level_finished = $SaveManager.get_stats_value("Stats", "finished_level_number")
	$SaveManager.save_stats_value("Stats", "finished_level_number", number_of_level_finished+1)
	var number_of_level_six_finished = $SaveManager.get_stats_value("Stats", "level_six_finished_number")
	$SaveManager.save_stats_value("Stats", "level_six_finished_number", number_of_level_six_finished+1)
	save_medals_stats()
	
func pause_laser():
	for member in get_tree().get_nodes_in_group("laser_group"):
		member.is_paused = true
		
func unpause_laser():
	for member in get_tree().get_nodes_in_group("laser_group"):
		member.is_paused = false
		
func translate_text():
	var translate_config = ConfigFile.new()
	if $SaveManager.get_properties_value("Languages", "is_english"):
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Eng_Translate.cfg")
	else:
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Fr_Translate.cfg")
		
	$TripleSign.get_child(2).text = translate_config.get_value("TranslationSign", "ContinueSign")
	$TripleSign2.get_child(2).text = translate_config.get_value("TranslationSign", "ContinueSign")
	$Advice.set_bubble_message(translate_config.get_value("TranslationAdvice", "AbilitiesAdvice"))
	
func display_advice():
	if !$SaveManager.get_properties_value("levels", "is_level_two_finished") or !$SaveManager.get_properties_value("levels", "is_level_three_finished"):
		$Advice.show()
		
func save_medals_stats():
	if queue.current_medal != 0:
		var medal_number = $SaveManager.get_stats_value("Stats", "medal_number")
		$SaveManager.save_stats_value("Stats", "medal_number", medal_number+1)
	match queue.current_medal:
		1:
			var bronze_medal_number = $SaveManager.get_stats_value("Stats", "bronze_medal_number")
			$SaveManager.save_stats_value("Stats", "bronze_medal_number", bronze_medal_number+1)
		2:
			var silver_medal_number = $SaveManager.get_stats_value("Stats", "silver_medal_number")
			$SaveManager.save_stats_value("Stats", "silver_medal_number", silver_medal_number+1)
		3:
			var gold_medal_number = $SaveManager.get_stats_value("Stats", "gold_medal_number")
			$SaveManager.save_stats_value("Stats", "gold_medal_number", gold_medal_number+1)
		4:
			var dev_medal_number = $SaveManager.get_stats_value("Stats", "dev_medal_number")
			$SaveManager.save_stats_value("Stats", "dev_medal_number", dev_medal_number+1)


func _on_chest_chest_triggered():
	$SaveManager.save_properties_value("Chests", "level_six_chest", true)
	var current_chest_number = $SaveManager.get_properties_value("Chests", "chestNumber")
	var new_chest_number = current_chest_number+1
	$SaveManager.save_properties_value("Chests", "chestNumber", new_chest_number)
	

func _on_player_player_jumped():
	var number_of_jumps_in_stats = $SaveManager.get_stats_value("Stats", "jump_number")
	$SaveManager.save_stats_value("Stats", "jump_number", number_of_jumps_in_stats+1)


func _on_player_player_dashed():
	var number_of_dashes =  $SaveManager.get_stats_value("Stats", "dash_number")
	$SaveManager.save_stats_value("Stats", "dash_number", number_of_dashes+1)


func saving_time_played():
	var time_already_played =  $SaveManager.get_stats_value("Stats", "time_played")
	var time_elapsed_to_save = time_already_played + $TimeControl.time_elapsed
	$SaveManager.save_stats_value("Stats", "time_played", time_elapsed_to_save)
	
func save_deaths_stat():
	var number_of_death =  $SaveManager.get_stats_value("Stats", "death_number")
	$SaveManager.save_stats_value("Stats", "death_number", number_of_death+1)
	match ($Player.player_killer_name):
		"Spike":
			var number_of_spike_death = $SaveManager.get_stats_value("Stats", "spike_death_number")
			$SaveManager.save_stats_value("Stats", "spike_death_number", number_of_spike_death+1)
		"Cannon":
			var number_of_cannon_death = $SaveManager.get_stats_value("Stats", "cannon_death_number")
			$SaveManager.save_stats_value("Stats", "cannon_death_number", number_of_cannon_death+1)
		"Acid":
			var number_of_acid_death = $SaveManager.get_stats_value("Stats", "acid_death_number")
			$SaveManager.save_stats_value("Stats", "acid_death_number", number_of_acid_death+1)
		"Coral Spike":
			var number_of_coral_death = $SaveManager.get_stats_value("Stats", "coral_death_number")
			$SaveManager.save_stats_value("Stats", "coral_death_number", number_of_coral_death+1)
		"Laser":
			var number_of_laser_death = $SaveManager.get_stats_value("Stats", "laser_death_number")
			$SaveManager.save_stats_value("Stats", "laser_death_number", number_of_laser_death+1)


func _on_pause_return_to_menu_is_clicked():
	saving_time_played()
	$Player/Pause.get_child(9).get_child(0).show()
	$Player/Pause.get_child(9).get_child(0).load(MENU_SCENE)


func _on_finish_ui_return_to_menu_pressed():
	saving_time_played()
	$Finish/FinishUI.get_child(5).get_child(0).show()
	$Finish/FinishUI.get_child(5).get_child(0).load(MENU_SCENE)


func _on_reset_bar_reset_save_progress_finished():
	if save_position_x == start_position_x:
		restart_scene()
	else:
		$Player.set_physics_process(false)
		$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(false)
		$Player.position.x = save_position_x
		$Player.position.y = save_position_y
		$Player.set_physics_process(true)
		$Player.get_child(0).get_child(0).get_child(0).get_child(0).set_process(true)


func _on_reset_bar_reset_level_progress_finished():
	restart_scene()
	save_position_x = start_position_x
	save_position_y = start_position_y
