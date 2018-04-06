extends Node2D

# Global variables
const SPEED = 30.0

var start = self.position

var begin = Vector2()
var end = Vector2()
var path = []
var walking = false

onready var navNode = get_node("../Navigation2D")
onready var anim = get_node("AnimatedSprite")
onready var timer = Timer.new()

func _ready():
	start = self.position
	
	timer.connect("timeout",self,"_on_Timer_timeout")
	add_child(timer)
	timer.set_wait_time(2)
	timer.start() #to start
	
func _on_Timer_timeout():
	begin = self.position
	var randomMoveX = rand_range(-50,50)
	var randomMoveY = rand_range(-50,50)
	end = Vector2((start.x + randomMoveX),(start.y + randomMoveY)) 
	if end.x<self.position.x:
		anim.flip_h = true
	else:
		anim.flip_h = false
	anim.play("walk")
	_update_path()


func _process(delta):
	if path.size() > 1 and walking:
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
		self.position = atpos
		
		if path.size() < 2:
			path = []
			#set_process(false)
			walking = false
			anim.play("idle")
	else:
		#set_process(false)
		walking=false
		anim.play("idle")
		
		
func _update_path():
	var p = navNode.get_simple_path(begin, end, true)
	path = Array(p) # PoolVector2Array too complex to use, convert to regular array
	path.invert()
	walking = true
	#set_process(true)

