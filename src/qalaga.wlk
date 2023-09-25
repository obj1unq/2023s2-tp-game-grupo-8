import wollok.game.*
import colisiones.*
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
		//if(tablero.pertenece(proxima)) {
			
			self.position(proxima)		
		//}
		//Por ahora no es un problema
	}
}

object nave1 {
	var property position = game.at(20, 17)
	var property direccion = derecha
	method image(){
		return "nave1.png"
	}
	
	
	method actualizar() {		
		self.mover()
	}
	
	method mover() {
		if(self.debeGirar()){
			direccion = direccion.opuesto()
		}	
		const proxima = direccion.siguiente(self.position())
		self.position(proxima)		
	}
	
	method debeGirar() = self.position().x() >= game.width() - 10 ||
						 self.position().x() <= 10
						 
	method colision(otro){
		
	}						 
}




object tablero {

	method pertenece(position) {
		return position.x().between(0, game.width() - 5) and 
			position.y().between(0, game.height() - 5)
	}
}

object bala {
	var property position
	var property velocidad = 10 //Mientras mas bajo el numero, mas rapida la bala
	
	method image() = "bala.png"
	
	method actualizar() {
		self.mover()
		if(self.position().y() >= game.height() -3){
			game.removeVisual(self)
			game.removeTickEvent("Bala")
			encargadoDeColisiones.colisionables().remove(self)
		}
			
	}
	
	method disparar(elQueDispara) {
		self.position(elQueDispara.position())
		
	}
	
	method mover() {
		const proxima = arriba.siguiente(self.position())
		self.position(proxima)
	}	
	
	method colision(otro) {
		game.removeVisual(otro)
		game.removeTickEvent("Nave1")
		//esto en un futuro habra que modificarlo
		//hacer el msj play polimorfico
		encargadoDeSonidos.reproducir("esplosion.mp3")	
	}
}