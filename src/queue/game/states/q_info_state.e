indexing
	description: "A state displaying some informations to the user. The user can continue by pressing an ok-button"
	author: "Benjamin Sigg"

class
	Q_INFO_STATE

inherit
	Q_ESCAPABLE_STATE

creation
	make_positioned
	
feature{NONE}
	make_positioned( left_to_right_, menu_at_top_ : BOOLEAN; identifier_ : STRING ) is
		local
			button_ : Q_HUD_BUTTON
			index_ : INTEGER
			label_ : Q_HUD_LABEL
		do
			left_to_right := left_to_right_
			identifier := identifier_
			
			create container.make
			create button_.make
			
			button_.set_text( "ok" )
			button_.set_bounds( 0.0, 0.4, 0.3, 0.95 )
			button_.actions.extend( agent handle_button )
			container.add( button_ )
			
			create labels.make( 1, 5 )
			
			from index_ := 1 until index_ > labels.upper loop
				create label_.make

			end
		end
		
	handle_button( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			move_to_end
		end
		
feature{NONE} -- panel
	container : Q_HUD_SLIDING_3D
	
	labels : ARRAY[ Q_HUD_LABEL ]
	
	left_to_right : BOOLEAN
	
feature -- text and state
	set_text( text_ : STRING; index_ : INTEGER ) is
		do
			labels.item( index_ ).set_text( text_ )
		end
		
	label_count : INTEGER is
		do
			result := labels.count
		end
		
	info_gone : BOOLEAN is
			-- true if the info is no longer visible
		do
			if left_to_right then
				result := container.current_position.x > 0.95
			else
				result := container.current_position.x < -0.95
			end
		end
	
	move_to_middle is
		do
			container.move_to( create {Q_VECTOR_3D}.make( 0, 0, 0 ))
		end
	
	goto_start is
		do
			if left_to_right then
				container.set_position( create {Q_VECTOR_3D}.make( -1, 0, 0 ))
			else
				container.set_position( create {Q_VECTOR_3D}.make( 1, 0, 0 ))
			end
		end
	
	move_to_end is
		do
			if left_to_right then
				container.set_position( create {Q_VECTOR_3D}.make( 1, 0, 0 ))
			else
				container.set_position( create {Q_VECTOR_3D}.make( -1, 0, 0 ))
			end
		end
		
feature -- interface
	identifier : STRING
	
	install( ressources_ : Q_GAME_RESSOURCES ) is
		do
			goto_start
			move_to_middle
			ressources_.gl_manager.add_hud( container )
		end
		
	uninstall( ressources_ : Q_GAME_RESSOURCES ) is
		do
			ressources_.gl_manager.remove_hud( container )
		end
	
	step( ressources_ : Q_GAME_RESSOURCES ) is
		do
			if info_gone then
				set_next_state( waiting_next_state )
			end
		end
	
feature -- next-state
	waiting_next_state : Q_GAME_STATE
	
	set_waiting_next_state( state_ : Q_GAME_STATE ) is
			-- Sets the state that will be shown after the user
			-- pressed the ok-button
		do
			waiting_next_state := state_
		end
		

end -- class Q_INFO_STATE
