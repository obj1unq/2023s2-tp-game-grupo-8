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
	

}

object selector {

	var property position = game.at(0, 0)
	const property image = "selector.png"
	
	const property recuadrosPosition  = []
	
	method agregarRecuadro(_position) {
		recuadrosPosition.add(_position)
	}
	
	method inicializar() {
		self.aniadirVisuales()
		self.activarBala(creadorDeBalas)
		keyboard.num1().onPressDo({
			self.activarBala(creadorDeBalas)
		})
		keyboard.num2().onPressDo({
			self.activarBala(creadorDeTiroTriple)
		})
		
	}
	
	method aniadirVisuales() {
		self.aniadirCreadorBala(creadorDeBalas)
		self.aniadirCreadorBala(creadorDeTiroTriple)
	}
	
	method aniadirCreadorBala(creador) {
		creador.position(self.positionPara(creador))
		game.addVisual(creador)
	}
	
	
	method activarBala(creador){
		self.position(self.positionPara(creador))
		jugador.creadorDeBala(creador)
	}
	
	method positionPara(creador) {
		return recuadrosPosition.get(creador.indice())
	}
	
	
}

class CreadorDeBala {
	var property position = null
	
	method crear()
	
	method image() {
		return ".png"
	}
	
	method indice()
}

object creadorDeBalas inherits CreadorDeBala {
	
	override method crear(){
		const bala = new Bala()
		
		if(not game.allVisuals().any({v=> v == bala})) {			
			game.addVisual(bala)		
			encargadoDeSonidos.reproducir("disparo-normal.mp3")
			bala.disparar(jugador)
			game.onTick(bala.velocidad(), bala.identity().toString(), {bala.actualizar()})		
			game.onCollideDo(bala, {other=> bala.colision(other)})
		}
	}
	
	override method image() {
		return "bala" + super()
	}
	
	override method indice(){
		return 0
	}
	
}

object creadorDeTiroTriple inherits CreadorDeBala{
	override method crear(){
		var vectores = [			
			new Punto(x= 1, y = 1),
			new Punto(x= 0, y = 1),			
			new Punto(x= -1, y = 1)
		]
		var balas = vectores.map({vector=> new TiroTriple(movimiento = vector)})
		balasManager.registrarBalas(balas)		
	}
	
	override method image() {
		return "bala_triple" + super()
	}
	
	override method indice(){
		return 1
	}	
}


class Bala {
	var property position = null
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
	//quiero testear que la nave colisiona con la bala pero la colion 
		//se modifica con un msj
	method colision(otro) {
		otro.destruir()		
		self.remover()
	}
	
	method remover(){
		game.removeVisual(self)
		game.removeTickEvent(self.identity().toString())		
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
