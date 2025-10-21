extends StaticBody2D

signal player_entered

var translate_file

# Called when the node enters the scene tree for the first time.
func _ready():
	set_volume()
	translate_text()
	$WellDoneLabel.hide()
	$ConfettiSprite.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player_entered.emit()
		$WellDoneLabel.show()
		$ConfettiSprite.show()
		$ConfettiSprite.play()
		$FinishSound.play()


func _on_confetti_sprite_animation_finished():
	$ConfettiSprite.hide()
	
func translate_text():
	var translate_config = ConfigFile.new()
	if $SaveManager.get_properties_value("Languages", "is_english"):
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Eng_Translate.cfg")
	else:
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Fr_Translate.cfg")
		
	$WellDoneLabel.text = translate_config.get_value("TranslationFinish", "WellDonePlayer")
	
func set_volume():
	for member in get_tree().get_nodes_in_group("sound_effect_group"):
		member.volume_db = $SaveManager.get_properties_value("effectVolume","effectVolumeSet")
