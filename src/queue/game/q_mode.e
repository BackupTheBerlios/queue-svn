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
	description: "Objects that represent a game mode like 8-Ball, 9-Ball, Snooker. This is a factory for specific Q_TABLE, Q_TABLE_MODEL, ... objects"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	Q_MODE

feature -- Interface

	table: Q_TABLE is
			-- creates/returns a table for this game mode
		deferred
		end
		
	table_model: Q_TABLE_MODEL is
			-- creates/returns a 3D-model of the table for this game mode
		deferred
		end
		
	ball_models: ARRAY[Q_BALL_MODEL] is
			-- creates/returns an array of all 3D-models for this game mode
		deferred
		end
	
	ball_to_ball_model (ball_: Q_BALL) : Q_BALL_MODEL is
			-- maps a ball to its ball_model
		deferred
		end
		
	active_player : Q_PLAYER

	ai_player: Q_AI_PLAYER is
			-- create a new AI-Player for this game mode
		deferred
		end
		
	human_player : Q_HUMAN_PLAYER is
			-- create a new human player for this game mode
		deferred
		end
		
		
	position_table_to_world( table_ : Q_VECTOR_2D ) : Q_VECTOR_3D is
		do
			Result := table_model.position_table_to_world (table_)
		end
	
	direction_table_to_world( table_ : Q_VECTOR_2D ) : Q_VECTOR_3D is
		do
			Result := table_model.direction_table_to_world (table_)
		end

	direction_table3d_to_world( table_ : Q_VECTOR_3D ) : Q_VECTOR_3D is
		do
			create result.make( table_.x, table_.y, -table_.z )
		end
		

	position_world_to_table( world_ : Q_VECTOR_3D ) : Q_VECTOR_2D is
		do
			Result := table_model.position_world_to_table (world_)
		end
		
	position_world_to_table3d( world_ : Q_VECTOR_3D ) : Q_VECTOR_3D is
		do
			result := table_model.position_world_to_table3d( world_ )
		end
		
		
	direction_world_to_table( world_ : Q_VECTOR_3D ) : Q_VECTOR_2D is
		do
			Result := table_model.direction_world_to_table (world_)
		end

	next_state(ressources_: Q_GAME_RESSOURCES) : Q_GAME_STATE is
			-- next state according to the ruleset
		deferred
		end
		
		
	identifier : STRING is
		-- A String witch is used as unique identifier for this mode
		-- The string should contain the name of the class, withoud the "q_"
		-- and without a "mode", and only lower-case characters
		-- Example: Q_8BALL_MODE will return "8ball"
		deferred
		ensure
			result_exists : result /= void
		end		
		
	install( ressources_ : Q_GAME_RESSOURCES ) is
		-- Installs this mode. For example, the mode can add
		-- a light to the world
		require
			ressources_ /= void
		deferred
		end
	
	uninstall( ressources_ : Q_GAME_RESSOURCES ) is
		-- Uninstalls this state. For example, if the mode
		-- did add a light to the world, it must now 
		-- remove this light.
		require
			ressources_ /= void
		deferred
		end
		
	valid_position(ball_position_ : Q_VECTOR_2D; ball_ : Q_BALL; sim_:Q_SIMULATION) : BOOLEAN is
			-- true if the given ball-position is valid, otherwise false
		require
			ball_position_ /= void
		deferred
		end	
	
end -- class Q_MODE
