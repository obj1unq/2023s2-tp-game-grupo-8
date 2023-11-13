import wollok.game.*

class Animacion {
	method image()
	method iniciar()
	method detener()
}

class AnimacionEnemigo inherits Animacion{
	var frame = 1
	var property position = game.at(1, 1)
	var image = "enemigo-1.png"
	
	override method image(){
		return image
	}
	
	method image(_image){
		image = _image
	}
	
	override method iniciar(){
		game.onTick(200, self.identity().toString(), {self.animar()})
	}
	
	method animar(){
		frame ++
		if(frame > 6){
			frame = 1
		}
		self.image("enemigo-"+frame.toString()+".png")
	}
	
	override method detener(){
		game.removeTickEvent(self.identity().toString())		
	}
}

class Destruccion inherits Animacion{
	override method image(){
		return "esplosion.png"
	}
	
	override method iniciar(){
		
	}
	
	override method detener(){
		
	}	
}

class AnimacionMenuPrincipal inherits Animacion {
	var frame = 1	
	var property position = game.at(0, 0)
	
	var image = "menu-1.png"
	
	override method image(){
		return image
	}
	
	method image(_image){
		image = _image
	}
	
	override method iniciar(){
		game.onTick(100, self.identity().toString(), {self.animar()})
	}
	
	method animar(){
		frame ++
		if(frame > 8){
			frame = 1
		}
		self.image("menu-"+frame.toString()+".png")
	}
	
	override method detener(){
		game.removeTickEvent(self.identity().toString())		
	}
}
