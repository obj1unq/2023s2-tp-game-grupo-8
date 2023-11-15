import wollok.game.*
import enemigos.*
import jugador.*
import armas.*
import direcciones.*
import tablero.*
import animacion.*
import escenas.*
import escenas.*
import escenas.*

class Pantalla{
	
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
	var property agresionNaves = 0
	method generar(position) {
		const enemigo = self.crearNave(position)
		game.addVisual(enemigo)
		flotaEnemiga.agregar(enemigo)
	}
	
	method crearNave(position){
		return new NaveEnemiga(position = position, 
			agresion = agresionNaves, 
			alColisionarConJugador = {self.finalizarPorDerrota()}
		)
	}	
	
	method finalizarPorDerrota(){
		game.removeTickEvent(flotaEnemiga.identity().toString())
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



class PantallaDeBatalla inherits Pantalla {	
	const dificultad
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
		n.agresionNaves(dificultad)	
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

object pantallaMenu inherits Pantalla{
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
}

object gameOver inherits Pantalla{
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
		[_,_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_]
	].reverse()
	override method generar() {
		//super()	
		
		escritor.lineaPara(new Mensaje(posicion = 12, texto = "GAME OVER"))
		escritor.lineaPara(new Mensaje(posicion = 10, texto = "SCORE"))
		escritor.lineaPara(new Mensaje(posicion = 9, texto = score.puntos().toString()))
		keyboard.enter().onPressDo({//iniciar de nuevo y un esc para salir del juego
			//m.finalizarMenu()
			score.resetear()
			escenasManager.presentarOleada()
		})
		keyboard.alt().onPressDo({
			//escenasManager.cambiarEscenaA(escenaDeBatalla)
			game.stop()
		})
	}
	
}
class PantallaDeOleada inherits Pantalla{
	const property actual 
	override method celdas() = [
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,o,_,_,_,_,l,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],
		[_,_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_],		
		[_,_,_,_,_,_,_,_,_,_,_]
	].reverse()
	override method generar() {
		l.proxima(actual)
		super()	
		
	}
}
object o {
	method generar(position) {
		game.addVisual(oleada)
		oleada.position(position)
	}
}
object l{//es el nro de la proxima oleada
	
	var property proxima
	method generar(position) {
		const visualNroDeOleada = new VisualNroDeOleada(oleadaActual=proxima,position=position)
		game.addVisual(visualNroDeOleada)
	}
}
object oleada {
	var property image = "oleada.png"
	var property position
}

class VisualNroDeOleada{
	var property oleadaActual
	var property image = oleadaActual.toString()+".png"
	var property position
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

object pressExit {//cambiarle imagen a alt para salir
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
		game.ground("bg.png")
	}
}

object escritor{
	const celdasDisponibles = 11
	method lineaPara(mensaje){
		const y = mensaje.posicion()
		var x = (celdasDisponibles - mensaje.texto().length()) / 2 
		(0..(mensaje.texto().length() -1)).forEach({
			index=> 
				if(mensaje.texto().charAt(index) != " "){
					game.addVisual(new Letra(letra = mensaje.texto().charAt(index), position =  game.at(x, y)))					
				}				
				x = x +1
		})
		//(0..mensaje.texto().length()-1)).map({index => mensaje.texto().c})
		
		//.forEach({index=> game.addVisual(new Letra(letra= mensaje.texto().charAt(index), position =  game.at(x, y)))})
	}
}

class Mensaje{
	const property posicion
	const property texto
}

class Letra{
	const letra
	const property position
	const property image = letra + ".png"	
}
