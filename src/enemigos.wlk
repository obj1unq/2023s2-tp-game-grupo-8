import wollok.game.*
import qalaga.*
import direcciones.*
import sonidos.*
import mapa.*
import tablero.*

object flotaNivelUno {

	const property enemigos = []

	method agregar(enemigo) {
		enemigos.add(enemigo)
	}

	method mover() {
		enemigos.forEach({ nave => nave.mover()})
	}

}

class NaveBasica {

	var property position
	var property direccion = derecha
	const property image = "nave1.png"

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
	
	method destruir() {
		game.removeVisual(self)
		encargadoDeSonidos.reproducir("esplosion.mp3")
	}

	method bajarYGirar(_position) {
		direccion = direccion.opuesto()
		return direccion.siguiente(self.bajar(_position))
	}
	
	method bajar(_position) {
		return _position.down(1)
	}
		

}

