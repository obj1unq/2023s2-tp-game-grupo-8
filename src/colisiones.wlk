object encargadoDeColisiones {
	var property colisionables = []
	
	method verificarColisiones() {
		colisionables.forEach({colisionable=> self.verificarColisionesPara(colisionable)})
	}	
	
	method verificarColisionesPara(colisionable) {
		colisionables.forEach({otro=> self.verificarColisionEntre(colisionable, otro)})
	}
	
	method verificarColisionEntre(colisionable, otro) {
		if(not self.esElMismoColisionable(colisionable, otro) &&
			self.hayColision(colisionable, otro)
		) {
			otro.colision(colisionable)
		}
	}
	
	method esElMismoColisionable(colisionable, otro) = colisionable == otro
	
	method hayColision(colisionable, otro) {		
		return (colisionable.position().x() - otro.position().x()).abs() < 10 &&
				(colisionable.position().y() - otro.position().y()).abs() < 10
	}
}
