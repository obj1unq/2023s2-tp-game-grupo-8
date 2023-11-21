import wollok.game.*

object sonidosManager {
	var sonidoAmbiente
	var property modoTest = false
	method reproducir(sonido){
		if (not self.modoTest()){
			game.sound(sonido.nombre()).play()
		}
		
	}
	method reproducirSonidoAmbiente(nombreDelSonido){
		if (not self.modoTest()){	
			sonidoAmbiente = game.sound(nombreDelSonido)
			sonidoAmbiente.volume(0.5)
			sonidoAmbiente.play()
		}
	
	}
	method detenerSonidoAmbiente(){
		if (not self.modoTest()){
			sonidoAmbiente.stop()
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

object explosion inherits Mp3{}

object disparo inherits Mp3 {}

object victoria inherits Ogg {}

object tecla inherits Mp3{}

object derrota inherits Ogg {}