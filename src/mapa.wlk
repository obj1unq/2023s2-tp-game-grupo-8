import wollok.game.*
import enemigos.*
import qalaga.*
import armas.*

object score{
	const property position = game.at(4,game.height()-1)
	var puntos = 100
	
	method text(){
		return "score:"+puntos.toString()+""
	}
	
}
object _ { // Objetos vacios

	method generar(position) {
		//El vacio no agrega nada
	}
		
}

object n { // Naves enemigas
	
	method generar(position) {
		const enemigo = new NaveBasica(position = position)
		game.addVisual(enemigo)
		flotaNivelUno.agregar(enemigo)
	}
		
}

object r { // Selector de armas

	method generar(position) {
		game.addVisual(new RecuadroArma(position = position))
		selector.agregarRecuadro(position)
	}
	
}

object b { // Nave principal

	method generar(position) {
		barra.position(position)
		game.addVisual(barra)
	}
	
}

object mapa {

	var celdas = [
		[_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_],
		[_,_,n,n,n,n,n,n,_,_],
		[_,_,_,n,n,n,n,_,_,_],
		[_,_,_,_,n,n,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,b,_,_,_,_,_],		
		[r,r,r,r,_,_,_,_,_,_]		
	].reverse() //reverse porque el y crece en el orden inverso
	
	method generar() {
		game.width(celdas.anyOne().size())
		game.height(celdas.size())
		game.cellSize(50)
		(0 .. game.width() - 1).forEach({ x => (0 .. game.height() - 1).forEach({ y => self.generarCelda(x, y)})})
		
		game.addVisual(selector)  // se instancia el selector 
	}

	method generarCelda(x, y) {
		const celda = celdas.get(y).get(x)
		celda.generar(game.at(x, y))
	}

}
