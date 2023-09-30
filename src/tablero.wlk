import wollok.game.*
import armas.*
import qalaga.*

object tablero {

	method pertenece(position) {
		return position.x().between(0, game.width() - 1) and 
			position.y().between(0, game.height() - 1)
	}
	
	method seFuePorArriba(position){
		return position.y() > game.height()
	}
	
}