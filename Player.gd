extends KinematicBody2D

var rng = RandomNumberGenerator.new()

signal fire 
signal game_over

export (int) var speed = 350
export (int) var speed_aceleracion = 500
export (float) var rotation_speed = 4#Original 4

var velocity = Vector2()
var rotation_dir = 0

var frenado = false
var acelerando = false
var cooldown = false
var can_shoot = false
var dead = false
var drawParticle = false

var pause = false
var salvador_de_colisiones = false



func start():
	frenado = false
	acelerando = false
	can_shoot = false
	$TimerAntesDeDisparar.start()
	$SonidoMuerte.stop()
	$ParticulasExplosion.emitting = false
	$CollisionShape2D.disabled = false
	$AnimatedSprite.show()
	dead = false
	$SonidoMotor.play()

func game_over():
	var number_rand_pitch = rng.randf_range(0.95, 1.05)
	$SonidoMuerte.pitch_scale = number_rand_pitch
	$SonidoMuerte.play()
	$ParticulasExplosion.restart()
	$CollisionShape2D.disabled = true
	$AnimatedSprite.hide()
	$AnimatedSprite.animation = "normal"
	emit_signal("game_over")
	dead = true
	$SonidoMotor.stop()
	
	velocity = Vector2()## Parar nave
	
func get_input():
	rotation_dir = 0
	if Input.is_action_pressed("ui_select") and not cooldown:
		if can_shoot:
			emit_signal("fire")
			$AnimatedSprite.animation = "disparando"
			$SonidoDisparo.play()
			$TimerCooldown.start()
			cooldown = true
			salvador_de_colisiones = true
			$TimerSalvado.start()
		
	if Input.is_action_just_released("ui_select"):
		$AnimatedSprite.animation = "normal"
	
	if Input.is_action_pressed('ui_right'):
		rotation_dir += 1
	if Input.is_action_pressed('ui_left'):
		rotation_dir -= 1
	if Input.is_action_pressed('ui_down'):
		frenado = true
	if Input.is_action_pressed('ui_up'):
		acelerando = true
	if Input.is_action_just_pressed('ui_up'):
		frenado = false
	if Input.is_action_just_released("ui_up"):
		acelerando = false
	
	
	if frenado:
		velocity = Vector2(speed / 2, 0).rotated(rotation)
		$SonidoDisparo.pitch_scale = 0.9
		$SonidoMotor.pitch_scale = 0.8
	elif acelerando:
		velocity = Vector2(speed_aceleracion, 0).rotated(rotation)
		$SonidoDisparo.pitch_scale = 1.12
		$SonidoMotor.pitch_scale = 1.4
	else:
		velocity = Vector2(speed, 0).rotated(rotation)
		$SonidoDisparo.pitch_scale = 1
		$SonidoMotor.pitch_scale = 1
func _process(delta):

	if not pause:
		if not dead:
			get_input()
	
func _physics_process(delta):
	if not dead:
		rotation += rotation_dir * rotation_speed * delta
		velocity = move_and_slide(velocity, Vector2.UP,
			false, 4, PI/4, false)## Esto hace que se pueda colisionar con RigigBody
		if get_slide_count() != 0:
			game_over()### Perder
				
func _on_TimerCooldown_timeout():
	cooldown = false

func _on_TimerParticulas_timeout():
	drawParticle = false




func _on_Area2D_body_entered(body):
	if salvador_de_colisiones:
		if body.is_in_group("asteroides"):
			body.fragmentarse() 
			get_parent().score+=body.valor_score
			get_parent().actualizar_score()
			get_parent().mostrar_valor_asteroide(body)


func _on_TimerSalvado_timeout():
	salvador_de_colisiones = false


func _on_TimerAntesDeDisparar_timeout():
	can_shoot = true
