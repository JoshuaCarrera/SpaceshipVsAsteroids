extends CanvasLayer

signal start_game

var in_menu = true

func _ready():
	pass
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if not in_menu:
			get_tree().paused = not get_tree().paused
			get_parent().is_pause = get_tree().paused
		if not get_parent().is_pause:
			$EtiquetaPausa.hide()
			$BestScore.hide()
		elif not in_menu:
			$EtiquetaPausa.show()
			$BestScore.show()
		

func _on_BotonStart_pressed():
	emit_signal("start_game")
	$BotonStart.hide()
	$Title1.hide()
	$Title2.hide()
	$Title3.hide()
	$NameDev.hide()
	$Score.show()
	in_menu = false
