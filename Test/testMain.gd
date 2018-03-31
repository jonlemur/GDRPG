extends Node2D


func _ready():

	var cam = get_node("Navigation2D/agent/Camera2D")
	cam.make_current()
	#pass
