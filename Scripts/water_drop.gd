extends Node2D

var drop_exploded
@export var speed = 200
# Called when the node enters the scene tree for the first time.
func _ready():
	drop_exploded = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(get_parent().progress_ratio == 0):
		drop_exploded = false
		$AnimatedSprite2D.animation = "WaterDrop"
		get_parent().progress += speed * delta
	check_for_explosion_animation()


func check_for_explosion_animation():
	if(get_parent().progress_ratio == 1):
		$AnimatedSprite2D.animation = "DropExplosion"
		$AnimatedSprite2D.play()
		await $AnimatedSprite2D.animation_finished
		drop_exploded = true
