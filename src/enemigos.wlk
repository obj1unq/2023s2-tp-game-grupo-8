import wollok.game.*
import jugador.*
import tablero.*
import animacion.*
import direcciones.*
import sonidos.*
import pantallas.*
import animacion.*
import estadosDestruccion.*

object flotaEnemiga {

	const property enemigos = []
	var alMorir
	

	method agregar(enemigo) {
		enemigos.add(enemigo)
		enemigo.animacion().iniciar()
	}
	
	method ejecutarAlMorir(bloque){
		
		alMorir = bloque
	}

	method mover() {
		enemigos.forEach({ nave => nave.mover()})
	}

	method remover(enemigo) {
		enemigos.remove(enemigo)
		self.chequearFlota()
	}
	
	method chequearFlota(){
		if(self.estaMuerta()){
			self.limpiarFlota()
			alMorir.apply()
		}
	}
	
	method limpiarFlota(){
		enemigos.clear()
	}
	
	method estaMuerta() {
		return enemigos.isEmpty()
	}
	
}

class NaveEnemiga {
	const objetivo = jugador
	const agresion
	var property position
	var property direccion = derecha	
	var property animacion = new AnimacionEnemigo()
	var property estadoDestruccion = new PuedeSerDestruida()
	

	method image() {
		return animacion.image()
	}

	method mover() {
		var proxima = direccion.siguiente(self.position())
		if (self.debeGirar(proxima)) {			
			direccion = direccion.opuesto()
			proxima = self.bajar(proxima)
		}
		self.position(proxima)
		
		if(self.debajoDeObjetivo()) {
			self.destruirObjetivo()
		}
	}
	
	method debajoDeObjetivo()  {
		return self.position().y() < objetivo.position().y() and self.position().x() == objetivo.position().x()
	}

	method debeGirar(_position) {
		return not self.puedeIr(_position)
	}

	method puedeIr(_position) {
		return tablero.pertenece(_position)
	}

	method bajar(_position) {
		return _position.down(agresion)
	}

	method debeGirar() = self.position().x() >= game.width() - 10 || self.position().x() <= 10

	method colision(algo) { 
		//Solo destruye al objetivo
		if(algo == objetivo){
			self.destruirObjetivo()
		}
	}

	method destruir() {
		estadoDestruccion.ejecutar(self)
	}	
	
	method animarDestruccion(){
		animacion.detener()
		animacion = new Destruccion()
		animacion.iniciar()
	}
	
	method destruirObjetivo() {
		sonidosManager.detenerSonidoAmbiente()	
		n.finalizarPorDerrota()
		objetivo.destruir()
		objetivo.perder()
	}
}
