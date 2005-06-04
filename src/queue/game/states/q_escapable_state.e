indexing
	description: "Supreclass for many gamestates witch needs to acces the escape-menu"
	author: "Benjamin Sigg"

deferred class
	Q_ESCAPABLE_STATE

inherit
	Q_GAME_STATE
	
		
feature{Q_DEFAULT_GAME_STATE}

	next_state : Q_GAME_STATE


	step( ressources_ : Q_GAME_RESSOURCES ) is
		local
			event_queue_ : Q_EVENT_QUEUE
			key_event_ : ESDL_KEYBOARD_EVENT
		do
			from
				event_queue_ := ressources_.event_queue
			until
				event_queue_.is_empty
			loop
				if event_queue_.is_key_up_event then
					key_event_ := event_queue_.pop_keyboard_event
					if key_event_.key = key_event_.sdlk_escape then
						goto_escape_menu( ressources_ )
					end
				else
					event_queue_.pop
				end
			end
		end
		
	goto_escape_menu( ressources_ : Q_GAME_RESSOURCES ) is
		local
			escape_ : Q_ESCAPE_STATE
		do
			escape_ ?= ressources_.request_state( "escape" )
			if escape_ = void then
				create escape_.make
				ressources_.put_state( escape_ )
			end
			
			escape_.call_from( current )
			next_state := escape_
		end
	
	next( ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
		do
			result := next_state
			next_state := void
		end

end -- class Q_ESCAPABLE_STATE
