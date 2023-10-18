import qalaga.*
import wollok.game.*

import mapa.*

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
	
	const property recuadrosPosition  = []
	
	method agregarRecuadro(_position) {
		recuadrosPosition.add(_position)
	}
	
	method armas() {
		keyboard.num1().onPressDo({
			self.position(recuadrosPosition.get(0))
			barra.creadorDeBala(creadorDeBalas)
		})
		keyboard.num2().onPressDo({
			self.position(recuadrosPosition.get(1))
			barra.creadorDeBala(creadorDeTiroTriple)
		})
		keyboard.num3().onPressDo({self.position(recuadrosPosition.get(2))})
		keyboard.num4().onPressDo({self.position(recuadrosPosition.get(3))})
	
		game.onCollideDo(self, {arma => arma.seleccionar(barra)})
	}

}

object armas {
	method mostrar()  {
		game.addVisual(armaBalistica)
		game.addVisual(laser)
		game.addVisual(misil)
		game.addVisual(armaDeParticulas)
	}
}

object armaBalistica {
	
	const property position = game.at(0, 0)
	const property image = "armaBalistica.png"
	
	method seleccionar(nave) {
		nave.arma(self)
	}
	

}

object laser {
	
	const property position = game.at(1, 0)
	const property image = "armaBalistica.png"
	
	method seleccionar(nave) {
		nave.arma(self)
	}
	

}

object misil {
	
	const property position = game.at(2, 0)
	const property image = "armaBalistica.png"
	
	method seleccionar(nave) {
		nave.arma(self)
	}
	

}

object armaDeParticulas {
	
	const property position = game.at(3, 0)
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

object creadorDeTiroTriple{
	method crear(){
		var vectores = [
			new Punto(x= 0.5, y = 1),
			new Punto(x= 1, y = 1),
			new Punto(x= 0, y = 1),
			new Punto(x= -0.5, y = 1),
			new Punto(x= -1, y = 1)
		]
		var balas = vectores.map({vector=> new TiroTriple(movimiento = vector)})
		balasManager.registrarBalas(balas)		
	}		
}
