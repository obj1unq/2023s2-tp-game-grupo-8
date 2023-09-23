import wollok.game.*
import qalaga.*
import direcciones.*
import colisiones.*

object encargadoDeSonidos {
	
	method reproducir(nombreDelSonido){
		game.sound(nombreDelSonido).play()
	}
}
