extends Light2D

var lightStrength = [0.3, 0.5, 0.6, 0.8]
var timer= 0

var currentLighStrength = 0.5
var newLightValue = 0.5

func _process(delta):
	timer +=1
	
	if timer== 10:
		var randInt = randi()%3+1

		newLightValue = lightStrength[randInt]
		
		timer = 0
	
	if currentLighStrength != newLightValue:
		if currentLighStrength < newLightValue:
			currentLighStrength+=0.01
			self.energy = currentLighStrength
		else:
			currentLighStrength-=0.01
			self.energy = currentLighStrength
		


