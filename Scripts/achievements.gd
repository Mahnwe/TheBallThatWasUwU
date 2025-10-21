extends Control

var validate_texture = preload("res://Arts/CloudButtonSprite/Validate.png")
var unvalidate_texture = preload("res://Arts/CloudButtonSprite/Unvalidate.png")

var translate_file

var number_of_achievements_unlock
var actualize_lang_propertie

func _ready():
	translate_text($SaveManager.get_properties_value("Languages", "is_english"))
	check_for_all_achievements()
	$QuitButton.grab_focus()
	
	
func _process(_delta):
	if self.visible:
		title_animation()
		if Input.is_action_just_pressed("restart_save"):
			self.hide()
		
func _on_quit_button_pressed():
	self.hide()
	
func _on_quit_button_gui_input(event):
	if $QuitButton.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		if event.is_action_pressed("ui_left"):
			accept_event() # prevent the normal focus-stuff from happening
			$QuitButton.grab_focus()
		elif event.is_action_pressed("ui_up"):
			accept_event()
			$QuitButton.grab_focus()
		elif event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right"):
			accept_event() # prevent the normal focus-stuff from happening
			$QuitButton.grab_focus()
			
			
func check_for_all_achievements():
	number_of_achievements_unlock = 0
	check_for_levels_achievements()
	check_for_medals_achievements()
	check_for_action_achievements()
	check_for_particular_achievements()
	check_for_last_achievements()
	
	
func check_for_levels_achievements():
	if $SaveManager.get_properties_value("levels", "is_level_one_finished"):
		$HSplitContainer/VBoxContainer/HSplitContainer/Level1Validate.texture = validate_texture
		$HSplitContainer/VBoxContainer/HSplitContainer/Level1Achievement/Level1Sprite.show()
	else:
		$HSplitContainer/VBoxContainer/HSplitContainer/Level1Validate.texture = unvalidate_texture
		$HSplitContainer/VBoxContainer/HSplitContainer/Level1Achievement/Level1Sprite.hide()
		
	if $SaveManager.get_properties_value("levels", "is_level_one_finished") and $SaveManager.get_properties_value("levels", "is_level_two_finished") and $SaveManager.get_properties_value("levels", "is_level_three_finished") and $SaveManager.get_properties_value("levels", "is_level_four_finished") and $SaveManager.get_properties_value("levels", "is_level_five_finished") and $SaveManager.get_properties_value("levels", "is_level_six_finished"):
		$HSplitContainer/VBoxContainer/HSplitContainer2/AllLevelsValidate.texture = validate_texture
		$HSplitContainer/VBoxContainer/HSplitContainer2/AllLevelsAchievement/AllLevelsSprite.show()
	else:
		$HSplitContainer/VBoxContainer/HSplitContainer2/AllLevelsValidate.texture = unvalidate_texture
		$HSplitContainer/VBoxContainer/HSplitContainer2/AllLevelsAchievement/AllLevelsSprite.hide()
		
	if $SaveManager.get_properties_value("levels", "is_level_seven_finished"):
		$HSplitContainer/VBoxContainer/HSplitContainer3/SecretLevelValidate.texture = validate_texture
		$HSplitContainer/VBoxContainer/HSplitContainer3/SecretLevelAchievement/SecretLevelSprite.show()
	else:
		$HSplitContainer/VBoxContainer/HSplitContainer3/SecretLevelValidate.texture = unvalidate_texture
		$HSplitContainer/VBoxContainer/HSplitContainer3/SecretLevelAchievement/SecretLevelSprite.hide()
		
func check_for_medals_achievements():
	if $SaveManager.get_stats_value("Stats", "medal_number") >= 1:
		$HSplitContainer/VBoxContainer/HSplitContainer4/OneMedalValidate.texture = validate_texture
		$HSplitContainer/VBoxContainer/HSplitContainer4/OneMedalAchievement/OneMedalSprite.show()
	else:
		$HSplitContainer/VBoxContainer/HSplitContainer4/OneMedalValidate.texture = unvalidate_texture
		$HSplitContainer/VBoxContainer/HSplitContainer4/OneMedalAchievement/OneMedalSprite.hide()
		
	if $SaveManager.get_properties_value("medals", "level_one_medal") >= 1 and $SaveManager.get_properties_value("medals", "level_two_medal") >= 1 and $SaveManager.get_properties_value("medals", "level_three_medal") >= 1 and $SaveManager.get_properties_value("medals", "level_four_medal") >= 1 and $SaveManager.get_properties_value("medals", "level_five_medal") >= 1 and $SaveManager.get_properties_value("medals", "level_six_medal") >= 1:
		$HSplitContainer/VBoxContainer/HSplitContainer5/AllLevelsMedalValidate.texture = validate_texture
		$HSplitContainer/VBoxContainer/HSplitContainer5/AllLevelsMedalAchievements/AllMedalSprite.show()
	else:
		$HSplitContainer/VBoxContainer/HSplitContainer5/AllLevelsMedalValidate.texture = unvalidate_texture
		$HSplitContainer/VBoxContainer/HSplitContainer5/AllLevelsMedalAchievements/AllMedalSprite.hide()
		
	if $SaveManager.get_stats_value("Stats", "dev_medal_number") >= 1:
		$HSplitContainer/VBoxContainer/HSplitContainer6/DevMedalValidate.texture = validate_texture
		$HSplitContainer/VBoxContainer/HSplitContainer6/DevMedalAchievement/DevMedalSprite.show()
	else:
		$HSplitContainer/VBoxContainer/HSplitContainer6/DevMedalValidate.texture = unvalidate_texture
		$HSplitContainer/VBoxContainer/HSplitContainer6/DevMedalAchievement/DevMedalSprite.hide()
		
func check_for_action_achievements():
	if $SaveManager.get_stats_value("Stats", "jump_number") >= 500:
		$HSplitContainer/VBoxContainer2/HSplitContainer2/JumpsValidate.texture = validate_texture
		$HSplitContainer/VBoxContainer2/HSplitContainer2/JumpsAchievement/JumpSprite.show()
	else:
		$HSplitContainer/VBoxContainer2/HSplitContainer2/JumpsValidate.texture = unvalidate_texture
		$HSplitContainer/VBoxContainer2/HSplitContainer2/JumpsAchievement/JumpSprite.hide()
		
	if $SaveManager.get_stats_value("Stats", "dash_number") >= 200:
		$HSplitContainer/VBoxContainer2/HSplitContainer3/DashesValidate.texture = validate_texture
		$HSplitContainer/VBoxContainer2/HSplitContainer3/DashesAchievement/DashSprite.show()
	else:
		$HSplitContainer/VBoxContainer2/HSplitContainer3/DashesValidate.texture = unvalidate_texture
		$HSplitContainer/VBoxContainer2/HSplitContainer3/DashesAchievement/DashSprite.hide()
	
	if $SaveManager.get_stats_value("Stats", "death_number") >= 100:
		$HSplitContainer/VBoxContainer2/HSplitContainer4/DeathValidate.texture = validate_texture
		$HSplitContainer/VBoxContainer2/HSplitContainer4/DeathAchievement/DeathSprite.show()
	else:
		$HSplitContainer/VBoxContainer2/HSplitContainer4/DeathValidate.texture = unvalidate_texture
		$HSplitContainer/VBoxContainer2/HSplitContainer4/DeathAchievement/DeathSprite.hide()
		
func check_for_particular_achievements():
	if $SaveManager.get_properties_value("Chests", "chestNumber") >= 6:
		$HSplitContainer/VBoxContainer2/HSplitContainer5/ChestsValidate.texture = validate_texture
		$HSplitContainer/VBoxContainer2/HSplitContainer5/ChestsAchievement/ChestSprite.show()
	else: 
		$HSplitContainer/VBoxContainer2/HSplitContainer5/ChestsValidate.texture = unvalidate_texture
		$HSplitContainer/VBoxContainer2/HSplitContainer5/ChestsAchievement/ChestSprite.hide()
		
	if $SaveManager.get_stats_value("Stats", "time_played") >= 1800:
		$HSplitContainer/VBoxContainer2/HSplitContainer6/TimePlayedValidate.texture = validate_texture
		$HSplitContainer/VBoxContainer2/HSplitContainer6/TimePlayedSucces/TimeSprite.show()
	else:
		$HSplitContainer/VBoxContainer2/HSplitContainer6/TimePlayedValidate.texture = unvalidate_texture
		$HSplitContainer/VBoxContainer2/HSplitContainer6/TimePlayedSucces/TimeSprite.hide()
		
		
func check_for_last_achievements():
	for member in get_tree().get_nodes_in_group("validate_group"):
		if member.texture == validate_texture:
			number_of_achievements_unlock += 1
	if number_of_achievements_unlock == 11:
		$HSplitContainer/VBoxContainer2/HSplitContainer/AllAchievementsValidate.texture = validate_texture
		$HSplitContainer/VBoxContainer2/HSplitContainer/AllAchievements/CupSprite.show()
	else:
		$HSplitContainer/VBoxContainer2/HSplitContainer/AllAchievementsValidate.texture = unvalidate_texture
		$HSplitContainer/VBoxContainer2/HSplitContainer/AllAchievements/CupSprite.hide()
			
		
			
func translate_text(is_english):
	var translate_config = ConfigFile.new()
	if is_english:
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Eng_Translate.cfg")
		$Title.add_theme_font_size_override("font_size", 120)
		$Title.position = Vector2(656, 121)
		$HSplitContainer.add_theme_constant_override("separation", 480.0)
	else:
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Fr_Translate.cfg")
		$Title.add_theme_font_size_override("font_size", 140)
		$Title.position = Vector2(770, 111)
		$HSplitContainer.add_theme_constant_override("separation", 420.0)
		
	actualize_lang_propertie = is_english
	$Title.text = translate_config.get_value("TranslationAchievements", "TitleAchievements")
	$HSplitContainer/VBoxContainer/HSplitContainer/Level1Achievement.text = translate_config.get_value("TranslationAchievements", "Level1Achievement")
	$HSplitContainer/VBoxContainer/HSplitContainer2/AllLevelsAchievement.text = translate_config.get_value("TranslationAchievements", "AllLevelsAchievement")
	$HSplitContainer/VBoxContainer/HSplitContainer3/SecretLevelAchievement.text = translate_config.get_value("TranslationAchievements", "SecretLevelAchievement")
	$HSplitContainer/VBoxContainer/HSplitContainer4/OneMedalAchievement.text = translate_config.get_value("TranslationAchievements", "OneMedalAchievement")
	$HSplitContainer/VBoxContainer/HSplitContainer5/AllLevelsMedalAchievements.text = translate_config.get_value("TranslationAchievements", "AllLevelsMedalAchievement")
	$HSplitContainer/VBoxContainer/HSplitContainer6/DevMedalAchievement.text = translate_config.get_value("TranslationAchievements", "DevMedalAchievement")
	$HSplitContainer/VBoxContainer2/HSplitContainer2/JumpsAchievement.text = translate_config.get_value("TranslationAchievements", "JumpsAchievement")
	$HSplitContainer/VBoxContainer2/HSplitContainer3/DashesAchievement.text = translate_config.get_value("TranslationAchievements", "DashesAchievement")
	$HSplitContainer/VBoxContainer2/HSplitContainer4/DeathAchievement.text = translate_config.get_value("TranslationAchievements", "DeathAchievement")
	$HSplitContainer/VBoxContainer2/HSplitContainer5/ChestsAchievement.text = translate_config.get_value("TranslationAchievements", "ChestsAchievement")
	$HSplitContainer/VBoxContainer2/HSplitContainer6/TimePlayedSucces.text = translate_config.get_value("TranslationAchievements", "TimeAchievement")
	$HSplitContainer/VBoxContainer2/HSplitContainer/AllAchievements.text = translate_config.get_value("TranslationAchievements", "AllAchievements")
	
	
func title_animation():
	if $Title.scale <= Vector2(0.642,0.647):
		var move_tween = get_tree().create_tween()
		var grow_tween = get_tree().create_tween()
		if actualize_lang_propertie:
			move_tween.tween_property($Title, "position", Vector2(640.0,114.0), 1.0)
		else:
			move_tween.tween_property($Title, "position", Vector2(755.0,114.0), 1.0)
		grow_tween.tween_property($Title, "scale", Vector2(0.672,0.677), 1.0)
	if $Title.scale == Vector2(0.672,0.677):
		var move_tween = get_tree().create_tween()
		var shrink_tween = get_tree().create_tween()
		if actualize_lang_propertie:
			move_tween.tween_property($Title, "position", Vector2(656.0,114.0), 1.0)
		else:
			move_tween.tween_property($Title, "position", Vector2(760.0,114.0), 1.0)
		shrink_tween.tween_property($Title, "scale", Vector2(0.642,0.647), 1.0)
