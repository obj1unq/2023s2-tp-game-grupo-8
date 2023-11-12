import tablero.*
import wollok.game.*
import direcciones.*
import sonidos.*
import armas.*
import escenas.*


object jugador {
	var property position = game.at(20, 1)
	var property cantBalas = 50
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
		game.removeVisual(self) 
	}
	
	method colision(otro) {
		otro.destruir()
	}
	
	method perder() {
		escenasManager.cambiarEscenaA(new GameOver())
	}	
}



