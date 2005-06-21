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
	description: "Basically a list of all Ressources that are used in the game"
	author: "Severin Hacker, Basil Fierz, Benjamin Sigg"

class
	Q_GAME_RESSOURCES

creation
	make

feature{NONE} -- creation
	make( logic_ : Q_GAME_LOGIC ) is
		do
			create time
			create state_list.make( 20 )
			create mode_list.make( 20 )
			create gl_manager.make_timed( logic_.screen.width, logic_.screen.height, time )
			create simulation.make
			create logger.make
			create values.make
			
			logic := logic_
		end

feature -- time
	time : Q_TIME

feature	-- Physics
	simulation : Q_SIMULATION

feature  -- game logic
	logic : Q_GAME_LOGIC
	
	mode : Q_MODE -- the mode of the game
	
	set_mode( mode_ : Q_MODE ) is
		do
			if mode /= void then
				mode.uninstall( current )
			end
			
			mode := mode_
			
			if mode /= void then
				mode.install( current )
			end
		end
		

feature  -- graphics
	gl_manager : Q_GL_MANAGER -- manager of the OpenGL-Tree

	follow_on_shot : BOOLEAN
		-- true if the normally, the camera will follow the ball when it is shot
		
	set_follow_on_shot( follow_ : BOOLEAN ) is
		do
			follow_on_shot := follow_
		end
		

feature  -- I/O
	event_queue : Q_EVENT_QUEUE is
			-- 
		do
			result := gl_manager.unused_events
		end
		
	values : Q_INI_FILE_READER
	
	logger : Q_LOGGER

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

feature -- modes
	request_mode( name_ : STRING ) : Q_MODE is
			-- Searches a state. If the mode is found, it is
			-- returned, otherwise a result is set to void
		require
			name_ /= void
		do
			if mode_list.has( name_ ) then
				result := mode_list.item( name_ ) 
			else
				result := void
			end
		end
	
	put_mode( mode_ : Q_MODE ) is
			-- Inserts a new mode in the list of all states.
			-- The feature "identifier" of Q_MODE is used, to create
			-- an identifier. With this identifier, its possible to
			-- refind a state by calling the "request_mode"-feature
		require
			mode_ /= void
		do
			 mode_list.put( mode_, mode_.identifier )
		end
		
	drop_mode( mode_ : Q_GAME_STATE ) is
			-- Removes a state from the list.
			-- Be extremly carefull with this method, a state may
			-- hold some important informations about the game-state
		require
			mode_ /= void
		do
			mode_list.remove( mode_.identifier )
		end
		
		
feature{NONE} -- state
	state_list : HASH_TABLE[ Q_GAME_STATE, STRING ]
	
	mode_list : HASH_TABLE[ Q_MODE, STRING ]

end -- class Q_GAME_RESSOURCES
