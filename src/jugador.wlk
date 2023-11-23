import tablero.*
import wollok.game.*
import direcciones.*
import sonidos.*
import armas.*
import escenas.*


object jugador {
	var property position = game.at(20, 1)
	const balasIniciales = 50
	var cantBalas = balasIniciales
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
		creadorDeBala.crear(game.at(self.position().x(), self.position().y() +1))
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
		otro.colision(self)
	}
	
	method perder() {		
		game.schedule(500, {
			sonidosManager.reproducir(derrota)
			escenasManager.cambiarEscenaA(new GameOver())			
		})
	}	
	
	method recargarBalas(){
		cantBalas = balasIniciales
	}
}


class PowerUp {
	method colision(visual){
		visual.colisionConPowerUp(self)
	}
}
