import tablero.*
import wollok.game.*
import direcciones.*
import sonidos.*
import armas.*
import escenas.*
import pantallas.*
import ticks.*


object jugador {
	var property position = en.posicion(0, 0)
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
		creadorDeBala.crear(en.posicion(self.position().x(), self.position().y() +1))
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
	
	method colision(otro) {	}
	
	method perder() {		
		score.resetear()
		escenasManager.presentarOleada()
//		sonidosManager.reproducir(derrota)
//		game.schedule(500, {
//			escenasManager.cambiarEscenaA(new GameOver())			
//		})
	}	
	
	method recargarBalas(){
		cantBalas = balasIniciales
	}
}



