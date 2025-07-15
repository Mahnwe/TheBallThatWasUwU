extends Node2D

var level_6_texture = preload("res://Arts/BackgroundSprite/BackgroudParalaxLvl6.png")
var level_5_texture = preload("res://Arts/BackgroundSprite/BackgroundParalaxLvl5.png")
var level_4_texture = preload("res://Arts/BackgroundSprite/BackgroundParalaxLvl4.png")
var level_3_texture = preload("res://Arts/BackgroundSprite/BackgroudParalaxLvl3.png")
var level_2_texture = preload("res://Arts/BackgroundSprite/ParalaxBackgroundLvl2.png")
var level_1_texture = preload("res://Arts/BackgroundSprite/BackgroundParalaxTest.png")

var actual_background

func _ready():
	change_background(level_6_texture)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func change_background(background_texture):
	actual_background = background_texture
	if actual_background == level_1_texture or actual_background == level_2_texture:
		$ParallaxBackground/Parallax2D/CenterBackground.scale = Vector2(2.058,2.747)
	else:
		$ParallaxBackground/Parallax2D/CenterBackground.scale = Vector2(2.058, 1.643)
	$ParallaxBackground/Parallax2D/CenterBackground.texture = background_texture
	$ParallaxBackground/Parallax2D/CenterBackground/LeftBackground.texture = background_texture
	$ParallaxBackground/Parallax2D/CenterBackground/RightBackground.texture = background_texture
