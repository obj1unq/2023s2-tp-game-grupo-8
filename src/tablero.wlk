import wollok.game.*
object tablero {

	method pertenece(position) {
		return self.perteneceAlEjeXDelTablero(position) and 
			self.perteneceAlEjeYDelTablero(position)
	}
	method perteneceAlEjeXDelTablero(position) {
		return position.x().between(0, game.width() - 1)
	}
	method perteneceAlEjeYDelTablero(position) {
		return position.y().between(0, game.height() - 1)
	}
	
	method seFuePorArriba(position){
		return position.y() > game.height()
	}
		
}

object score{
	var property position
	var property puntos = 0 //1200
	
	method text(){
		return "score:" + puntos.toString()+""
	}
	
	method aumentarPuntos(){
		puntos += 100
	}
	
	method destruir(){
		
	}

}
