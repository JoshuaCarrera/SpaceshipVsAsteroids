extends KinematicBody2D


var speed = 300 #Original 600
var speed_giro = 10
var velocity = Vector2()
var fired = false
var rotation_dir = 0

var velocity_saved

var una_vez = false
var pausa = false

var velocidad_acumulada = Vector2()

func pausar(pause_game):
	if pause_game and una_vez:
		pausa = true
		una_vez = false
		var velocity = Vector2()
		move_and_slide(velocity)
		
	if not pause_game and not una_vez:
		pausa = false
		una_vez = true

func _ready():
	pass

func shoot(positionp, rotate, player_velocity):
	position = positionp
	rotation_dir = rotate
	rotation = rotation_dir
	velocidad_acumulada = player_velocity
	fired = true
	
func _physics_process(delta):
	if not pausa:
		if fired:
			var velocity = Vector2(speed, 0).rotated(rotation_dir)
			#if velocidad_acumulada >= velocity:
			velocity += velocidad_acumulada
			#velocity += velocidad_acumulada
			move_and_slide(velocity)
			
	
func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()# Desaparecer si se va del la pantalla

func _on_Area2D_body_entered(body):
	if body.is_in_group("asteroides"):
		body.fragmentarse() 
		queue_free()

		get_parent().score+=body.valor_score
		get_parent().actualizar_score()
		get_parent().mostrar_valor_asteroide(body)

