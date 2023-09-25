import wollok.game.*
import colisiones.*
import wollok.game.*
import direcciones.*
import sonidos.*
import armas.*


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
	
	method mostrarSelector() {
		//Recuadro selector
		game.addVisual(self.crearRecuadro(0,0))
		game.addVisual(self.crearRecuadro(0,2))
		game.addVisual(self.crearRecuadro(0,4))
		game.addVisual(self.crearRecuadro(2,0))
		game.addVisual(self.crearRecuadro(2,2))
		game.addVisual(self.crearRecuadro(2,4))
		
		//Selector
		game.addVisual(selector)
	}
	
	method crearRecuadro(x,y) {
		return new RecuadroArma(position = game.at(x,y))
	}
	
	method seleccionDeArmas() {
		keyboard.num1().onPressDo({selector.position(game.at(0,0))})
		keyboard.num2().onPressDo({selector.position(game.at(0,2))})
		keyboard.num3().onPressDo({selector.position(game.at(0,4))})
		keyboard.num4().onPressDo({selector.position(game.at(2,0))})
		keyboard.num5().onPressDo({selector.position(game.at(2,2))})
		keyboard.num6().onPressDo({selector.position(game.at(2,4))})
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