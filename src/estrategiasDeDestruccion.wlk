import tablero.score
import enemigos.flotaNivelUno
import wollok.game.*
import sonidos.*

class PuedeSerDestruida{
	method ejecutar(colisionable){
		score.aumentarPuntos()
		colisionable.animarDestruccion()		
		flotaNivelUno.remover(colisionable)
		game.schedule(100, { 
			game.removeVisual(colisionable)
			colisionable.animacion().detener()
		})
		encargadoDeSonidos.reproducir("esplosion.mp3")
		colisionable.estrategiaDeDestruccion(new EnDestruccion())
	}
}

class EnDestruccion {
	method ejecutar(colisionable){
		
	}
}
