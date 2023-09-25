import wollok.game.*
import armas.*
import qalaga.*

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
		game.addVisual(self.crearRecuadro(2,0))
		game.addVisual(self.crearRecuadro(4,0))
		game.addVisual(self.crearRecuadro(6,0))
		
		//Selector
		game.addVisual(selector)
	}
	
	method crearRecuadro(x,y) {
		return new RecuadroArma(position = game.at(x,y))
	}
	
	method seleccionDeArmas() {
		keyboard.num1().onPressDo({selector.position(game.at(0,0))})
		keyboard.num2().onPressDo({selector.position(game.at(2,0))})
		keyboard.num3().onPressDo({selector.position(game.at(4,0))})
		keyboard.num4().onPressDo({selector.position(game.at(6,0))})
	
		game.onCollideDo(selector, {arma => arma.seleccionar(barra)})
	}
	
	method mostrarArmas()  {
		game.addVisual(armaBalistica)
		game.addVisual(laser)
		game.addVisual(misil)
		game.addVisual(armaDeParticulas)
	}
}