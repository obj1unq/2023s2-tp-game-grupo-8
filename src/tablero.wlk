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
	
	method seleccionDeArmas() {
		keyboard.num1().onPressDo({selector.position(game.at(0,0))})
		keyboard.num2().onPressDo({selector.position(game.at(1,0))})
		keyboard.num3().onPressDo({selector.position(game.at(2,0))})
		keyboard.num4().onPressDo({selector.position(game.at(3,0))})
	
		game.onCollideDo(selector, {arma => arma.seleccionar(barra)})
	}
	
	method mostrarArmas()  {
		game.addVisual(armaBalistica)
		game.addVisual(laser)
		game.addVisual(misil)
		game.addVisual(armaDeParticulas)
	}
}