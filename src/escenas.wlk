import wollok.game.*
import mapa.*
import armas.*
import enemigos.*
import jugador.*
import direcciones.*
import sonidos.*

class Escena {

	method iniciar() {
		
		self.iniciarEscena()		
	}

	method iniciarEscena()

}
//object
object nivelUno inherits Escena {
	
	override method iniciarEscena() {
		mapa.generar()
		selector.inicializar()		
		game.onTick(100, "MovimientoEnemigo", { flotaNivelUno.mover()})
		game.onCollideDo(jugador, { enemigo => enemigo.colision(jugador)})
		keyboard.left().onPressDo({ jugador.mover(izquierda)})
		keyboard.right().onPressDo({ jugador.mover(derecha)})
		keyboard.space().onPressDo({ jugador.disparar()})
	}
}

object menuPrincipal inherits Escena {
	override method iniciarEscena() {
		mapaMenu.generar()		
	}
}

object escenasManager {

	const escenaInicial = menuPrincipal//nivelUno

	method iniciarJuego(){
		ventana.iniciar()
		escenaInicial.iniciar()
		game.start()
		
	}
	
	method cambiarEscenaA(escena){
		game.clear()
		escena.iniciar()
	}
}
class GameOver inherits Escena{
	//const property puntuacion
	override method iniciarEscena() {
		gameOver.generar()		
	}
	
}

class EscenaDePresentacionDeOleada inherits Escena {
	override method iniciarEscena() {
		const pantallaDeOleada = new PantallaDeOleada(oleada = 3)
		pantallaDeOleada.generar()
	}
}


