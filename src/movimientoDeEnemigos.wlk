import enemigos.*
import sonidos.*
import direcciones.*
import qalaga.*//


object encargadoDeMovimientoEnemigo {
	
	
	method mover(enemigos){
		enemigos.forEach({nave=>nave.actualizar()})
	}
	
}
