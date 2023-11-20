import wollok.game.*
import pantallas.*
import armas.*
import enemigos.*
import jugador.*
import direcciones.*
import sonidos.*
import tablero.*

class Escena {

	method iniciarEscena()

}

class EscenaDeBatalla inherits Escena {
	
	const dificultad
	
	
	override method iniciarEscena() {
		sonidosManager.reproducirSonidoAmbiente("game_load.mp3")
		jugador.recargarBalas()
		const pantalla = new PantallaDeBatalla(dificultad = dificultad)
		pantalla.generar()
		selector.inicializar()		
		game.onTick(100, flotaEnemiga.identity().toString(), { flotaEnemiga.mover()})
		flotaEnemiga.ejecutarAlMorir({
			game.schedule(500, {	
				sonidosManager.detenerSonidoAmbiente()			
				balasManager.limpiarBalas()
				sonidosManager.reproducir(victoria)
				score.avanzarOleada()				
				escenasManager.cambiarEscenaA(new EscenaDePresentacionDeOleada())
			})
		})
			
		game.onCollideDo(jugador, { enemigo => enemigo.colision(jugador)})
		keyboard.left().onPressDo({ jugador.mover(izquierda)})
		keyboard.right().onPressDo({ jugador.mover(derecha)})
		keyboard.space().onPressDo({ jugador.disparar()})
		keyboard.y().onPressDo({flotaEnemiga.enemigos().forEach{en=> flotaEnemiga.remover(en)}})
	}
	
}

object menuPrincipal inherits Escena {
	override method iniciarEscena() {		
		pantallaMenu.generar()	
		game.schedule(0, {sonidosManager.reproducirSonidoAmbiente("game_enter.mp3")})
		keyboard.enter().onPressDo({
			m.finalizarMenu()
			sonidosManager.detenerSonidoAmbiente()
			escenasManager.presentarOleada()
		})	
	}
}

object escenasManager {

	const escenaInicial = new GameOver()//menuPrincipal//	new EscenaDeBatalla(dificultad = score.oleadaActual())

	method iniciarJuego(){
		ventana.iniciar()
		escenaInicial.iniciarEscena()
		game.start()
	}
	
	method cambiarEscenaA(escena){
		game.clear()
		escena.iniciarEscena()
	}
	
	method presentarOleada(){
		self.cambiarEscenaA(new EscenaDePresentacionDeOleada())
	}
	
	method iniciarBatalla(){
		self.cambiarEscenaA(new EscenaDeBatalla(dificultad = score.oleadaActual()))
	}
}
class GameOver inherits Escena{
	override method iniciarEscena() {
		gameOver.generar()		
	}
	
}

class EscenaDePresentacionDeOleada inherits Escena {
	override method iniciarEscena() {
		const pantallaDeOleada = new PantallaDeOleada(actual = score.oleadaActual())
		pantallaDeOleada.generar()
		game.schedule(2000, {
			escenasManager.iniciarBatalla()			
		})
	}
}




