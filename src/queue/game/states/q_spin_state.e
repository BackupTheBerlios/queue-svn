--
--  queue
--
--  Copyright (C) 2005  
--  Basil Fierz, Severin Hacker, Andreas Kaegi, Benjamin Sigg
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU Library General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
--

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
			create moving_cross.make( 
				create {Q_VECTOR_3D}.default_create,
				create {Q_GL_COLOR}.make_green,
				10 )
				
			create pressed_cross.make( 
				create {Q_VECTOR_3D}.default_create,
				create {Q_GL_COLOR}.make_red,
				10 )				
				
			pressed_set := false
			moving_set := false
		end
		
feature -- interface
	install( ressources_ : Q_GAME_RESSOURCES ) is
		do		
			if behaviour = void then
				create behaviour.make( ressources_ )
				behaviour.set_influence_alpha( false )
				behaviour.set_mouse_ctrl( true )
			end
		
			behaviour.set_ball( ball )
			behaviour.set_zoom_max( ball.radius * 250 )
			behaviour.set_zoom_min( ball.radius * 2 )
			behaviour.set_rotate_vertical_min( -90 )
			behaviour.set_rotate_vertical_max( -2.5 )
			behaviour.calculate_from( ressources_.gl_manager.camera )
			
			ressources_.gl_manager.set_camera_behaviour( behaviour )
			
			set_default_hit( ressources_ )
		end
		
	uninstall( ressources_ : Q_GAME_RESSOURCES ) is
		do
			ressources_.gl_manager.set_camera_behaviour( void )
			
			ressources_.gl_manager.remove_object( pressed_cross )
			ressources_.gl_manager.remove_object( moving_cross )
			
			pressed_set := false
			moving_set := false
		end
	
	step( ressources_ : Q_GAME_RESSOURCES ) is
		local
			event_queue_ : Q_EVENT_QUEUE
			mouse_event_ : ESDL_MOUSEBUTTON_EVENT
			mouse_motion_ : ESDL_MOUSEMOTION_EVENT
		do
			from
				event_queue_ := ressources_.event_queue
			until
				event_queue_.is_empty
			loop
				if event_queue_.is_mouse_motion_event then
					mouse_motion_ := event_queue_.pop_mouse_motion_event
					
					mouse_moved( 
						event_queue_.screen_to_hud( mouse_motion_.x, mouse_motion_.y ),
						ressources_ )
				elseif event_queue_.is_mouse_button_down_event then
					mouse_event_ := event_queue_.pop_mouse_button_event
					
					mouse_pressed(  
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
	mouse_moved( position_ : Q_VECTOR_2D; ressources_ : Q_GAME_RESSOURCES ) is
		local
			point_ : Q_VECTOR_3D
		do
			point_ := hit( position_.x, position_.y, ressources_ )
			if point_ /= void then
				moving_cross.set_position( point_ )
				
				if not moving_set then
					moving_set := true
					ressources_.gl_manager.add_object( moving_cross )
				end
			else
				if moving_set then
					moving_set := false
					ressources_.gl_manager.remove_object( moving_cross )
				end
			end
		end

	mouse_pressed( position_ : Q_VECTOR_2D; ressources_ : Q_GAME_RESSOURCES ) is
		do
			if next_state = void then
				hit_and_save( position_.x, position_.y, ressources_ )
				
				if hit_point /= void then
					pressed_cross.set_position( hit_point )
					
					if not pressed_set then
						pressed_set := true
						ressources_.gl_manager.add_object( pressed_cross )
					end
				else
					if pressed_set then
						pressed_set := false
						ressources_.gl_manager.remove_object( pressed_cross )
					end
				end
			end
		end
		
	key_pressed( event_ : ESDL_KEYBOARD_EVENT; ressources_ : Q_GAME_RESSOURCES ) is
		do
			if next_state = void and hit_point /= void and event_.key = event_.sdlk_space then
				set_next_state( prepare_next( hit_point, ressources_ ))
			elseif event_.key = event_.sdlk_escape then
				goto_escape_menu( ressources_ )
			end
		end
		
		
	prepare_next( hit_point_ : Q_VECTOR_3D; ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
			-- creates or searches the next state. This involves saving the hit-point
			-- and the hit-plane
			-- Returns the next state or void, if no next state could be detemined.
			-- hit_point_ : where the queue hits the ball
			-- ressources_ : additional informations
		require
			hit_point_ /= void
		deferred
		end
		
feature{NONE} -- visualisation
	moving_cross, pressed_cross : Q_GL_CROSS
	moving_set, pressed_set : BOOLEAN
		
feature -- 3d calculation
	hit_point : Q_VECTOR_3D
		-- where the ball is hit. This value is updated whenever the user moves the mouse

	hit( x_, y_ : DOUBLE; ressources_ : Q_GAME_RESSOURCES ) : Q_VECTOR_3D is
			-- calculates where a line through point x/y on the hud hits
			-- the actuall ball
			-- The result is a point in the coordinate-system of the world
		local
			line_ : Q_LINE_3D
			ball_center_ : Q_VECTOR_3D
			ball_plane_ : Q_PLANE
			point_ : Q_VECTOR_3D
			
			distance_ : DOUBLE
		do
			create line_.make_vectorized( 
				ressources_.gl_manager.position_hud_to_world( x_, y_ ),
				ressources_.gl_manager.direction_hud_to_world( x_, y_ ) )
				
			ball_center_ := ressources_.mode.position_table_to_world( ball.center )
			ball_center_.add_xyz( 0, ball.radius, 0 )
			
			create ball_plane_.make_normal( ball_center_, line_.direction )
			
			point_ := ball_plane_.cut( line_ )
			
			result := void	
			if point_ /= void then
				distance_ := ball_center_.distance( point_ )
				
				if distance_ <= ball.radius then
					-- point is inside the ball
					
					distance_ := math.sqrt( ball.radius*ball.radius - distance_*distance_ )
					
					line_.direction.normaliced
					line_.direction.scaled( distance_ )
					
					point_.sub( line_.direction )
					
					if shot_direction /= void then
						create ball_plane_.make_normal( ball_center_, 
							ressources_.mode.direction_table_to_world( shot_direction ))
							
						if not ball_plane_.in_front( point_ ) then
							result := point_
						else
							result := void
						end
					else
						result := point_
					end
				end
			end
		end
		
	hit_and_save( x_, y_ : DOUBLE; ressources_ : Q_GAME_RESSOURCES ) is
		do
			hit_point := hit( x_, y_, ressources_ )
		end
		
	set_default_hit( ressources_ : Q_GAME_RESSOURCES ) is
		local
			center_ : Q_VECTOR_3D
			direction_ : Q_VECTOR_3D
		do
			center_ := ressources_.mode.position_table_to_world( ball.center )
			center_.add_xyz( 0, ball.radius, 0 )
			
			direction_ := ressources_.mode.direction_table_to_world( shot_direction )
			direction_.normaliced
			direction_.scaled( ball.radius )
			
			center_.sub( direction_ )
			
			hit_point := center_
			
			if not pressed_set then
				pressed_set := true
				ressources_.gl_manager.add_object( pressed_cross )
				pressed_cross.set_position( hit_point )
			end
		end
		
		
feature -- values
	behaviour : Q_BALL_CAMERA_BEHAVIOUR
	
	ball : Q_BALL
	
	shot_direction : Q_VECTOR_2D
	
	set_ball( ball_ : Q_BALL ) is
		do
			ball := ball_
			
			if ball /= void then
				moving_cross.set_size( ball.radius / 10 )
				pressed_cross.set_size( ball.radius / 10 )
			end
		end
		
		
	set_shot_direction( direction_ : Q_VECTOR_2D ) is
		do
			shot_direction := direction_
		end
		
feature{NONE} -- math
	math : Q_MATH is
		do
			create result
		end
		
end -- class Q_SPIN_STATE
