extends StaticBody2D

signal player_entered
var is_already_active

var translate_file

# Called when the node enters the scene tree for the first time.
func _ready():
	set_volume()
	is_already_active = false
	translate_text()
	$SavedLabel.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_save_area_body_entered(body):
	if body.name == "Player" and !is_already_active:
		is_already_active = true
		$SaveSound.play()
		player_entered.emit()
		$SavedLabel.show()
		await get_tree().create_timer(2).timeout
		$SavedLabel.hide()
		
func translate_text():
	var translate_config = ConfigFile.new()
	if $SaveManager.get_properties_value("Languages", "is_english"):
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Eng_Translate.cfg")
	else:
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Fr_Translate.cfg")
	$SavedLabel.text = translate_config.get_value("TranslationSave", "PositionSave")
	
func set_volume():
	for member in get_tree().get_nodes_in_group("sound_effect_group"):
		member.volume_db = $SaveManager.get_properties_value("effectVolume","effectVolumeSet")
