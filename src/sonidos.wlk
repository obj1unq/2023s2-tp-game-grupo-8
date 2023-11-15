import wollok.game.*

object encargadoDeSonidos {
	var sonidoAmbiente
	var property modoTest = false
	method reproducir(nombreDelSonido){
		if (not self.modoTest()){
			
			game.sound(nombreDelSonido).play()
			
		}
		
	}
	
	method reproducirSonidoAmbiente(nombreDelSonido){
		if (not self.modoTest()){	
			sonidoAmbiente = game.sound(nombreDelSonido)
			sonidoAmbiente.play()
		}
		
}
	
	
	method detenerSonidoAmbiente(){
		if (not self.modoTest()){
			sonidoAmbiente.stop()
		}
	}
}
