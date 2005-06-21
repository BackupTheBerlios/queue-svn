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
	description: "A mode where the user cannot interact with the system, he can change the camera, but not more"
	author: "Benjamin Sigg"

deferred class
	Q_SIMULATION_STATE

inherit
	Q_ESCAPABLE_STATE

feature{NONE} -- creation
	make is
		do
		end

feature{NONE} -- values
	free_behaviour : Q_FREE_CAMERA_BEHAVIOUR
	ball_behaviour : Q_BALL_CAMERA_BEHAVIOUR

feature
	install( ressources_: Q_GAME_RESSOURCES ) is
		do
			if ressources_.follow_on_shot then
				if ball_behaviour = void then
					create ball_behaviour.make( ressources_ )
				end
				
				ball_behaviour.set_ball( ball )
				ball_behaviour.calculate_from( ressources_.gl_manager.camera )
				ressources_.gl_manager.set_camera_behaviour( ball_behaviour )
			else
				if free_behaviour = void then
					create free_behaviour.make
				end
				
				ressources_.gl_manager.set_camera_behaviour( free_behaviour )
			end
		end
	
	uninstall(ressources_: Q_GAME_RESSOURCES ) is
		do
			ressources_.gl_manager.set_camera_behaviour( void )
		end
	
	step( ressources_ : Q_GAME_RESSOURCES ) is
		local
			balls_ : ARRAY[ Q_BALL_MODEL ]
			ball_  : Q_BALL_MODEL
			index_ : INTEGER
			length_ : DOUBLE
			vector_ : Q_VECTOR_3D
		do
			if next_state = void then
				if not simulation_step( ressources_ ) then
					set_next_state( prepare_next_state( ressources_ ))
				end
			end
	
			-- update ball position and rotation
			balls_ := ressources_.mode.ball_models
			from index_ := balls_.lower	until index_ > balls_.upper loop
				ball_ := balls_.item( index_ )
				vector_ := ressources_.mode.direction_table3d_to_world( ball_.ball.angular_velocity )
				length_ := vector_.length
				if length_ /= 0 then
					vector_.scaled( -1 / length_ )
					ball_.add_rotation( vector_,
						length_ / 1000 * ressources_.time.delta_time_millis )	
				end
				index_ := index_ + 1
			end
		end
		
	
	simulation_step( ressources_ : Q_GAME_RESSOURCES ) : BOOLEAN is
			-- Makes one step of the physics. If the physics has done its job, false is
			-- returns. If the physics is still working, true is returned.
		deferred
		end
		
	prepare_next_state( ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
			-- Is invoked, after the physics has done its job (no ball is moving)
			-- If you don't want to change into a new state, return void.
		deferred
		end
		
feature -- ball
	ball : Q_BALL
	
	set_ball( ball_ : Q_BALL ) is
		do
			ball := ball_
		end
		
		
end -- class Q_SIMULATION_STATE
