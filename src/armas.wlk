import wollok.game.*
import pantallas.*
import sonidos.*
import direcciones.*
import tablero.*
import jugador.*
import sonidos.*
import ticks.*

class RecuadroArma {

	const property position

	method image() {
		return "recuadroArma.png"
	}

}

object selector {

	var property position = en.posicion(0, 0)
	const property image = "selector.png"
	const property recuadrosPosition = []

	method agregarRecuadro(_position) {
		recuadrosPosition.add(_position)
	}

	method inicializar() {
		self.aniadirVisuales()
		self.activarBala(creadorDeBalas)
		keyboard.num1().onPressDo({ self.activarBala(creadorDeBalas)})
		keyboard.num2().onPressDo({ self.activarBala(creadorDeTiroTriple)})
	}

	method aniadirVisuales() {
		self.aniadirCreadorBala(creadorDeBalas)
		self.aniadirCreadorBala(creadorDeTiroTriple)
	}

	method aniadirCreadorBala(creador) {
		creador.position(self.positionPara(creador))
		game.addVisual(creador)
	}

	method activarBala(creador) {
		self.position(self.positionPara(creador))
		jugador.creadorDeBala(creador)
	}

	method positionPara(creador) {
		return recuadrosPosition.get(creador.indice())
	}

}

class CreadorDeBala {

	var property position = null

	method crear(_position)

	method image()

	method extension() = ".png"

	method indice()

}

object creadorDeBalas inherits CreadorDeBala {

	override method crear(_position) {
		const bala = new TiroSimple(position = _position)
		balasManager.agregarTiro(bala)
	}

	override method image() {
		return "bala" + self.extension()
	}

	override method indice() {
		return 0
	}

}

object creadorDeTiroTriple inherits CreadorDeBala {

	override method crear(_position) {
		const vectores = [ new Punto(x= 1, y = 1), new Punto(x= 0, y = 1), new Punto(x= -1, y = 1) ]
		vectores.map({ vector => new TiroTriple(movimiento = vector, position = _position)}).forEach({ bala => balasManager.agregarTiro(bala)})
	}

	override method image() {
		return "bala_triple" + self.extension()
	}

	override method indice() {
		return 1
	}

}

class Bala {

	var property position

	method image() = "bala.png"

	method velocidad() = 10 // Mientras mas bajo el numero, mas rapida la bala

	method actualizar() {
		self.mover()
		if (!tablero.pertenece(self.position())) {
			balasManager.eliminarBala(self)
		}
	}

	method mover()

	method colision(otro) {
		balasManager.notificarColision(self, otro)
	}

	method destruir() {
	}

}

class TiroSimple inherits Bala {

	override method mover() {
		const proxima = arriba.siguiente(self.position())
		self.position(proxima)
	}

}

class Punto {

	var property x
	var property y

}

class TiroTriple inherits Bala {

	const movimiento

	override method mover() {
		const proxima = en.posicion(self.position().x() + movimiento.x(), self.position().y() + movimiento.y())
		self.position(proxima)
	}

}

object balasManager {

	const balas = []

	method agregarTiro(tiro) {
		if (not balas.contains(tiro)) {
			sonidosManager.reproducir(disparo)
			game.addVisual(tiro)
			tickManager.agregarTick(tiro.velocidad(), tiro, { tiro.actualizar()})
			game.onCollideDo(tiro, { other => tiro.colision(other)})
		}
	}

	method actualizar() {
		balas.forEach({ bala => bala.actualizar()})
	}

	method eliminarBala(bala) {
		balas.remove(bala)
		if(game.allVisuals().contains(bala)){
			//A veces intenta eliminar bala que ya había sido eliminada
			//Esto evita que lance excepción y mejora performance
			game.removeVisual(bala)			
			tickManager.eliminarTick(bala)
		}
	}

	method notificarColision(bala, otro) {
		if (not self.esBalaRegistrada(otro)) {
			self.eliminarBala(bala)
			otro.destruir()
		}
	}

	method esBalaRegistrada(colisionable) = balas.any({ bala => bala == colisionable })

	method limpiarBalas() {
		balas.forEach({ bala => self.eliminarBala(bala)})
	}

}

