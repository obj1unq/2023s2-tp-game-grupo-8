import qalaga.*
import wollok.game.*
import sonidos.*

class RecuadroArma {

	const property position

	method image() {
		return "recuadroArma.png"
	}
	
	method seleccionar(nave) {
		//necesario para que no rompa
	}

}

object selector {

	var property position = game.at(0, 0)
	const property image = "selector.png"

}

object armaBalistica {
	
	const property position = game.at(0, 0)
	const property image = "armaBalistica.png"
	
	method seleccionar(nave) {
		nave.arma(self)
	}
	

}

object laser {
	
	const property position = game.at(2, 0)
	const property image = "armaBalistica.png"
	
	method seleccionar(nave) {
		nave.arma(self)
	}
	

}

object misil {
	
	const property position = game.at(4, 0)
	const property image = "armaBalistica.png"
	
	method seleccionar(nave) {
		nave.arma(self)
	}
	

}

object armaDeParticulas {
	
	const property position = game.at(6, 0)
	const property image = "armaBalistica.png"
	
	method seleccionar(nave) {
		nave.arma(self)
	}

}

object creadorDeBalas{
	method crear(){
		const bala = new Bala()
		
		if(not game.allVisuals().any({v=> v == bala})) {			
			game.addVisual(bala)		
			encargadoDeSonidos.reproducir("disparo-normal.mp3")
			bala.disparar(barra)
			game.onTick(bala.velocidad(), bala.identity().toString(), {bala.actualizar()})		
			game.onCollideDo(bala, {other=> bala.colision(other)})
		}
	}
}

