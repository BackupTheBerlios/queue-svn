indexing
	description: "Allows the user to set the spin of a shot (=where exactely the queue hits the ball)"
	author: "Benjamin Sigg"

deferred class
	Q_SPIN_STATE

inherit
	Q_ESCAPABLE_STATE
	redefine
		step
	end
	
feature{Q_SPIN_STATE}
	make is
		do
		end
		
feature -- interface
	install( ressources_ : Q_GAME_RESSOURCES ) is
		do

		end
		
	uninstall( ressources_ : Q_GAME_RESSOURCES ) is
		do
		end
	
	step( ressources_ : Q_GAME_RESSOURCES ) is
		local
			event_queue_ : Q_EVENT_QUEUE
			mouse_event_ : ESDL_MOUSEBUTTON_EVENT
		do
			from
				event_queue_ := ressources_.event_queue
			until
				event_queue_.is_empty
			loop
				if event_queue_.is_mouse_button_down_event then
					mouse_event_ := event_queue_.pop_mouse_button_event
					
					mouse_pressed( mouse_event_, 
						event_queue_.screen_to_hud( mouse_event_.x, mouse_event_.y ),
						ressources_ )
				elseif event_queue_.is_key_down_event then
					key_pressed( event_queue_.pop_keyboard_event, ressources_ )
				else
					event_queue_.pop
				end
			end
		end
		
feature -- event-handling
	mouse_pressed( event_ : ESDL_MOUSEBUTTON_EVENT; position_ : Q_VECTOR_2D; ressources_ : Q_GAME_RESSOURCES ) is
		do
			if next_state = void then
				hit_and_save( position_.x, position_.y, ressources_ )
			end
		end
		
	key_pressed( event_ : ESDL_KEYBOARD_EVENT; ressources_ : Q_GAME_RESSOURCES ) is
		do
			if next_state = void and hit_point /= void and event_.key = event_.sdlk_space then
				next_state := prepare_next( hit_point, hit_plane )
			elseif event_.key = event_.sdlk_escape then
				goto_escape_menu( ressources_ )
			end
		end
		
		
	prepare_next( hit_point_ : Q_VECTOR_3D; hit_plane_ : Q_PLANE ) : Q_GAME_STATE is
		require
			hit_point_ /= void
			hit_plane_ /= void
		deferred
		end
		
		
feature -- 3d calculation
	hit_point : Q_VECTOR_3D
		-- where the ball is hit. This value is updated whenever the user moves the mouse

	hit_plane : Q_PLANE
		-- the plane in witch the hit_point and the ball_center lies

	hit( x_, y_ : DOUBLE; ressources_ : Q_GAME_RESSOURCES ) : TUPLE[ Q_VECTOR_3D, Q_PLANE ] is
			-- calculates where a line through point x/y on the hud hits
			-- the actuall ball
			-- The result is a point in the coordinate-system of the world
		local
			line_ : Q_LINE_3D
			ball_center : Q_VECTOR_3D
			ball_plane : Q_PLANE
			point_ : Q_VECTOR_3D
		do
			create line_.make_vectorized( 
				ressources_.gl_manager.position_hud_to_world( x_, y_ ),
				ressources_.gl_manager.direction_hud_to_world( x_, y_ ) )
				
			ball_center := ressources_.mode.table_model.position_table_to_world( ball.center )
			ball_center.add_xyz( 0, ball.radius, 0 )
			
			create ball_plane.make_normal( ball_center, line_.direction )
			
			point_ := ball_plane.cut( line_ )
			
			result := void	
			if point_ /= void then
				if point_.diff( ball_center ).length <= ball.radius then
					result := [point_, ball_plane]
				end
			end
		end
		
	hit_and_save( x_, y_ : DOUBLE; ressources_ : Q_GAME_RESSOURCES ) is
		local
			hit_ : TUPLE[ Q_VECTOR_3D, Q_PLANE ]
		do
			hit_ := hit( x_, y_, ressources_ )
			if hit_ /= void then
				hit_point ?= hit_.item( 1 )
				hit_plane ?= hit_.item( 2 )
			else
				hit_point := void
				hit_plane := void
			end
		end
		
feature -- ball
	ball : Q_BALL
	
	set_ball( ball_ : Q_BALL ) is
		do
			ball := ball_
		end
		
	
end -- class Q_SPIN_STATE
