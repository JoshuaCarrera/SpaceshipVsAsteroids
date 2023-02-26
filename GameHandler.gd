extends Node

export (PackedScene) var Bullet
export (PackedScene) var Particle

export (PackedScene) var Asteroid

export (PackedScene) var label_valor

var limite_asteroides = 4
var indice_asteroide = 0

var particle_draw = false
var is_pause = true
var can_shoot = false
var screenSize = Vector2(0,0)

var score = 0
var score_best = 0


func start_game():
	limite_asteroides = 4
	indice_asteroide = 0
	if score_best < score:
		score_best = score
	score = 0
	actualizar_score()
	get_tree().call_group("asteroides", "queue_free")
	get_tree().call_group("balas", "queue_free")
	$TimerLapseParticle.start()
	$TimerSpawnAsteroide.start()
	$Player.start()
	is_pause = false
	get_tree().paused = false

func game_over():
	$TimerLapseParticle.stop()
	$TimerSpawnAsteroide.stop()
	$TimerReStart.start()

func actualizar_score():
	if score_best <= score:
		score_best = score
		$HUD/BestScore.text = "Best: "+str(score_best)
	$HUD/Score.text = str(score)

func _ready():
	get_tree().paused = true
	$HUD/EtiquetaPausa.hide()
	#$CanvasLayer/ParallaxBackground/capa1/Sprite.modulate = Color(0.7, 0.7, 0.7) # blue shade
	screenSize.x = get_viewport().get_visible_rect().size.x # Get Width
	screenSize.y = get_viewport().get_visible_rect().size.y # Get Height
	randomize()
	
func _physics_process(delta):
	particulas_actualizar()
	$RutaAsteroide.actualizar_curve2d($Player.position, screenSize)
	get_tree().call_group("asteroides", "actualizar_pos", $Player/Camera2D)
	
func _on_Player_fire():## Disparar
	var bala = Bullet.instance()
	add_child(bala)
	bala.shoot($Player/Positionbullet.global_position, $Player.rotation, $Player.velocity)

func _on_TimerLapseParticle_timeout():
	particle_draw = not particle_draw

func _on_TimerReStart_timeout():
	start_game()
	
func _on_TimerSpawnAsteroide_timeout():
	if indice_asteroide < limite_asteroides:
		# Choose a random location on Path2D.
		$RutaAsteroide/SpawnAsteroide.offset = randi()
		var asteroide = Asteroid.instance()
		add_child(asteroide)
		
		var direction = $RutaAsteroide/SpawnAsteroide.rotation + PI/2
		
		direction += rand_range(-PI / 4, PI / 4)
		asteroide.rotation = (direction)
		asteroide.position = $RutaAsteroide/SpawnAsteroide.position
		asteroide.linear_velocity = Vector2(rand_range(asteroide.min_speed, asteroide.max_speed), 0)
		asteroide.linear_velocity = asteroide.linear_velocity.rotated(direction)
		asteroide.rotation_degrees = rad2deg(direction)
		asteroide.velocity = asteroide.linear_velocity
		indice_asteroide += 1

func _on_Player_game_over():
	game_over()

func particulas_actualizar():
	if particle_draw:
		var particula = Particle.instance()
		add_child(particula)
		particula.position = $Player.global_position
		particula.rotation = $Player.rotation
		particle_draw = false

func _on_HUD_start_game():
	start_game()

func mostrar_valor_asteroide(asteroide):
	var label = label_valor.instance()
	label.text = str(asteroide.valor_score)
	if asteroide.is_small: label.rect_scale /= 1.5
	else: indice_asteroide -= 1
	call_deferred("add_child", label)
	if asteroide.is_small: 
		label.rect_position.x = asteroide.global_position.x - 21# offset para llegar
		label.rect_position.y = asteroide.global_position.y - 27
	else:
		label.rect_position.x = asteroide.global_position.x - 20# offset para llegar
		label.rect_position.y = asteroide.global_position.y - 22
		
	pass
	

func Fragmentos_asteroide(asteroide_fragmentado):
	randomize()	

	var direcciones = []
	var posiciones = []
	var dir = true
	if randi() % 2:
		dir = false 
	if dir:
		direcciones = [210, 330, 90]
		posiciones = [Vector2(-20, 0), Vector2(20, 0), Vector2(0, +20)]
	if not dir:
		direcciones = [270, 150, 40]
		posiciones = [Vector2(0, 0), Vector2(-20, +20), Vector2(+20, +20)]
	for i in range(0, 3):
		var asteroide = Asteroid.instance()
		call_deferred("add_child", asteroide)
		asteroide.volverse_small()

		asteroide.global_position = asteroide_fragmentado.global_position + posiciones[i]
		asteroide.linear_velocity = Vector2(asteroide.max_speed, 0)
		asteroide.linear_velocity = asteroide.linear_velocity.rotated(deg2rad(direcciones[i]))
		asteroide.velocity = asteroide.linear_velocity
