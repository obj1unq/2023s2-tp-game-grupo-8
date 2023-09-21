import wollok.game.*
import colisiones.*
import wollok.game.*
import direcciones.*
object barra {
	var property position = game.at(20, 1)
	
	method image(){
		return "barra.png"
	}
	
	method mover(direccion) {
		const proxima = direccion.siguiente(self.position(), 3)
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
		self.mover(1)
	}
	
	method mover(velocidad) {
		if(self.debeGirar()){
			direccion = direccion.opuesto()
		}	
		const proxima = direccion.siguiente(self.position(), velocidad)
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
	
	method image() = "bala.png"
	
	method actualizar() {
		self.mover(8)
		if(self.position().y() >= game.height() -3){
			game.removeVisual(self)
			game.removeTickEvent("Bala")
			encargadoDeColisiones.colisionables().remove(self)
		}
	}
	
	method disparar(elQueDispara) {
		self.position(elQueDispara.position())
	}
	
	method mover(velocidad) {
		const proxima = arriba.siguiente(self.position(), velocidad)
		self.position(proxima)
	}	
	
	method colision(otro) {
		game.removeVisual(otro)
		game.removeTickEvent("Nave1")
	}
}