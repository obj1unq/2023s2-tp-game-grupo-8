import qalaga.*
import wollok.game.*

class RecuadroArma {

	const property position

	method image() {
		return "recuadroArma.png"
	}

}

object selector {

	var property position = game.at(0, 0)
	const property image = "selector.png"

}

object armaBalistica {

}

object laser {

}

object misil {

}

object armaDeParticulas {

}

