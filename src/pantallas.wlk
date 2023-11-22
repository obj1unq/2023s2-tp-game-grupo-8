import wollok.game.*
import enemigos.*
import jugador.*
import armas.*
import direcciones.*
import tablero.*
import animacion.*
import escenas.*
import sonidos.*
import escenas.*
import ticks.*

class Pantalla {

	method celdas()

	method generar() {
		(0 .. game.width() - 1).forEach({ x => (0 .. game.height() - 1).forEach({ y => self.generarCelda(x, y)})})
	}

	method generarCelda(x, y) {
		const celda = self.celdas().get(y).get(x)
		celda.generar(en.posicion(x, y))
	}

}

object _ { // Objetos vacios

	method generar(position) {
	// El vacio no agrega nada
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

	method crearNave(position) {
		return new NaveEnemiga(position = position, agresion = agresionNaves, alColisionarConJugador = { self.finalizarPorDerrota() })
	}

	method finalizarPorDerrota() {
		tickManager.eliminarTick(flotaEnemiga)
		flotaEnemiga.limpiarFlota()
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

	override method celdas() = 
	[ 
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
	].reverse() // reverse porque el y crece en el orden inverso

	override method generar() {
		n.agresionNaves(dificultad)
		super()
		game.addVisual(selector) // se instancia el selector 
		
	}

}

object m { // menu

	const background = new AnimacionMenuPrincipal()

	method generar(position) {
		game.addVisual(background)
		background.position(position)
		background.iniciar()
	}

	method finalizarMenu() {
		background.detener()
	}

}

object pantallaMenu inherits Pantalla {

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

object gameOver inherits Pantalla {

	override method celdas() = 
	[ 
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
		// super()	
		e.generar(en.posicion(3,1))
		p.generar(en.posicion(3,2))
		new MaquinaDeEscribir(altura = 12)
			.primero("GAME OVER")
			.insertarLinea()
			.despues("SCORE")
			.despues(score.puntos().toString())
			.empezar()
			
			
		keyboard.enter().onPressDo({ // iniciar de nuevo y un esc para salir del juego
		// m.finalizarMenu()
			score.resetear()
			escenasManager.presentarOleada()
		})
		keyboard.alt().onPressDo({ // escenasManager.cambiarEscenaA(escenaDeBatalla)
		game.stop()})
	}

}

class PantallaDeOleada inherits Pantalla {

	const property actual

	override method celdas() = 
	[ 
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
		l.proxima(actual)
		new MaquinaDeEscribir(altura= 11)
			.primero("OLEADA "+ actual.toString())
			.empezar()
	}

}

object o {

	method generar(position) {
		game.addVisual(oleada)
		oleada.position(position)
	}

}

object l { //es el nro de la proxima oleada

	var property proxima

	method generar(position) {
		const visualNroDeOleada = new VisualNroDeOleada(oleadaActual = proxima, position = position)
		game.addVisual(visualNroDeOleada)
	}

}

object oleada {

	var property image = "oleada.png"
	var property position

}

class VisualNroDeOleada {

	var property oleadaActual
	var property image = oleadaActual.toString() + ".png"
	var property position

}


object e { // esc

	method generar(position) {
		game.addVisual(pressExit)
		pressExit.position(position)
	}

}


object pressExit { //cambiarle imagen a alt para salir

	var property image = "press-alt.png"
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

	method iniciar() {
		game.width(celdas.anyOne().size())
		game.height(celdas.size())
		game.cellSize(50)
		game.title("Qalaga")
		game.ground("bg.png")
	}
	
	method ancho() = celdas.anyOne().size()
	method alto() = celdas.size()
}

class Linea {
	method siguiente(_siguiente)
	method escribir()
}

class Escritor inherits Linea{
	var siguiente = finDeLinea
	const celdasDisponibles = 11
	const mensaje
	const posicionInicial = (celdasDisponibles - mensaje.length()) / 2
	var posicionActual = posicionInicial
	const altura

	override method escribir() {
		tickManager.agregarTick(100, self, { self.escribirLetra()})
	}

	method escribirLetra() {
		if (mensaje.charAt(self.indiceActual()) != " ") {
			game.addVisual(new Letra(letra = mensaje.charAt(self.indiceActual()), position = en.posicion(posicionActual, altura)))
			sonidosManager.reproducir(tecla)
		}
		posicionActual = posicionActual + 1
		if(self.yaEscribioTodo()){			
			tickManager.eliminarTick(self)
			siguiente.escribir()
		}
		
	}
	
	method indiceActual(){
		return posicionActual-posicionInicial
	}
	
	method yaEscribioTodo(){
		return self.indiceActual() >= mensaje.length()
	}
	
	override method siguiente(_siguiente){
		siguiente = _siguiente
		return _siguiente
	}
}

class Mensaje {

	const property posicion
	const property texto

}

class Letra {

	const letra
	const property position
	const property image = letra + ".png"

}

object finDeLinea inherits Linea{
	override method escribir(){
		
	}
	
	override method siguiente(_siguiente){
		
	}
}

class MaquinaDeEscribir{
	var altura
	var primero = finDeLinea
	var ultimo = finDeLinea
	
	method primero(texto){
		primero = new Escritor(mensaje = texto, altura = altura)
		ultimo = primero
		self.bajarLinea()		
		return self
	}
	
	method despues(texto){
		const proximo = new Escritor(mensaje = texto, altura = altura)
		ultimo.siguiente(proximo)
		ultimo = proximo
		self.bajarLinea()
		return self
	}
	
	method insertarLinea(){
		self.bajarLinea()
		return self
	}
	
	method empezar(){
		primero.escribir()
	}
	
	method bajarLinea(){
		altura = altura -1
	}
	
}

object en {
	
	const posiciones = (-5..ventana.ancho()+5).map({x=> (-5..ventana.alto()+5).map({y=> game.at(x, y)})})
	
	method posicion(x, y) = posiciones.get(x+5).get(y+5)
}

