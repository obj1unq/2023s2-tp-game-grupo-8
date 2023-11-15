import wollok.game.*

object sonidosManager {
	
	var property modoTest = false
	method reproducir(sonido){
		if (not self.modoTest()){
			game.sound(sonido.nombre()).play()
		}
		
	}
}

class Sonido{
	method nombre(){
		return self.toString() + self.extension()
	}
	
	method extension()
	
}

class Mp3 inherits Sonido{
	override method extension() = ".mp3"
}

class Ogg inherits Sonido{
	override method extension() = ".ogg"
}

object esplosion inherits Mp3{}

object disparo inherits Mp3 {}

object victoria inherits Ogg {}

object derrota inherits Ogg {}