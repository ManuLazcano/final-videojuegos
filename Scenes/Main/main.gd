extends Node

# Precargar escenas de obstáculos para instanciarlas dinámicamente durante el juego
var trunk_scene = preload("res://Scenes/Obstacles/Trunk.tscn")
var stone_scene = preload("res://Scenes/Obstacles/Stone.tscn")
var box_scene = preload("res://Scenes/Obstacles/Box.tscn")
var plane_scene = preload("res://Scenes/Plane/Plane.tscn")
var obstacle_types := [trunk_scene, stone_scene, box_scene]
var obstacles : Array # Registro de los obstáculos creados dinámicamente
var plane_heights := [200, 390] # Alturas posibles para los aviones

# Variables relacionadas con el juego
const PLAYER_START_POS := Vector2i(150, 485)
const CAM_START_POS := Vector2i(576, 324)
var difficulty
const MAX_DIFFICULTY : int = 2
var score : int
const SCORE_MODIFIER : int = 10
var high_score : int
var speed : float # Velocidad actual del juego
const START_SPEED : float = 10.0
const MAX_SPEED : int = 25
const SPEED_MODIFIER : int = 5000 # Factor que afecta la velocidad/dificultad
var screen_size : Vector2i
var ground_height : int
var game_running : bool
var last_obs

# Configuración inicial al cargar la escena
func _ready():
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	$GameOver.get_node("Button").pressed.connect(new_game) # Conectar el botón de reinicio
	new_game()

# Configuración inicial de las variables y el estado del juego
func new_game():
	# Reiniciar variables
	score = 0
	show_score()
	game_running = false
	get_tree().paused = false
	difficulty = 0
	
	# Eliminar todos los obstáculos
	for obs in obstacles:
		obs.queue_free()
	obstacles.clear()
	
	# Reiniciar las posiciones de los nodos principales
	$Player.position = PLAYER_START_POS
	$Player.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$Ground.position = Vector2i(0, 0)
	
	# Restablecer la interfaz
	$HUD.get_node("StartLabel").show()
	$GameOver.hide()
	
	$Music.play()


func _process(delta):
	if game_running:
		# Incrementar la velocidad y ajustar la dificultad
		speed = START_SPEED + score / SPEED_MODIFIER
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		adjust_difficulty()
		
		# Generar obstáculos
		generate_obs()
		
		# Mover al jugador y a la cámara hacia la derecha
		$Player.position.x += speed
		$Camera2D.position.x += speed
		
		# Actualizar la puntuación
		score += speed
		show_score()
		
		# Ajustar la posición del suelo para crear un efecto de desplazamiento continuo
		if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
			$Ground.position.x += screen_size.x
			
		# Eliminar obstáculos que ya no están en pantalla
		for obs in obstacles:
			if obs.position.x < ($Camera2D.position.x - screen_size.x):
				remove_obs(obs)
	else:
		# Iniciar el juego al presionar el botón de aceptar (ui_accept)
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			$HUD.get_node("StartLabel").hide()

# Generar nuevos obstáculos en el suelo o aviones al azar
func generate_obs():	
	# Verifica si la lista de obstáculos está vacía o si el último obstáculo está lo suficientemente lejos del jugador
	if obstacles.is_empty() or last_obs.position.x < score + randi_range(300, 500):
		# Selecciona aleatoriamente un tipo de obstáculo del suelo (tronco, piedra, caja)
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var obs
		var max_obs = difficulty + 1
		
		 # Genera entre 1 y `max_obs` obstáculos del mismo tipo
		for i in range(randi() % max_obs + 1):
			obs = obs_type.instantiate()
			# Obtiene la altura y escala del sprite del obstáculo para calcular su posición Y
			var obs_height = obs.get_node("Sprite2D").texture.get_height()
			var obs_scale = obs.get_node("Sprite2D").scale
			 # Calcula la posición X del obstáculo, basada en la posición actual de la cámara/jugador
			var obs_x : int = screen_size.x + score + 100 + (i * 100)
			 # Calcula la posición Y del obstáculo, asegurándose de que quede sobre el suelo
			var obs_y : int = screen_size.y - ground_height - (obs_height * obs_scale.y / 2) + 5
			# Actualiza el último obstáculo generado y añade el obstáculo a la escena
			last_obs = obs
			add_obs(obs, obs_x, obs_y)
		# Posibilidad de generar un avión
		if difficulty == MAX_DIFFICULTY:
			if (randi() % 2) == 0:
				 # Instancia un nuevo avión
				obs = plane_scene.instantiate()
				# Calcula la posición X del avión (en el horizonte del jugador)
				var obs_x : int = screen_size.x + score + 100
				# Selecciona una altura aleatoria entre las alturas predefinidas para los aviones
				var obs_y : int = plane_heights[randi() % plane_heights.size()]
				
				add_obs(obs, obs_x, obs_y)

# Añadir obstáculos al árbol y a la lista de seguimiento
func add_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacles.append(obs)

# Eliminar un obstáculo de la pantalla y del registro
func remove_obs(obs):
	obs.queue_free()
	obstacles.erase(obs)
	
# Detectar colisiones entre el jugador y los obstáculos
func hit_obs(body):
	if body.name == "Player":
		game_over()

func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score / SCORE_MODIFIER)

# Comprobar si se supera la puntuación más alta
func check_high_score():
	if score > high_score:
		high_score = score
		$HUD.get_node("HighScoreLabel").text = "HIGH SCORE: " + str(high_score / SCORE_MODIFIER)

# Ajustar la dificultad en función de la puntuación
func adjust_difficulty():
	difficulty = score / SPEED_MODIFIER
	if difficulty > MAX_DIFFICULTY:
		difficulty = MAX_DIFFICULTY

func game_over():
	check_high_score()
	get_tree().paused = true
	game_running = false
	$GameOver.show()
	$Music.stop()
	$DeathSound.play()
