
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


