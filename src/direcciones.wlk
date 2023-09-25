import wollok.game.*
import qalaga.*

object derecha {

	method siguiente(position, velocidad) {
		return position.right(velocidad)
	}
	
	method opuesto() = izquierda
}

object izquierda {

	method siguiente(position, velocidad) {
		return position.left(velocidad)
	}
	method opuesto() = derecha

}

object arriba {

	method siguiente(position, velocidad) {
		return position.up(velocidad)
	}

}

object abajo {

	method siguiente(position) {
		return position.down(1)
	}

}