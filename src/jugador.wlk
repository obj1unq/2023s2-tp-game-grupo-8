import tablero.*
import wollok.game.*
import direcciones.*
import sonidos.*
import armas.*


object jugador {
	var property position = game.at(20, 1)
	var property arma = armaBalistica     
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
		//estrategiaDeDestruccion.ejecutarDestruccion()
		//class Indestructible
		//const estrategiaPrevia
		//const colisionable 
		//method ejecutar(){NO HACE NADA}
		//method terminar()
		//colisionable.estrategiaDeDestruccion(estrategiaPrevia)
		//object powerUpInvencible
		//method aplicar(jugador) 
		// const indestructible = new Indestructible(colisionable=jugador, estrategiaPrevia=jugador.estrategiaDeDestruccion)
		//jugador.estrategiaDeDestruccion(indestructible)
		//game.schedule(tiempoPowerUp, {indestructible.terminar()} 
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



