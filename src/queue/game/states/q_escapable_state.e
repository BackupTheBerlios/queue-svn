indexing
	description: "Suprerclass for many gamestates witch needs to acces the escape-menu"
	author: "Benjamin Sigg"

deferred class
	Q_ESCAPABLE_STATE

inherit
	Q_GAME_STATE
	
		
feature{Q_DEFAULT_GAME_STATE}
	goto_escape_menu( ressources_ : Q_GAME_RESSOURCES ) is
			-- Set the next state to the escape-menu
		do
			set_next_state( escape_menu( ressources_ ))
		end
		
	goto_default_next( ressources_ : Q_GAME_RESSOURCES ) is
			-- Sets the next state equal to "default_next_state"
		do
			set_next_state( default_next_state( ressources_ ) )
		end
		

	escape_menu( ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
			-- returns the state witch represents the escape-menu
		local
			escape_ : Q_ESCAPE_STATE
		do
			escape_ ?= ressources_.request_state( "escape" )
			if escape_ = void then
				create escape_.make( true )
				ressources_.put_state( escape_ )
			end
			
			escape_.call_from( current )
			result := escape_
		end
	
	next( ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
			-- searches the next state.
			-- this will be: "next_state", if set,
			-- the escape-menu if "ESC" was pressed, or
			-- the "default_next_state" if "SPACE" was pressed
		local
			event_queue_ : Q_EVENT_QUEUE
			key_event_ : ESDL_KEYBOARD_EVENT
		do
			result := next_state
			next_state := void
			
			from
				event_queue_ := ressources_.event_queue
			until
				event_queue_.is_empty or result /= void
			loop
				if event_queue_.is_key_down_event then
					key_event_ := event_queue_.pop_keyboard_event
					if key_event_.key = key_event_.sdlk_escape then
						result := escape_menu( ressources_ )
					elseif key_event_.key = key_event_.sdlk_space then
						result := default_next_state( ressources_ )
					end
				else
					event_queue_.pop
				end
			end
		end
	

	default_next_state( ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
			-- Called if the user presses the standard-key for "next-state".
			-- If no next state is available, return void
		do
			result := void
		end

	set_next_state( state_ : Q_GAME_STATE ) is
			-- Sets the next state that should follow after this state.
			-- The new next-state will be returnd by the next call of "next", 
			-- and it will also be deleted at this time.
			-- Set void, if you don't want to go in a next state
		do
			next_state := state_
		end
		
	
feature{NONE}
	next_state : Q_GAME_STATE
		-- The next state that follows after this state. This will be returned
		-- by the next call of "next".

end -- class Q_ESCAPABLE_STATE
