indexing
	description: "The state where the user can choose, how fast the ball should fly away"
	author: "Benjamin Sigg"

deferred class
	Q_SHOT_STATE

inherit
	Q_ESCAPABLE_STATE
	redefine
		step, default_next_state
	end
	
feature{Q_SHOT_STATE}
	make is
		do
			create slider.make
			
			slider.set_bounds( 0.1, 0.1, 0.8, 0.1 )

			slider.set_min_max( 0, 100 )
			slider.set_value( 0 )
			
			create behaviour.make
			
			to_default_strength
		end
	
	to_default_strength is
		do
			slider.set_value( slider.minimum + 0.25 * (slider.maximum - slider.minimum ))
		end
		
	
feature -- interface
	install( ressources_: Q_GAME_RESSOURCES ) is
		do
			ressources_.gl_manager.add_hud( slider )
			ressources_.gl_manager.set_camera_behaviour( behaviour )
		end
		
	uninstall( ressources_: Q_GAME_RESSOURCES ) is
		do
			ressources_.gl_manager.remove_hud( slider )
			ressources_.gl_manager.set_camera_behaviour( void )
		end
		
	step( ressources_: Q_GAME_RESSOURCES ) is
		local
			key_map_ : Q_KEY_MAP
			
			plus_, minus_ : BOOLEAN
		do			
			-- increase / decrease value
			key_map_ := ressources_.event_queue.key_map
			
			plus_ := key_map_.pressed( key_map_.sdlk_plus ) or
				key_map_.pressed( key_map_.sdlk_pageup )
			
			minus_ := key_map_.pressed( key_map_.sdlk_minus ) or
				key_map_.pressed( key_map_.sdlk_pagedown )			
			
			if plus_ and not minus_ then
				slider.set_value( slider.maximum.min( slider.value + (slider.maximum - slider.minimum) / time_for_whole_change * ressources_.time.delta_time_millis ) )
			elseif minus_ and not plus_ then
				slider.set_value( slider.minimum.max( slider.value - (slider.maximum - slider.minimum) / time_for_whole_change * ressources_.time.delta_time_millis ) )
			end
		end
		
	default_next_state( ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
		do
			result := prepare_next_state( slider.value, ressources_ )
			
			if result /= void then
				to_default_strength
			end
		end
		
		
	prepare_next_state( pressure_ : DOUBLE; ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
			-- Creates the next state. This involvs, saving the pressur.
			-- Returns void, if no next state should be choosen
			-- pressure_ : A value between slider.minimum and slider.maximum (default is 0 and 1).
			-- ressources_ : additional informations
		deferred
		end
		
		
feature{Q_SHOT_STATE}
	slider : Q_HUD_SLIDER
	
feature{NONE} -- values
	behaviour : Q_FREE_CAMERA_BEHAVIOUR
	
	time_for_whole_change : INTEGER is 3000
	
end -- class Q_SHOOT_STATE
