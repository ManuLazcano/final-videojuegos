extends Area2D

func _process(delta):
	# Actualiza la posición horizontal del objeto moviéndolo hacia la izquierda
	# La velocidad del movimiento depende de la propiedad 'speed' del nodo padre
	position.x -= get_parent().speed / 2
