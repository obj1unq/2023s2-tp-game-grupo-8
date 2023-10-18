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
		creadorDeBala.crear()
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
			balas.forEach({b=> self.agregarTiro(b)})					
		}
	}
	
	method agregarTiro(tiro){
		game.addVisual(tiro)		
		encargadoDeSonidos.reproducir("disparo-normal.mp3")
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

