extends Node2D

@onready var camera: Camera2D = $Cam
@onready var player: Player = $Player		

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera.set_position(Vector2(player.get_position().x, 0))
