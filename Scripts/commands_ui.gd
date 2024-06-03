extends Control

var player_have_dash
# Called when the node enters the scene tree for the first time.
func _ready():
	$Dash.hide()
	$Keyboard1/DashK1.hide()
	$Keyboard2/DashK2.hide()
	$Controller/DashC.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player_have_dash:
		$Dash.show()
		$Keyboard1/DashK1.show()
		$Keyboard2/DashK2.show()
		$Controller/DashC.show()
