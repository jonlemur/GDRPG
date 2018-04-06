extends Node2D

onready var animNode = get_node("AnimatedSprite")

var wait = 0

func _ready():
	animNode.play("default")
	

func _process(delta):
	#if (animNode.playing == true):
		#print("stopped playing") 
	wait +=1 
	if wait == 40:
		get_parent().remove_child(self)