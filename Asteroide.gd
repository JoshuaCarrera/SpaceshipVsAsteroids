extends RigidBody2D

var number_rand = rand_range(1, 2)

var min_speed = 100## Velocidad de los asteroides
var max_speed = 200

var afuera = false
var offset = 40 # limite de la pantalla modificador

var dead = false
var una_vez = false
var veces_sonado = 0

var is_small = false
var is_smalled = false

var valor_score = 200



var velocity = Vector2()

func _ready():
	#$Valor_obtenido.hide()
	var asteroides_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = asteroides_types[randi() % asteroides_types.size()]

func pausar(pause_game):
	if pause_game and una_vez:
		sleeping = true
		una_vez = false
	if not pause_game and not una_vez:
		sleeping = false
		linear_velocity = velocity
		una_vez = true

func volverse_small():
	$AnimatedSprite.scale /= 2
	$CollisionShape2D.scale /= 2
	$Area2D/CollisionShape2D.scale /= 2
	$ParticulasFragmentacion.scale /= 2
	$SonidoImpacto.pitch_scale = 1.1
	is_small = true
	valor_score = 100
	
func fragmentarse():
	#$Valor_obtenido.show()
	$SonidoImpacto.play()
	$ParticulasFragmentacion.emitting = true
	collision_mask = 0
	collision_layer = 0
	$Area2D.collision_mask = 0
	$Area2D.collision_layer = 0
	#desactivar_colisiones($CollisionShape2D)
	$AnimatedSprite.hide()
	$TimerPop.start()
	sleeping = true
	
	if not is_small: get_parent().Fragmentos_asteroide(self)

func desactivar_colisiones(objeto):
	objeto.disabled = true
	

func _process(delta):
	#$Valor_obtenido.rect_rotation = get_parent().global_rotation
	if not sleeping:
		$AnimatedSprite.rotation_degrees += number_rand
		velocity = linear_velocity

func actualizar_pos(camera):
	if not sleeping:
		if global_position.y <= camera.global_position.y - (360 + offset): # Arriba
			global_position.y = camera.global_position.y + (360 + offset)
		elif global_position.y > camera.global_position.y + (360 + offset):# Abajo
			global_position.y = camera.global_position.y - (360 + offset)
		elif global_position.x <= camera.global_position.x - (512 + offset):# Izquierda
			global_position.x = camera.global_position.x + (512 + offset)
		elif global_position.x > camera.global_position.x + (512 + offset):# Derecha
			position.x = camera.global_position.x - (512 + offset)
		afuera = false


func _on_VisibilityNotifier2D_screen_exited():
	afuera = true


func _on_TimerPop_timeout():
	queue_free()
 
func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		if not body.dead:
			body.game_over()
	if veces_sonado >= 1:
		if body.is_in_group("asteroides"):
			#$SonidoChoque.play()
			pass
	veces_sonado+=1
