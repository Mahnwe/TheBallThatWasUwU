extends StaticBody2D

signal player_entered
@export var sprite_id = 0

var is_trigger
@export var time_ability = 9

var translate_file

# Called when the node enters the scene tree for the first time.
func _ready():
	is_trigger = false
	translate_text()
	if sprite_id == 0:
		$Sprite2D.texture = load("res://Arts/AbilitySprite/DashAbilitySprite-removebg-preview.png")
	elif sprite_id == 1:
		$Sprite2D.texture = load("res://Arts/AbilitySprite/DoubleJumpAbilitySprite-removebg-preview.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		if !is_trigger:
			$AbilitySound.play()
			is_trigger = true
		player_entered.emit()
		$BubbleTooltip.show()
		$Label2.hide()
		$Sprite2D2.hide()
		for n in time_ability:
			$Sprite2D.hide()
			await get_tree().create_timer(0.2).timeout;
			$Sprite2D.show()
			await get_tree().create_timer(0.2).timeout;
		queue_free()
		
func translate_text():
	var translate_config = ConfigFile.new()
	if $SaveManager.get_properties_value("Languages", "is_english"):
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Eng_Translate.cfg")
	else:
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Fr_Translate.cfg")
		$Label2.text = translate_config.get_value("TranslationAbility", "AbilityDesc")
