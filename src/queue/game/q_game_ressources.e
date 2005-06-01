indexing
	description: "Basically a list of all Ressources that are used in the game"
	author: "Severin Hacker, Basil Fierz, Benjamin Sigg"

class
	Q_GAME_RESSOURCES

creation
	make

feature{NONE} -- creation
	make is
		do
			create state_list.make( 20 )
			create gl_manager.make
		end
		

feature	-- Physics
	simulation : Q_SIMULATION
	
feature  -- game logic
	table: Q_TABLE -- the table of the game
	mode : Q_MODE -- the mode of the game
	player_A : Q_PLAYER -- the first player
	player_B : Q_PLAYER -- the second player

feature  -- graphics
	table_model : Q_TABLE_MODEL -- the table model of the game
	gl_manager : Q_GL_MANAGER -- manager of the OpenGL-Tree

feature  -- I/O
	event_queue : Q_EVENT_QUEUE is
			-- 
		do
			result := gl_manager.unused_events
		end
		
	
	-- und Rest aus Game-Logic (Severin!)

feature -- states
	request_state( name_ : STRING ) : Q_GAME_STATE is
			-- Searches a state. If the state is found, it is
			-- returned, otherwise a result is set to void
		require
			name_ /= void
		do
			if state_list.has( name_ ) then
				result := state_list.item( name_ ) 
			else
				result := void
			end
		end
	
	put_state( state_ : Q_GAME_STATE ) is
			-- Inserts a new state in the list of all states.
			-- The feature "identifier" of Q_GAME_STATE is used, to create
			-- an identifier. With this identifier, its possible to
			-- refind a state by calling the "request_state"-feature
		require
			state_ /= void
		do
			 state_list.put( state_, state_.identifier )
		end
		
	drop_state( state_ : Q_GAME_STATE ) is
			-- Removes a state from the list.
			-- Be extremly carefull with this method, a state may
			-- hold some important informations about the game-state
		require
			state_ /= void
		do
			state_list.remove( state_.identifier )
		end
		
		
feature{NONE} -- state
	state_list : HASH_TABLE[ Q_GAME_STATE, STRING ]

end -- class Q_GAME_RESSOURCES
