import wollok.game.*
import qalaga.*

object derecha {

	method siguiente(position) {
		return position.right(1)
	}
	
	method opuesto() = izquierda
}

object izquierda {

	method siguiente(position) {
		return position.left(1)
	}
	method opuesto() = derecha

}

object arriba {

	method siguiente(position) {
		return position.up(1)
	}

}

object abajo {

	method siguiente(position) {
		return position.down(1)
	}

}