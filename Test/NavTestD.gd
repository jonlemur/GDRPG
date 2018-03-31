extends Navigation2D

# Global variables
const SPEED = 100.0

var begin = Vector2()
var end = Vector2()
var path = []

func _ready():
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
		$agent.position = atpos
		
		if path.size() < 2:
			path = []
			set_process(false)
	else:
		set_process(false)


func _update_path():
	var p = get_simple_path(begin, end, true)
	path = Array(p) # PoolVector2Array too complex to use, convert to regular array
	path.invert()
	
	set_process(true)


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		begin = $agent.position
		
		#print(get_node("agent/Camera2D").get_local_mouse_position())
		var mPos = get_node("agent/Camera2D").get_global_mouse_position()
		
		# Mouse to local navigation coordinates
		#print(event.position)
		end = mPos - position
		#end = event.position - position
		print(end)
		_update_path()