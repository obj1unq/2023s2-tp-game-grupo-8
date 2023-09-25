import wollok.game.*
import qalaga.*
import direcciones.*
import sonidos.*
import movimientoDeEnemigos.*

object flotaNivelUno {
	var property enemigos = []	
	
	method iniciarFlota(){
		self.crearMatrizParaLineas(4).forEach({punto => enemigos.add(self.naveEn(punto))})
		
	}	
	
	method crearMatrizParaLineas(cantidad) {
		const ancho = 20
		const alto = 12
		const verticalOffset = (game.height() / 2) - alto 
		const horizontalOffset = (game.width() - ancho) / 2		
		const altoLinea = alto / cantidad		
		var alturaDeLinea = 0
		const v1 = new Punto(x = horizontalOffset, y = game.height()- verticalOffset)		
		return (1..cantidad).map({x=> x}).reverse().map({navesPorLinea=>
			const anchoBloque = ancho / navesPorLinea
			const puntos = (0..(navesPorLinea - 1)).map({numeroDeNave=>
				new Punto(x = v1.x() + (anchoBloque * numeroDeNave) + (anchoBloque/2), y = v1.y() - alturaDeLinea)				
			})
			alturaDeLinea += altoLinea
			return puntos
		}).flatten()
	}
	
	method naveEn(punto){
		return new NaveBasica(position = game.at(punto.x(), punto.y()))
	}
	
}


class NaveBasica {
	var property position
	var property direccion = derecha
	method image(){
		return "nave1.png"
	}
	
	method actualizar() {		
		self.mover()
	}
	
	method mover() {//velocidad,saco velocidad xq no se para que es, me tiraba error
		if(self.debeGirar()){
			self.bajaAntes()
			direccion = direccion.opuesto()
		}
		const proxima = direccion.siguiente(self.position())//,velocidad.velocidad
		self.position(proxima)		
	}
	
	method debeGirar() = self.position().x() >= game.width() - 10 ||
						 self.position().x() <= 10		
						 
	method destruir(){
		game.removeVisual(self)
		encargadoDeSonidos.reproducir("esplosion.mp3")
	}
	method bajaAntes() {
		const proxima = abajo.siguiente(self.position())
		self.position(proxima)
	}					 				 
			 
}

