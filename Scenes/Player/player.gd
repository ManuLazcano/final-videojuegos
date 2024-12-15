extends CharacterBody2D

const MOVE_SPEED = 25
const MAX_SPEED = 70
const JUMP_HEIGHT = -300
const GRAVITY = 15

# Referencias
@onready var sprite = $Sprite2D
@onready var animationPlayer = $AnimationPlayer

func _physics_process(delta: float):
	# Aplicar al gravedad al eje vertical para que el personaje caiga
	velocity.y += GRAVITY
	var friction = false

	if Input.is_action_pressed("ui_right"):
		sprite.flip_h = false
		animationPlayer.play("Walk")
		velocity.x = min(velocity.x + MOVE_SPEED, MAX_SPEED)

	elif Input.is_action_pressed("ui_left"):
		sprite.flip_h = true
		animationPlayer.play("Walk")
		velocity.x = max(velocity.x - MOVE_SPEED, -MAX_SPEED)

	else:
		animationPlayer.play("Idle")
		friction = true # Activar fricción para desacelerar al personaje

	if is_on_floor():
		if Input.is_action_pressed("ui_accept"):
			velocity.y = JUMP_HEIGHT
		# Si no se está moviendo, aplicar fricción para reducir la velocidad horizontal gradualmente
		if friction:
			velocity.x = lerp(velocity.x, 0.0, 0.5)
	else: # Si el personaje está en el aire, aplicar una fricción menor para un efecto más suave
		if friction:
			velocity.x = lerp(velocity.x, 0.0, 0.01)

	move_and_slide()
