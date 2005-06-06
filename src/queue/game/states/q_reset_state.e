indexing
	description: "A state that allows to set a ball at a position on the table"
	author: "Benjamin Sigg"

deferred class
	Q_RESET_STATE

inherit
	Q_ESCAPABLE_STATE
	redefine
		step
	end

feature{Q_GAME_STATE} -- creation
	make is
		do
		end
		
feature -- interface
	
	step( ressources_: Q_GAME_RESSOURCES ) is
		local
			event_queue_ : Q_EVENT_QUEUE
			motion_event_ : ESDL_MOUSEMOTION_EVENT
			key_event_ : ESDL_KEYBOARD_EVENT
		do
			from
				event_queue_ := ressources_.event_queue
			until
				event_queue_.is_empty
			loop
				if event_queue_.is_mouse_button_down_event then
					--event_queue_.pop_mouse_button_event
					event_queue_.pop
					pressed( ressources_ )
				elseif event_queue_.is_mouse_motion_event then
					motion_event_ := event_queue_.pop_mouse_motion_event
					motion( motion_event_, event_queue_.screen_to_hud( motion_event_.x, motion_event_.y ), ressources_ )
				elseif event_queue_.is_key_down_event  then
					key_event_ := event_queue_.pop_keyboard_event
					if key_event_.key = key_event_.sdlk_space then
						pressed( ressources_ )
					elseif key_event_.key = key_event_.sdlk_escape then
						goto_escape_menu( ressources_ )
					end
				else
					event_queue_.pop
				end
			end
			
			if ball_position /= void then
				ball.set_center( ball_position )
			end
		end
		
feature -- event handling

	motion( event_ : ESDL_MOUSEMOTION_EVENT; position_ : Q_VECTOR_2D; ressources_ : Q_GAME_RESSOURCES ) is
		do
			ball_position := position_of_ball( position_.x, position_.y, ressources_ )
			if not valid_position( ball_position ) then
				ball_position := void
			end
		end
	
	pressed( ressources_ : Q_GAME_RESSOURCES ) is
		do
			if ball_position /= void then
				set_next_state( prepare_next_state( ball_position, ressources_ ))
			end
		end
		
	valid_position( ball_position_ : Q_VECTOR_2D ) : BOOLEAN is
			-- true if the given ball-position is valid, otherwise false
		deferred
		end
		
	prepare_next_state( ball_position_ : Q_VECTOR_2D; ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
			-- Calculates the next state. This means, saving the position of the ball, and
			-- searching/creating a new state.
			-- If no next state is available, return void
			-- ball_position_ : Where the user wants to put the ball
			-- ressources_ : Additional informations
		require
			valid_position( ball_position_ )
		deferred
		end
	
feature -- 3d & table
	position_of_ball( x_, y_ : DOUBLE; ressources_ : Q_GAME_RESSOURCES ) : Q_VECTOR_2D is
			-- calculates, where a point should be set in the table
			-- returns void, if the mouse is not pointing to the table
		require
			a_ball : ball /= void
		local
			line_ : Q_LINE_3D
			plane_ : Q_PLANE
			
			vector_ : Q_VECTOR_3D
		do
			create line_.make_vectorized(
				ressources_.gl_manager.position_hud_to_world( x_, y_ ),
				ressources_.gl_manager.direction_hud_to_world( x_, y_ ))
				
			vector_ := ressources_.mode.direction_table_to_world( create {Q_VECTOR_2D}.make( 0, 0 ) )
			vector_.add_xyz( 0, ball.radius, 0 )
			
			create plane_.make_normal( vector_, create {Q_VECTOR_3D}.make( 0, 1, 0 ))
			
			vector_ := plane_.cut( line_ )
			if vector_ /= void then
				result := ressources_.mode.position_world_to_table( vector_ )
			else
				result := void
			end
		end

feature -- ball
	ball_position : Q_VECTOR_2D

	ball : Q_BALL
	
	set_ball( ball_ : Q_BALL ) is
		do
			ball := ball_
		end
		

end -- class Q_RESET_STATE
