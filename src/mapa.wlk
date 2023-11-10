import wollok.game.*
import enemigos.*
import jugador.*
import armas.*
import direcciones.*
import tablero.*
import animacion.*
import escenas.*

class Mapa{
	
	method celdas()
	
	method generar(){
		(0 .. game.width() - 1).forEach({ x => (0 .. game.height() - 1).forEach({ y => self.generarCelda(x, y)})})
	}
	
	method generarCelda(x, y) {
		const celda = self.celdas().get(y).get(x)
		celda.generar(game.at(x, y))
	}
}

object _ { // Objetos vacios

	method generar(position) {
		//El vacio no agrega nada
	}
		
}

object s { // Score
	
	method generar(position) {
		score.position(position)
		game.addVisual(score)
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
		jugador.position(position)
		game.addVisual(jugador)
	}
	
}



object mapa inherits Mapa {	
	override method celdas() = [
		[_,_,_,_,_,s,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,n,n,n,n,n,n,n,_,_],
		[_,_,_,n,n,n,n,n,_,_,_],
		[_,_,_,_,n,n,n,_,_,_,_],
		[_,_,_,_,_,n,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,b,_,_,_,_,_],		
		[r,r,_,_,_,_,_,_,_,_,_]
	].reverse() //reverse porque el y crece en el orden inverso
	
	
	override method generar() {		
		super()		
		game.addVisual(selector)  // se instancia el selector 
	}	
	
}

object m { // menu
	const background = new AnimacionMenuPrincipal()
	method generar(position) {
		game.addVisual(background)
		background.position(position)
		background.iniciar()
	}
	
	method finalizarMenu(){
		background.detener()
	}
}

object mapaMenu inherits Mapa{
	override method celdas() = [
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,p,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_],		
		[m,_,_,_,_,_,_,_,_,_,_]
	].reverse()
	
	
	override method generar() {
		super()	
		keyboard.enter().onPressDo({
			m.finalizarMenu()
			escenasManager.cambiarEscenaA(nivelUno)
		})
	}
	
}
object gameOver inherits Mapa{
	override method celdas() = [
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,g,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,s,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,p,_,_,_,_,_,_,_],		
		[_,_,_,e,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_]
	].reverse()
	override method generar() {
		super()	
		keyboard.enter().onPressDo({//iniciar de nuevo y un esc para salir del juego
			//m.finalizarMenu()
			escenasManager.cambiarEscenaA(nivelUno)
		})
		keyboard.alt().onPressDo({
			//escenasManager.cambiarEscenaA(nivelUno)
			game.stop()
		})
	}
	
}

object g {
	method generar(position) {
		game.addVisual(gameOverImg)
		gameOverImg.position(position)
	}
}

object e { // esc
	method generar(position) {
		game.addVisual(pressExit)
		pressExit.position(position)
	}	
}
object gameOverImg{
	var property image = "game_Over_logo.png"
	var property position
}

object pressExit {//cambiarle la imagen
	var property image = "press-start.png"
	var property position
}

object pressStart {
	var property image = "press-start.png"
	var property position
}



object p { // menu	
	method generar(position) {
		game.addVisual(pressStart)
		pressStart.position(position)
	}	
}


object ventana {
	const celdas = [
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_]
	]
	
	method iniciar(){
		game.width(celdas.anyOne().size())
		game.height(celdas.size())
		game.cellSize(50)
	}
}

