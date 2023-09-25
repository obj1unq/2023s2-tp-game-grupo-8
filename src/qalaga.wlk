import tablero.*
import wollok.game.*
import direcciones.*
import sonidos.*
import armas.*


object barra {
	var property position = game.at(20, 1)
	var property arma = armaBalistica
	
	method image(){
		return "barra.png"
	}
	
	method mover(direccion) {
		const proxima = direccion.siguiente(self.position())
		self.position(proxima)
	}
	
	method text() {
		return arma.toString()
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
	
	method mover() {
		const proxima = arriba.siguiente(self.position())
		self.position(proxima)
	}
	
	method colision(otro) {
		otro.destruir()		
		self.remover()
	}
	
	method remover(){
		game.removeVisual(self)
		game.removeTickEvent("Bala")		
	}
}
	

class Punto {
	var property x
	var property y
}


