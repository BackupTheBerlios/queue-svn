indexing
	description: "The state where the user can choose, how fast the ball should fly away"
	author: "Benjamin Sigg"

deferred class
	Q_SHOT_STATE

inherit
	Q_ESCAPABLE_STATE
	redefine
		step
	end
	
feature{Q_SHOT_STATE}
	make is
		do
			create slider.make
			
			slider.set_bounds( 0.1, 0.8, 0.8, 0.1 )

			slider.set_min_max( 0, 1 )
			slider.set_value( 0 )
		end

feature{NONE} -- event-handling
	handle_key( event_ : ESDL_KEYBOARD_EVENT; down_ : BOOLEAN; ressources_ : Q_GAME_RESSOURCES ) is
		do
			if down_ then
				if event_.key = event_.sdlk_plus then
					plus_pressed := true
				elseif event_.key = event_.sdlk_minus then
					minus_pressed := true
				elseif event_.key = event_.sdlk_escape then
					goto_escape_menu( ressources_ )
				elseif next_state = void and event_.key = event_.sdlk_space then
					next_state := prepare_next_state( slider.value, ressources_ )
				end
			else
				if event_.key = event_.sdlk_plus then
					plus_pressed := false
				elseif event_.key = event_.sdlk_minus then
					minus_pressed := false
				end					
			end
		end
		
	plus_pressed, minus_pressed : BOOLEAN
	
	time_for_whole_change : INTEGER is 3000
	
feature -- interface
	install( ressources_: Q_GAME_RESSOURCES ) is
		do
			slider.set_value( slider.minimum )
			ressources_.gl_manager.add_hud( container )
		end
		
	uninstall( ressources_: Q_GAME_RESSOURCES ) is
		do
			ressources_.gl_manager.remove_hud( container )
		end
		
	step( ressources_: Q_GAME_RESSOURCES ) is
		local
			event_queue_ : Q_EVENT_QUEUE
		do
			-- event-handling
			from
				event_queue_ := ressources_.event_queue
			until
				event_queue_.is_empty
			loop
				if event_queue_.is_key_down_event then
					handle_key( event_queue_.pop_keyboard_event, true, ressources_ )
				elseif event_queue_.is_key_up_event then
					handle_key( event_queue_.pop_keyboard_event, false, ressources_ )
				else
					event_queue_.pop
				end
			end
			
			-- increase / decrease value
			if plus_pressed and not minus_pressed then
				slider.set_value( slider.maximum.min( slider.value + (slider.maximum - slider.minimum) / time_for_whole_change * ressources_.time.delta_time_millis ) )
			elseif minus_pressed and not plus_pressed then
				slider.set_value( slider.minimum.max( slider.value - (slider.maximum - slider.minimum) / time_for_whole_change * ressources_.time.delta_time_millis ) )
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
	

	container : Q_HUD_CONTAINER		
	
	slider : Q_HUD_SLIDER
	
feature{NONE}

end -- class Q_SHOOT_STATE
