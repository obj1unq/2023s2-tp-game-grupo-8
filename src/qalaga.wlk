import wollok.game.*
import wollok.game.*
import direcciones.*
import sonidos.*


object barra {
	var property position = game.at(20, 1)
	
	method image(){
		return "barra.png"
	}
	
	method mover(direccion) {
		const proxima = direccion.siguiente(self.position())
		self.position(proxima)
	}		
}

object tablero {

	method pertenece(position) {
		return position.x().between(0, game.width() - 5) and 
			position.y().between(0, game.height() - 5)
	}
	
	method seFuePorArriba(position){
		return position.y() > game.height()
	}
}

object bala {
	var property position
	var property velocidad = 10 //Mientras mas bajo el numero, mas rapida la bala
	
	method image() = "bala.png"
	
	method actualizar() {
		self.mover()
		if(tablero.seFuePorArriba(self.position())){
			self.remover()			
		}
			
	}
	
	method disparar(elQueDispara) {
		self.position(game.at(elQueDispara.position().x(), elQueDispara.position().y() +1))
		
	}
	
	
	
	method mover(velocidad) {
		const proxima = arriba.siguiente(self.position(), velocidad)
		self.position(proxima)
	}	
	
	method colision(otro) {
		game.removeVisual(otro)
		self.remover()
	}
}

class Punto {
	var property x
	var property y
}
