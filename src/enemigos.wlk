import wollok.game.*
import jugador.*
import tablero.*
import animacion.*
import direcciones.*
import sonidos.*
import mapa.*
import animacion.*
import estadosDestruccion.*

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

class NaveBasica {
	const objetivo = jugador
	var property position
	var property direccion = derecha	
	var property animacion = new AnimacionEnemigo()
	var property estadoDestruccion = new PuedeSerDestruida()

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
			objetivo.destruir() 
		}
	}

	method destruir() {
		estadoDestruccion.ejecutar(self)
	}	
	
	method animarDestruccion(){
		animacion.detener()
		animacion = new Destruccion()
		animacion.iniciar()
	}
}
