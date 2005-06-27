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
	description: "The state where the player can aim, where a ball should be shoot at"
	author: "Benjamin Sigg"

deferred class
	Q_AIM_STATE

inherit
	Q_ESCAPABLE_STATE
	redefine
		step
	end

feature {Q_AIM_STATE}
	make is
		do
			create line.make( 
				create {Q_VECTOR_3D}, create {Q_VECTOR_3D}, 20 )
				
			line.set_color( create {Q_GL_COLOR}.make_white )
		end

feature {Q_AIM_STATE} -- event handling	
	prepare_next_state( direction_ : Q_VECTOR_2D; ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
			-- Prepares the next state. This involves: findig out, if the direction is allowed, and
			-- save the direction somewhere (for example, forward it to the next state).
			-- If, for any reason, no next state is available, return void.
			-- direction_ : Direction in witch the ball will be shot
			-- ressources_ : The game-ressources, for additional informations
		require
			direction_ /= void
		deferred
		end
		
	
		
feature
	install( ressource_ : Q_GAME_RESSOURCES ) is
		local
			vector_ : Q_VECTOR_3D
		do
			if behaviour = void then
				create behaviour.make( ressource_ )
			end

			behaviour.set_ball( ball )
			behaviour.set_zoom_max( ball.radius * 250 )
			behaviour.set_zoom_min( ball.radius * 2 )
			behaviour.set_rotate_vertical_min( -90 )
			behaviour.set_rotate_vertical_max( -2.5 )					
				
			behaviour.calculate_from( ressource_.gl_manager.camera )
				
			ressource_.gl_manager.add_object( line )
			ressource_.gl_manager.set_camera_behaviour( behaviour )
			
			vector_ := ressource_.mode.position_table_to_world( ball.center )
			line.set_a( vector_ )
			line.set_b( create {Q_VECTOR_3D}.make( vector_.x, vector_.y + 20 * ball.radius, vector_.z ) )
		end
		
	uninstall( ressource_ : Q_GAME_RESSOURCES ) is
		do
			ressource_.gl_manager.remove_object( line )
			ressource_.gl_manager.set_camera_behaviour( void )
		end
		
	step( ressource_ : Q_GAME_RESSOURCES ) is
		local
			camera_ : Q_VECTOR_3D
			event_queue_ : Q_EVENT_QUEUE
			key_event_ : ESDL_KEYBOARD_EVENT
		do
			-- camera
			camera_ := ressource_.gl_manager.camera.view_direction_xz_parallel
			direction := ressource_.mode.direction_world_to_table( camera_ )
			
			-- event-handling
			from
				event_queue_ := ressource_.event_queue
			until
				event_queue_.is_empty
			loop
				if event_queue_.is_key_down_event then
					key_event_ := event_queue_.pop_keyboard_event
					
					if key_event_.key = key_event_.sdlk_space then
						if direction /= void then
							set_next_state( prepare_next_state( direction, ressource_ ))
						end
					elseif key_event_.key = key_event_.sdlk_escape then
						goto_escape_menu( ressource_ )
					end
				else
					event_queue_.pop
				end
			end
		end
	
		
feature {Q_AIM_STATE}
	direction : Q_VECTOR_2D
		-- the direction, where the ball should be fired to

	ball : Q_BALL
		-- the ball, witch will be shot

	set_ball( ball_ : Q_BALL ) is
		do
			ball := ball_
			
			if behaviour /= void and ball /= void then
				behaviour.set_ball( ball )				
			end
		end
		
		
feature{NONE} -- internals
	line : Q_GL_BROKEN_LINE
	
	behaviour : Q_BALL_CAMERA_BEHAVIOUR

end -- class Q_AIM_STATE
