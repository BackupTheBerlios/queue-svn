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
		
		
	ai_player: Q_AI_PLAYER is
			-- creates/returns an AI-Player for this game mode
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
		
	position_world_to_table( world_ : Q_VECTOR_3D ) : Q_VECTOR_2D is
		do
			Result := table_model.position_world_to_table (world_)
		end
		
	direction_world_to_table( world_ : Q_VECTOR_3D ) : Q_VECTOR_2D is
		do
			Result := table_model.position_world_to_table (world_)
		end

	is_correct_opening (collisions_: LIST[Q_COLLISION_EVENT]): BOOLEAN is
			-- was this sequence of collisions a legal opening for this game mode
		require
			collisions_ /= Void
		deferred
		end
		
		
		
	
		

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end -- class Q_MODE
