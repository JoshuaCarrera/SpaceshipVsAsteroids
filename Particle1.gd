extends CPUParticles2D


func _ready():
	$PopTimer.start()

func _on_PopTimer_timeout():
	queue_free()
