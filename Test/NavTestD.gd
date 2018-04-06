extends Navigation2D

# Global variables
const SPEED = 60.0

var begin = Vector2()
var end = Vector2()
var path = []


onready var player = get_node("player")
onready var playerAnim = get_node("player/AnimatedSprite")

onready var clickAnim = preload("res://sceneAssets/clickAnim.tscn")

func _ready():
	#var player = get_node("player")
	pass

func _process(delta):
	if path.size() > 1:
		var to_walk = delta * SPEED
		while to_walk > 0 and path.size() >= 2:
			var pfrom = path[path.size() - 1]
			var pto = path[path.size() - 2]
			var d = pfrom.distance_to(pto)
			if d <= to_walk:
				path.remove(path.size() - 1)
				to_walk -= d
			else:
				path[path.size() - 1] = pfrom.linear_interpolate(pto, to_walk/d)
				to_walk = 0
		
		var atpos = path[path.size() - 1]
		player.position = atpos
		
		if path.size() < 2:
			path = []
			set_process(false)
			playerAnim.play("idle")
	else:
		set_process(false)
		playerAnim.play("idle")


func _update_path():
	var p = get_simple_path(begin, end, true)
	path = Array(p) # PoolVector2Array too complex to use, convert to regular array
	path.invert()
	
	set_process(true)


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		begin = player.position
		
		#print(get_node("agent/Camera2D").get_local_mouse_position())
		var mPos = get_node("player/Camera2D").get_global_mouse_position()
		
		
		playerAnim.play("walk")
		if mPos.x < player.position.x:
			playerAnim.flip_h  =true
		else:
			playerAnim.flip_h  =false
		
		#make click animation
		var clickA  = clickAnim.instance()
		add_child(clickA)
		clickA.position = mPos
		
		# Mouse to local navigation coordinates
		#print(event.position)
		end = mPos - position
		#end = event.position - position
		_update_path()