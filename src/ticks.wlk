import wollok.game.*

object tickManager {
	const ticks = []
	
	method limpiarTicks(){
		ticks.forEach({tick=> game.removeTickEvent(tick.identity().toString())})
		ticks.clear()
	}
	
	method agregarTick(milisegundos, visual, bloque){
		console.println(ticks.size())
		ticks.add(visual)
		game.onTick(milisegundos, visual.identity().toString(), bloque)
	}

	method eliminarTick(visual){
		const tick = ticks.find({x=> x == visual})
		game.removeTickEvent(tick.identity().toString())
		ticks.remove(tick)
	}
	
}