import wollok.game.*

class Direccion {
	method siguiente(position)
	method opuesto()
}


object derecha inherits Direccion {

	override method siguiente(position) {
		return position.right(1)
	}
	
	override method opuesto() = izquierda
}

object izquierda inherits Direccion {

	override method siguiente(position) {
		return position.left(1)
	}
	override method opuesto() = derecha

}

object arriba inherits Direccion{

	override method siguiente(position) {
		return position.up(1)
	}
	override method opuesto() = abajo
}

object abajo inherits Direccion{

	override method siguiente(position) {
		return position.down(1)
	}
	override method opuesto()= arriba
}