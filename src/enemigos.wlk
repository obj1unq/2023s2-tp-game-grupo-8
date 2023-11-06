import wollok.game.*
import jugador.*
import tablero.*
import animacion.*
import direcciones.*
import sonidos.*
import mapa.*
import randomizer.*
import animacion.*
import estrategiasDeDestruccion.*

// Probar una posible herencia (Habria que pasar a clases)
object flotaNivelUno {

	const property enemigos = []

	method agregar(enemigo) {
		enemigos.add(enemigo)
		enemigo.animacion().iniciar()
	}

	method mover() {
		enemigos.forEach({ nave => nave.mover()})
	}

	method remover(enemigo) {
		enemigos.remove(enemigo)
	}

	method estaMuerta() {
		return enemigos.isEmpty()
	}

}

object flotaNivelDos {

	const property enemigos = []

	method agregar(enemigo) {
		enemigos.add(enemigo)
	}

	method mover() {
		enemigos.forEach({ nave => nave.mover()})
	}

	method tiempoDeGeneracion() {
		return if (score.puntos() < 2000) {
			2000
		} else if (score.puntos().beetwen(2000, 3000)) {
			1500
		} else {
			1000
		}
	}

}

//Crear una naveEnemiga y despues usar herencia
class NaveNivel2 {

	var property position = game.at(0, game.height() - 1)
	var property direccion = abajo
	//var property estado = volando

	method image() {
		return"" 
		//estado.image()
	}

	method mover() {
		const proxima = direccion.siguiente(self.position())
		if (self.llegoAlLimiteInferior()) {
			game.removeVisual(self)
		}
		self.position(proxima)
	}

	method llegoAlLimiteInferior() {
		return self.position().y() == 1
	}

}

class NaveBasica {
	const objetivo = jugador
	var property position
	var property direccion = derecha	
	var property animacion = new AnimacionEnemigo()
	var property estrategiaDeDestruccion = new PuedeSerDestruida()

	method image() {
		return animacion.image()
	}

	method mover() {
		var proxima = direccion.siguiente(self.position())
		if (self.debeGirar(proxima)) {
			proxima = self.bajarYGirar(proxima)
		}
		self.position(proxima)
	}

	method debeGirar(_position) {
		return not self.puedeIr(_position)
	}

	method puedeIr(_position) {
		return tablero.pertenece(_position)
	}

	method bajarYGirar(_position) {
		direccion = direccion.opuesto()
		return direccion.siguiente(self.bajar(_position))
	}

	method bajar(_position) {
		return _position.down(1)
	}

	method debeGirar() = self.position().x() >= game.width() - 10 || self.position().x() <= 10

	method colision(algo) { 
		//Solo destruye al objetivo
		if(algo == objetivo){
			self.destruir()
			objetivo.destruir() // aca quedaria bien un power up de invencible
		}
	}

	method destruir() {
		estrategiaDeDestruccion.ejecutar(self)
	}	
	
	method animarDestruccion(){
		animacion.detener()
		animacion = new Destruccion()
		animacion.iniciar()
	}
}
