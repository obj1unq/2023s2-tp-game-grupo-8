import wollok.game.*

class Animacion {
	var frame = 1
	
	var property image = self.actual()
	
	method frames()
	method tick()
	method imagen()
	
	method iniciar(){
		game.onTick(self.tick(), self.identity().toString(), {self.animar()})
	}
	
	method animar(){
		frame ++
		if(frame > self.frames()){
			frame = 1
		}
		self.image(self.actual())
	}	
	
	method actual() = self.imagen()+"-"+frame.toString()+".png"
	
	 method detener(){
		game.removeTickEvent(self.identity().toString())		
	}
}

class AnimacionEnemigo inherits Animacion{
	
	var property position = game.at(1, 1)
	
	override method image(){
		return image
	}
	override method frames () = 6
	override method imagen() = "enemigo"
	
	override method tick() = 200
}

class Destruccion inherits Animacion{
	override method image(){
		return "explosion.png"
	}
	
	override method iniciar(){
		
	}
	
	override method detener(){
		
	}	
	
	override method imagen() = "explosion.png"
	override method tick() = 0
	override method frames() = 0
}

class AnimacionMenuPrincipal inherits Animacion {
		
	var property position = game.at(0, 0)
	
	
	override method imagen() = "menu"
	
	
	override method tick()=100
	
	override method frames() = 8
	
}
