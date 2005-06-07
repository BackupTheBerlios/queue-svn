indexing
	description: "Shows the user a menu with different choices. Per default, the menu will be shown in the lower 60 perzent of the screen"
	author: "Benjamin Sigg"

class
	Q_CHOICE_STATE

inherit
	Q_ESCAPABLE_STATE
	rename
		set_next_state as goto_next_state
	end
	
creation
	make
	
feature{NONE} -- creation
	make( identifier_ : STRING; count_ : INTEGER ) is
			-- creates a new choice. There must be at least tow different choises
			-- don't forget to set the text for the choices, by calling the
			-- button-feature
			-- There is no limit for buttons, but if you add more than 16 buttons,
			-- they will perhaps have some ugly bounds.
		require
			identifier_ /= void
			real_choice : count_ > 1
		do
			create buttons.make( count_ )
			identifier := identifier_
			create_menu( count_ )

			button_index := 1
			old_back_side := 9
		end
		
	create_menu( count_ : INTEGER ) is
			-- creates the menu. That means, add all buttons to the menu,
			-- and add some agents
		local
			container_ : Q_HUD_CONTAINER_3D
		do
			create menu.make
			create container_.make
			create cube.make
			
			menu.set_duration( 250 )
			
			menu.set_bounds( 0, 0, 1, 1 )
			container_.set_bounds( 0, 0, 1, 1 )
			cube.set_bounds( 0, 0, 1, 1 )
			
			menu.add( container_ )
			container_.add( cube )
			
			container_.scale( 2, 2, 2 )
			container_.translate( -0.25, -0.25, -0.5 )
			cube.set_move_distance( 0 )
			
			if count_ <= 5 then
				create_small_menu( count_, false, false, 1 )
			elseif count_ <= 8 then
				create_small_menu( 4, true, false, 1 )
				create_small_menu( count_-4, false, true, 2 )
			elseif count_ <= 12 then
				create_small_menu( 4, true, false, 1 )
				create_small_menu( 4, true, true, 2 )
				create_small_menu( count_-8, false, true, 3 )
			elseif count_ <= 16 then
				create_small_menu( 4, true, true, 1 )
				create_small_menu( 4, true, true, 2 )
				create_small_menu( 4, true, true, 3 )
				create_small_menu( count_-12, true, true, 4 )
			else
				create_big_menu( count_ )
			end
			
			ensure_cube_sides_focus_root
		end		
		
	ensure_cube_sides_focus_root is
		local
			handler_ : Q_FOCUS_DEFAULT_HANDLER
			index_ : INTEGER
		do
			create handler_
			from index_ := 1 until index_ > 4 loop
				cube.side( index_ ).set_focus_handler( handler_ )
				index_ := index_ + 1
			end
		end
		
		
	create_small_menu( count_ : INTEGER; next_, previous_ : BOOLEAN; side_ : INTEGER ) is
		local
			index_ : INTEGER
			button_ : Q_HUD_BUTTON
		do
			from
				index_ := 1
			until
				index_ > count_
			loop
				create button_.make
				button_.set_bounds( 0.1, 0.3 + index_ * 0.1, 0.8, 0.09 )
				cube.side( side_ ).add( button_ )
				
				buttons.extend( button_ )
				index_ := index_ + 1
			end
			
			if previous_ then
				create_backward_button( side_ )
			end
			
			if next_ then
				create_forward_button( side_ )
			end
		end
		
	create_forward_button( side_ : INTEGER ) is
		local
			button_ : Q_HUD_BUTTON
		do
			create button_.make
			button_.set_bounds( 0.6, 0.8, 0.3, 0.09 )
			button_.set_text( "next" )
			button_.actions.extend( agent next_side( ?,?, side_ ))
			
			cube.side( side_ ).add( button_ )
		end
		
	create_backward_button( side_ : INTEGER ) is
		local
			button_ : Q_HUD_BUTTON
		do
			create button_.make
			button_.set_bounds( 0.2, 0.8, 0.3, 0.09 )
			button_.set_text( "previous" )
			button_.actions.extend( agent previous_side( ?,?, side_ ))
			
			cube.side( side_ ).add( button_ )
		end
		
		
	create_big_menu( count_ : INTEGER ) is
		local
			side_, created_, index_ : INTEGER
			button_ : Q_HUD_BUTTON
		do
			-- initialise buttons
			from
				side_ := 0
				created_ := 0
			until
				created_ >= count_
			loop
				side_ := side_ + 1
				
				from
					index_ := 1
				until
					index_ > 4 or created_>= count_
				loop
					create button_.make
					button_.set_bounds( 0.1, 0.3 + index_ * 0.1, 0.8, 0.09 )			
					buttons.extend( button_ )
					
					index_ := index_ + 1
					created_ := created_ + 1
				end
			end
			
			-- set first 13-16 buttons
			from
				index_ := buttons.count
			until
				index_ < buttons.count and (index_ \\ 4) = 0
			loop
				cube.side( 4 ).add( buttons.i_th( index_ ) )
				index_ := index_ - 1
			end
			
			index_ := 1
			from side_ := 1 until side_ > 3	loop
				from
					created_ := 1
				until
					created_ > 4
				loop
					cube.side( side_ ).add( buttons.i_th( index_ ))
					index_ := index_ + 1
					created_ := created_ + 1
				end
				side_ := side_ + 1
			end
			
			old_back_side := 9
			
			-- generate buttons for navigation
			from side_ := 1 until side_ > 4 loop
				create_backward_button( side_ )
				create_forward_button( side_ )
				side_ := side_ + 1
			end
		end		
		
feature{NONE} -- hud
	button_index, old_back_side : INTEGER

	next_side( command_ : STRING; button_ : Q_HUD_BUTTON; buttons_side_ : INTEGER ) is
		local
			index_, original_ : INTEGER
		do
			if cube.rotated_to = buttons_side_ then
				if buttons.count > 16 then
					-- exchange the backward side
					original_ := button_index
					index_ := button_index + 4
					if index_ > buttons.count then
						index_ := 1
					end
					
					button_index := index_
					
					index_ := index_ + 4
					if index_ > buttons.count then
						index_ := 1
					end
					
					remove_old_back_side
					add_new_back_side( index_ )

					index_ := original_ - 4
					if index_ < 1 then
						index_ := buttons.count - (buttons.count \\ 4)
					end					
					old_back_side := index_
				end
				
				if cube.rotated_to = 4 then
					cube.rotate_to( 1 )
				else
					cube.rotate_to( cube.rotated_to + 1 )
				end
				
				if buttons.count > 16 then
					buttons.i_th( button_index ).request_focus
				else
					buttons.i_th( (cube.rotated_to - 1) * 4 + 1 ).request_focus
				end
			end
		end
		
	previous_side( command_ : STRING; button_ : Q_HUD_BUTTON; buttons_side_ : INTEGER ) is
		local
			index_, original_ : INTEGER
		do
			if cube.rotated_to = buttons_side_ then
				if buttons.count > 16 then
					-- exchange the backward side
					original_ := button_index
					index_ := button_index - 4
					if index_ < 1 then
						index_ := buttons.count - (buttons.count \\ 4) + 1
					end
					
					button_index := index_
					
					index_ := index_ - 4
					if index_ < 1 then
						index_ := buttons.count - (buttons.count \\ 4) + 1
					end
					
					remove_old_back_side
					add_new_back_side( index_ )
					
					index_ := original_ + 4
					if index_ > buttons.count then
						index_ := 1
					end					
					old_back_side := index_				
				end
				
				if cube.rotated_to = 1 then
					cube.rotate_to( 4 )
				else
					cube.rotate_to( cube.rotated_to - 1 )
				end
				
				if buttons.count > 16 then
					buttons.i_th( button_index ).request_focus
				else
					buttons.i_th( (cube.rotated_to - 1) * 4 + 1 ).request_focus
				end				
			end
		end
		
	remove_old_back_side is
		local
			index_, side_ : INTEGER
		do
			side_ := cube.rotated_to + 2
			if side_ > 4 then
				side_ := side_ - 4
			end
			
			from
				index_ := 0
			until
				index_ > 3 or index_ + old_back_side > buttons.count
			loop
				cube.side( side_ ).remove( buttons.i_th( index_ + old_back_side ))
				index_ := index_ + 1
			end
		end
		
	add_new_back_side( first_ : INTEGER ) is
		local
			index_, side_ : INTEGER
		do
			side_ := cube.rotated_to + 2
			if side_ > 4 then
				side_ := side_ - 4
			end
			
			from
				index_ := 0
			until
				index_ > 3 or index_ + first_ > buttons.count
			loop
				cube.side( side_ ).add( buttons.i_th( index_ + first_ ))
				index_ := index_ + 1
			end
		end		
		
	buttons : ARRAYED_LIST[ Q_HUD_BUTTON ]
	
	menu : Q_HUD_SLIDING
	cube : Q_HUD_4_CUBE_SIDES
	
feature -- buttons
	button( index_ : INTEGER ) : Q_HUD_BUTTON is
			-- returns a button. You can add agents, or change the text...
		do
			result := buttons.i_th( index_ )
		end
		
feature -- state
	awaiting_state : Q_GAME_STATE

	set_next_state( state_ : Q_GAME_STATE ) is
			-- Sets the next state, that will be displayed.
			-- The state will not be shown directly, first the menu
			-- will disappear (or if the state is void, the menu
			-- will reappear).
			-- If there is still a state awaiting, it will be overwriten.
		do
			if state_ = void then
				set_menu_visible( true )
			else
				set_menu_visible( false )
			end
			
			awaiting_state := state_
		end
		
	set_menu_visible( visible_ : BOOLEAN ) is
			-- sets the menu visible, or not
		do
			if visible_ then
				menu.move_to( 0 )
			else
				menu.move_to( -10 )
			end
		end
		
	is_menu_visible : BOOLEAN is
			-- true if the menu can be seen by the user, false otherwise
		do
			result := menu.current_location > -4
		end
		
		
feature -- interface
	install( ressources_ : Q_GAME_RESSOURCES ) is
		do
			ressources_.gl_manager.add_hud( menu )
			set_menu_visible( true )
		end
		
	uninstall( ressources_ : Q_GAME_RESSOURCES ) is
		do
			ressources_.gl_manager.remove_hud( menu )
		end
		
	step( ressources_ : Q_GAME_RESSOURCES ) is
		do
			if awaiting_state /= void and not is_menu_visible then
				goto_next_state( awaiting_state )
				awaiting_state := void
			end
		end
		
	identifier : STRING
	
end -- class Q_CHOICE_STATE
