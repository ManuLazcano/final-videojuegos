extends CharacterBody2D

const GRAVITY : int = 4200
const JUMP_SPEED : int = -1800

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	
	if is_on_floor():
		 # Si el juego no está en ejecución, mostrar la animación "idle"
		if not get_parent().game_running:
			$AnimatedSprite2D.play("idle")
		else:
			$RunCollision.disabled = false # Habilitar la colisión para el estado de carrera
			if Input.is_action_pressed("ui_accept"):
				velocity.y = JUMP_SPEED	
				$JumpSound.play()			
			elif Input.is_action_pressed("ui_down"):
				$AnimatedSprite2D.play("down")
				$RunCollision.disabled = true  # Deshabilitar colision de correr mientras está agachado
			# Si no se presionan teclas de acción, reproducir la animación de correr
			else: 
				$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("jump")
		
	move_and_slide()
