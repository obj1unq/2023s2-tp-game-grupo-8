import wollok.game.*
import qalaga.*
import direcciones.*

object encargadoDeSonidos {
	
	method reproducir(nombreDelSonido){
		game.sound(nombreDelSonido).play()
	}
}
