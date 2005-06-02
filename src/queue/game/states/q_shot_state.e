indexing
	description: "The state where the user can choose, how fast the ball should fly away"
	author: "Benjamin Sigg"

deferred class
	Q_SHOT_STATE

inherit
	Q_GAME_STATE
	
feature{Q_SHOT_STATE}
	make is
		do
			create container.make
			create slider.make
			
			container.set_bounds( 0, 0, 1, 1 )
			slider.set_bounds( 0.1, 0.8, 0.8, 0.1 )

			container.add( slider )
			
			slider.set_min_max( 0, 1 )
			slider.set_value( 0 )
		end

feature
	install( ressources_: Q_GAME_RESSOURCES ) is
		do
			slider.set_value( slider.minimum )
			ressources_.gl_manager.set_hud( container )
		end
		
	uninstall( ressources_: Q_GAME_RESSOURCES ) is
		do
			ressources_.gl_manager.set_hud( void )
		end
		
	step( ressources_: Q_GAME_RESSOURCES ) is
		do
			
		end
		
feature{Q_SHOT_STATE}
	container : Q_HUD_CONTAINER		
	
	slider : Q_HUD_SLIDER
	
feature{NONE}

end -- class Q_SHOOT_STATE
