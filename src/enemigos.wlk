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
	var property estado = volando

  method image(){
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
	method debeGirar() = self.position().x() >= game.width() - 10 ||
						 self.position().x() <= 10		
						 
	method destruir(){
		self.estado(destruida)
		game.schedule(1000, {game.removeVisual(self)})
		encargadoDeSonidos.reproducir("esplosion.mp3")
	}		 				 
		 
}

object volando{
	method image(){
		return "nave1.png"
	}
}
object destruida{
	method image(){
		return "esplosion.png"
	}
	


