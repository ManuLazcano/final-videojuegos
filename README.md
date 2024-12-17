# Diseño y Desarrollo de Videojuegos II

El objetivo del juego es esquivar obstaculos mientras se suma puntos, esta inspirado en el juego que te permite jugar Chrome cuando no hay internet.

#### Características principales
* Pantalla inicial:
Se implementó una pantalla de inicio con un menú interactivo que permite comenzar una nueva partida.
* Nivel funcional:
El juego incluye un nivel completo donde el jugador debe avanzar evitando obstáculos y acumulando puntos. El nivel incorpora:
	* Generación dinámica de obstáculos.
	* Movimiento fluido del personaje.
	* Ajuste progresivo de la dificultad.
* Pantalla de fin de juego:
Al finalizar la partida (por colisión con un obstáculo), se muestra una pantalla de "Game Over" con la puntuación final y la opción de reiniciar el juego.

#### Salvado y recuperación de puntajes
* Se implementó un sistema de persistencia que guarda la puntuación más alta alcanzada.
* Al iniciar el juego, se recupera automáticamente el puntaje guardado, el cual se muestra en la interfaz (HUD).
* Los puntajes se guardan en un archivo JSON.

####  Música y efectos de sonido
* Se incorporó música de fondo que acompaña la partida.
* Efectos de sonido específicos que se reproducen durante eventos, como:
	* Saltos del personaje.
	* El jugador pierde.

#### Video demostrativo
https://drive.google.com/file/d/15et7Ld9U7b-1btc73R8nk51QQDK5iwDJ/view?usp=sharing
