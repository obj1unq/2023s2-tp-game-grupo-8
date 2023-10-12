import wollok.game.*
import qalaga.*
import direcciones.*
import sonidos.*
import mapa.*
import tablero.*
import randomizer.*

// Probar una posible herencia (Habria que pasar a clases)
object flotaNivelUno {

	var property enemigos = []

	method agregar(enemigo) {
		enemigos.add(enemigo)
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
	var property estado = volando

	method image() {
		return estado.image()
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

	var property position
	var property direccion = derecha
	var property estado = volando

	method image() {
		return estado.image()
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

	method colision(algo) { // colision.refactori
		self.destruir()
		algo.destruir() // aca quedaria bien un power up de invencible 
		self.remover(self)
	}

	method destruir() {
		score.aumentarPuntos()
		self.estado(destruida)
		flotaNivelUno.remover(self)
		game.schedule(100, { game.removeVisual(self)})
		encargadoDeSonidos.reproducir("esplosion.mp3")
	}

	method remover(naveActual) {
		game.removeVisual(naveActual)
		game.removeTickEvent("MovimientoEnemigo")
	}

}

object volando {

	method image() {
		return "nave1.png"
	}

}

object destruida {

	method image() {
		return "esplosion.png"
	}

}

