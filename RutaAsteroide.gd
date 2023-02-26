extends Path2D

var offset = 40

func _ready():
	pass

func _draw():
	#draw_polyline (get_curve().get_baked_points (), Color.aquamarine, 5, true)
	pass
	
func actualizar_curve2d(pos_referencia, screenSize):
	var pos = Vector2(pos_referencia.x - screenSize.x/2 - offset, pos_referencia.y - screenSize.y/2 - offset)
	curve.set_point_position(0, pos)## Son la misma posicion
	curve.set_point_position(4, pos)## Arriba izquierda
	
	pos = Vector2(pos_referencia.x + screenSize.x/2 + offset, pos_referencia.y - screenSize.y/2 - offset)
	curve.set_point_position(1, pos)# Derecha arriba
	
	pos = Vector2(pos_referencia.x + screenSize.x/2 + offset, pos_referencia.y + screenSize.y/2 + offset)
	curve.set_point_position(2, pos)# Derecha abajo
	
	pos = Vector2(pos_referencia.x - screenSize.x/2 - offset, pos_referencia.y + screenSize.y/2 + offset)
	curve.set_point_position(3, pos)# Abajo izquierda
	
	update()
	
