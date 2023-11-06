import wollok.game.*
import mapa.*
import sonidos.*
import direcciones.*
import tablero.*
import jugador.*

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
	
	method inicializar() {
		self.activarBalaSimple()
		keyboard.num1().onPressDo({
			self.activarBalaSimple()
		})
		keyboard.num2().onPressDo({
			self.activarTiroTriple()
		})
		keyboard.num3().onPressDo({self.position(recuadrosPosition.get(2))})
		keyboard.num4().onPressDo({self.position(recuadrosPosition.get(3))})
		
		game.onCollideDo(self, {arma => arma.seleccionar(jugador)})
	}
	
	method activarBalaSimple(){
		self.position(recuadrosPosition.get(0))
		jugador.creadorDeBala(creadorDeBalas)
	}
	
	method activarTiroTriple(){
		self.position(recuadrosPosition.get(1))
		jugador.creadorDeBala(creadorDeTiroTriple)
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
			bala.disparar(jugador)
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


class Bala {
	var property position = null
	var property velocidad = 10 //Mientras mas bajo el numero, mas rapida la bala
	
	method image() = "bala.png"
	
	method actualizar() {
		self.mover()
		if(tablero.seFuePorArriba(self.position())){
			self.remover(self)			
		}		
	}
	
	method disparar(elQueDispara) {
		self.position(game.at(elQueDispara.position().x(), elQueDispara.position().y() +1)) 
	}	
	
	method mover() {
		const proxima = arriba.siguiente(self.position())
		self.position(proxima)
	}
	//quiero testear que la nave colisiona con la bala pero la colion 
		//se modifica con un msj
	method colision(otro) {
		otro.destruir()		
		self.remover(self)
	}
	
	method remover(bala){
		game.removeVisual(bala)
		game.removeTickEvent(bala.identity().toString())		
	}
	
	method destruir(){
		//hay que solucionar colision entre balas, si no salta error, esto sucede al disparar dos balas demasiado rapido
	}
}
	

class Punto {
	var property x
	var property y
}


class TiroTriple {
	var property position = null
	var property velocidad = 100
	var property movimiento
	
	method image() = "bala.png"
	
	method actualizar() {
		self.mover()
		if(not tablero.pertenece(self.position())){
			balasManager.eliminarBala(self)		
		}		
	}
	
	method disparar(elQueDispara) {
		self.position(game.at(elQueDispara.position().x(), elQueDispara.position().y() +1)) 
	}	
	
	method mover() {
		const proxima = game.at(self.position().x() + movimiento.x(), self.position().y() + movimiento.y())		
		self.position(proxima)
	}

	method colision(otro) {
		balasManager.notificarColision(self, otro)
	}
	
	method remover(){
		game.removeVisual(self)
		game.removeTickEvent(self.identity().toString())		
	}	
	
	method destruir(){
		//hay que solucionar colision entre balas, si no salta error, esto sucede al disparar dos balas demasiado rapido
	}
}

object balasManager {
	var balas = []
	
	method registrarBalas(_balas){
		if(balas.size() == 0){
			balas = _balas
			balas.forEach({bala=> self.agregarTiro(bala)})					
		}
	}
	
	method agregarTiro(tiro){
		game.addVisual(tiro)		
		encargadoDeSonidos.reproducir("disparo-normal.mp3")
		tiro.disparar(jugador)
		game.onTick(tiro.velocidad(), tiro.identity().toString(), {tiro.actualizar()})		
		game.onCollideDo(tiro, {other=> tiro.colision(other)})
	}
	
	method actualizar(){
		balas.forEach({bala=> bala.actualizar()})
	}
	
	method eliminarBala(bala){
		balas.remove(bala)
		bala.destruir()
	}
	
	method notificarColision(bala, colisionable){
		if(not self.esBalaRegistrada(colisionable)){
			self.eliminarBala(bala)
			colisionable.destruir()
		}
	}
	
	method esBalaRegistrada(colisionable) = balas.any({bala=> bala == colisionable})
}
