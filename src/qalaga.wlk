import tablero.*
import wollok.game.*
import direcciones.*
import sonidos.*
import armas.*


object barra {
	var property position = game.at(20, 1)
	var property arma = armaBalistica     //TODO borrar
	var property cantBalas = 18
	var property creadorDeBala = creadorDeBalas
  
	method image(){
		return "nave.png"
	}
	
	method mover(direccion) {
		const proxima = direccion.siguiente(self.position())
		self.validarMover(proxima)
		self.position(proxima)
	}
	method validarMover(proxima) {
		if (not tablero.perteneceAlEjeXDelTablero(proxima)){
			self.error("warning,limite de la batalla")
		}
	}
	method disparar() {
		self.validarDisparar()
		//esto se repite
		creadorDeBala.crearDisparoAliada(self)
		cantBalas -= 1
	}
	
	method validarDisparar() {
		if (not self.tieneBalas()) {
			self.error("No tengo mas Balas!!")
		}
	}
	
	method tieneBalas() {
		return cantBalas > 0 
	}
	
	
	
	method text() {
		return cantBalas.toString()
	}
	
	method destruir(){
		
		game.removeVisual(self)//aca quedaria bien un power up de invencible 
	}
	method colision(otro) {
		otro.destruir()		
		self.remover(self)
	}
	
	method remover(_bala){
//		game.removeVisual(_bala)
//		game.removeTickEvent(bala.identity().toString())		
	}
	method destruirPlayer(disparo){
		self.destruir()
		disparo.remover(disparo)
	}
}



class Bala {
	var property position = null
	var property velocidad = 1000//10 //Mientras mas bajo el numero, mas rapida la bala
	
	method image() = "bala.png"
	
	method actualizar() {
		self.mover(self)
		if(self.limiteDelVueloDelDisparo(self)){
			self.remover(self)			
			
		}		
	}
	
	method disparar(elQueDispara) {//este tambien se tiene que modificar
		self.position(game.at(elQueDispara.position().x(), self.orientacionDelQueDispara(elQueDispara)))	
	
	
	}	
	
//	method mover() {
//		const proxima = arriba.siguiente(self.position())
//		self.position(proxima)
//	}
	//quiero testear que la nave colisiona con la bala pero la colion 
		//se modifica con un msj
	method colision(otro) {
//		otro.destruir()		
//		self.remover(self)
		self.comportamientoDeColision(otro)
	}
	
	method remover(bala){
		game.removeVisual(bala)
		game.removeTickEvent(bala.identity().toString())		
	}
	
	method destruir(){
		self.remover(self)
		//esto si choca con otra bala
		//hay que solucionar colision entre balas, si no salta error, esto sucede al disparar dos balas demasiado rapido
	}
//	method comportamientoDeColision(otro) {
//		otro.destruir()		
//		self.remover(self)//este le puedo hacer un override y dejarlo en blanco creo
//	}
	
	method limiteDelVueloDelDisparo(disparo)
	method mover(disparo)
	method comportamientoDeColision(otro)
	method orientacionDelQueDispara(elQueDispara)
	
}
class DisparoAliado inherits Bala {
	override method limiteDelVueloDelDisparo(disparo){
		return tablero.seFuePorArriba(disparo.position())
	}
	override method mover(disparo) {
		const proxima = arriba.siguiente(disparo.position())
		self.position(proxima)
	}
	
	override method comportamientoDeColision(otro) {
		otro.destruir()		
		self.remover(self)//este le puedo hacer un override y dejarlo en blanco creo
	}
	
	override method orientacionDelQueDispara(elQueDispara){
		return elQueDispara.position().y() +1	
	}
}
class DisparoEnemigo inherits Bala {
	override method limiteDelVueloDelDisparo(disparo){
		return tablero.seFuePorAbajo(disparo.position())
	}
	override method mover(disparo) {
		const proxima = abajo.siguiente(disparo.position())
		self.position(proxima)
	}
	override method comportamientoDeColision(otro) {
		otro.destruirPlayer(self)		
	//	self.remover(self)//solo quiero remover si colisiona con la naver
		
	}
	override method orientacionDelQueDispara(elQueDispara){
		return elQueDispara.position().y() -1	
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
			balas.forEach({b=> self.agregarTiro(b)})					
		}
	}
	
	method agregarTiro(tiro){
		game.addVisual(tiro)		
		encargadoDeSonidos.reproducir("disparo-normal.mp3")
		// este comportamiento puede diferenciarse de una nave enemiga o una aliada.
		//
		tiro.disparar(barra)
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
	
	method esBalaRegistrada(colisionable) = balas.any({b=> b == colisionable})
}

