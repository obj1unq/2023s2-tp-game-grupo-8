import tablero.*
import wollok.game.*
import direcciones.*
import sonidos.*
import armas.*


object barra {
	var property position = game.at(20, 1)
	var property arma = armaBalistica
	var property cantBalas = 10
	
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
	
	method remover(bala){
//		game.removeVisual(bala)
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


