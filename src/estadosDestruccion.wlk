import tablero.score
import enemigos.flotaEnemiga
import wollok.game.*
import sonidos.*

class PuedeSerDestruida{
	method ejecutar(colisionable){
		score.aumentarPuntos()
		colisionable.animarDestruccion()		
		flotaEnemiga.remover(colisionable)
		game.schedule(100, { 
			game.removeVisual(colisionable)
			colisionable.animacion().detener()
		})
		sonidosManager.reproducir(esplosion)
		colisionable.estadoDestruccion(new EnDestruccion())
	}
}

class EnDestruccion {
	method ejecutar(colisionable){
		
	}
}
