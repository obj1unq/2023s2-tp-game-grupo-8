import wollok.game.*
import pantallas.*
import ticks.*

class Animacion {
	method image()
	method iniciar()
	method detener()
}

class AnimacionEnemigo inherits Animacion{
	var frame = 1
	var property position = en.posicion(1, 1)
	var image = "enemigo-1.png"
	
	override method image(){
		return image
	}
	
	method image(_image){
		image = _image
	}
	
	override method iniciar(){
		tickManager.agregarTick(200, self, {self.animar()})
	}
	
	method animar(){
		frame ++
		if(frame > 6){
			frame = 1
		}
		self.image("enemigo-"+frame.toString()+".png")
	}
	
	override method detener(){
		tickManager.eliminarTick(self)	
	}
}

class Destruccion inherits Animacion{
	override method image(){
		return "explosion.png"
	}
	
	override method iniciar(){
		
	}
	
	override method detener(){
		
	}	
}

class AnimacionMenuPrincipal inherits Animacion {
	var frame = 1	
	var property position = en.posicion(0, 0)
	
	var image = "menu-1.png"
	
	override method image(){
		return image
	}
	
	method image(_image){
		image = _image
	}
	
	override method iniciar(){
		tickManager.agregarTick(100, self, {self.animar()})
	}
	
	method animar(){
		frame ++
		if(frame > 8){
			frame = 1
		}
		self.image("menu-"+frame.toString()+".png")
	}
	
	override method detener(){
		tickManager.eliminarTick(self)	
	}
}
