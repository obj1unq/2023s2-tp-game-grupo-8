import wollok.game.*
import qalaga.*
import direcciones.*
import sonidos.*


object flotaNivelUno {
	var property enemigos = []	
	
	method iniciarFlota(){
		self.crearMatrizParaLineas(4).forEach({punto => enemigos.add(self.naveEn(punto))})
		
	}
	
	method encargadoDeMovimientosEnemigos(){
		enemigos.forEach({nave=>nave.actualizar()})
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

object volando{
	method image(){
		return "nave1.png"
	}
}
object destruida{
	method image(){
		return "esplosion.png"
	}
	
}
object nave{
	var property position = game.at(15,5)
	var property direccion = null
	var property estado = volando
	
	method image(){
		return estado.image()
	}
	method destruir(){
		self.estado(destruida)
		//game.schedule(100, game.removeVisual(self))
		
		encargadoDeSonidos.reproducir("esplosion.mp3")
	}
}
class NaveBasica {
	var property position
	var property direccion = derecha
	var property estado = volando
	
	method image(){
		return estado.image()
	}
	
	method actualizar() {		
		self.mover()
	}
	
	method mover() {//velocidad,saco velocidad xq no se para que es, me tiraba error
		if(self.debeGirar()){
			self.bajaAntes()
			direccion = direccion.opuesto()
		}	
		const proxima = direccion.siguiente(self.position())
		self.position(proxima)		
	}
	
	method debeGirar() = self.position().x() >= game.width() - 10 ||
						 self.position().x() <= 10		
						 
	method destruir(){
		self.estado(destruida)
		game.schedule(100, game.removeVisual(self))
		encargadoDeSonidos.reproducir("esplosion.mp3")
	}
	method bajaAntes() {
		const proxima = abajo.siguiente(self.position())
		self.position(proxima)
	}					 				 
		 
}

