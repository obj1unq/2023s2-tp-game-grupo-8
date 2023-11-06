import wollok.game.*

object encargadoDeSonidos {
	
	var property modoTest = false
	method reproducir(nombreDelSonido){
		if (not self.modoTest()){
			game.sound(nombreDelSonido).play()
		}
		
	}
}
