indexing
	description: "Displays a menu, allowing to change some settings or to start a new game"
	author: "Benjamin Sigg"

class
	Q_ESCAPE_STATE

inherit
	Q_GAME_STATE

creation
	make
	
feature{NONE}--creation
	make( move_ : BOOLEAN ) is
		do
			create_menus( move_ )
			settings_read := false
		end

feature
	install( ressources_: Q_GAME_RESSOURCES ) is
		do					
			ressources_.gl_manager.add_hud( container )
			ressources := ressources_
			ressources_.put_state ( current )
			
			follow_on_shot.set_selected( ressources_.follow_on_shot )
			goto_main_menu( void, void )
			
			if not settings_read then
				read_settings
			end
		end

	uninstall( ressources_: Q_GAME_RESSOURCES ) is
		do
			save_settings
			ressources_.gl_manager.remove_hud( container )
			ressources := void
			
			human_player_one.set_enabled( true )
			human_player_two.set_enabled( true )
			human_player_zero.set_enabled( true )
			
			ressources_.set_follow_on_shot( follow_on_shot.selected )
			
			main_menu.remove( return_button )
			return_state := void
			do_return := false
		end

	step( ressources_: Q_GAME_RESSOURCES ) is
		do
			-- do nothing
		end

	next( ressources_: Q_GAME_RESSOURCES ): Q_GAME_STATE is
		local
			events_ : Q_EVENT_QUEUE
			key_event_ : ESDL_KEYBOARD_EVENT
		do
			from
				events_ := ressources_.event_queue
			until
				events_.is_empty or do_return
			loop
				if events_.is_key_down_event then
					key_event_ := events_.pop_keyboard_event
					if key_event_.key = key_event_.sdlk_escape then
						do_return := true
					end
				else
					events_.pop
				end
			end
			
			if do_return and next_state = void then
				result := return_state
			else
				result := next_state
			end
			
			if result /= void then
				return_state := void
				next_state := void				
			end
		end

	identifier: STRING is
		do
			result := "escape"
		end
		
	call_from( state_ : Q_GAME_STATE ) is
			-- Adds an additional button to the menu "return". If this
			-- button is pressed, "state_" is set as next-state
		do
			return_state := state_
			
			if state_ /= void then
				do_return := false
				main_menu.add( return_button )
			end
		end
		
		
feature{NONE} -- temporaly values
	ressources : Q_GAME_RESSOURCES
	
	return_state : Q_GAME_STATE
		-- the next state if "return" is pressed on the main-menu
	
	do_return : BOOLEAN
		-- if true, the next call of "next" will return the "return_state"
	
	next_state : Q_GAME_STATE
		-- next state to set
	
feature{NONE} -- menus
	container : Q_HUD_CONTAINER
	menu : Q_HUD_4_CUBE_SIDES
	moves : ARRAY[ Q_HUD_SLIDING ]
	
	main_menu, option_menu, secondary_option, game_menu, quit_dialog, game_dialog : Q_HUD_CONTAINER
		-- the Menus
		
	help_menus: ARRAY[ Q_HUD_CONTAINER ]
		
	return_button : Q_HUD_BUTTON
		-- only used, if the menu is called by a state from a game

	human_player_zero, human_player_one, human_player_two : Q_HUD_RADIO_BUTTON
		-- how many human players should be allowed
		
	follow_on_shot : Q_HUD_CHECK_BOX
		
	player_name_1, player_name_2 : Q_HUD_TEXT_FIELD
		-- name of the player(s)

	font : Q_HUD_FONT is
			-- 
		do
			result := create{Q_HUD_IMAGE_FONT}.make_standard( "Arial", 32, false, false )
		end
		
feature{NONE} -- menu creation
	create_menus( move_ : BOOLEAN ) is
		local
			index_ : INTEGER
			sliding_ : Q_HUD_SLIDING
			help_text_ : Q_INI_FILE_READER
			defaults_ : Q_INI_FILE_READER
		do
			create menu.make
			create moves.make( 1, 4 )
			menu.set_bounds( 0, 0, 1, 1 )
			
			from
				index_ := 1
			until
				index_ > 4
			loop
				create sliding_.make
				sliding_.set_bounds( 0, 0, 1, 1 )
				sliding_.set_duration( 1500 )
				moves.force( sliding_, index_ )
				menu.side( index_ ).add( sliding_ )
				index_ := index_ + 1
			end
			
			create defaults_.make_and_read( "data/menu.ini" )
			
			create_main_menu( defaults_ )
			create_option_menu( defaults_ )
			create_secondary_options( defaults_ )
			create_quit_dialog( defaults_ )
			create_game_menu( defaults_ )
			create_new_game_dialog( defaults_ )
			
			moves.item( 1 ).add( main_menu )
			moves.item( 1 ).add( quit_dialog )
			moves.item( 2 ).add( option_menu )
			moves.item( 2 ).add( secondary_option )
			moves.item( 4 ).add( game_menu )
			moves.item( 4 ).add( game_dialog )
			
			create_background( main_menu )
			create_background( option_menu )
			create_background( quit_dialog )
			create_background( game_menu )
			create_background( game_dialog )
			create_background( secondary_option )
			
			create help_menus.make( 1, 5 )
			create help_text_.make_and_read( "data/help.ini" )
			from index_ := 1 until index_ > 5 loop
				help_menus.force( create_help_menu( index_, help_text_ ), index_ )
				create_background( help_menus.item( index_ ))
				index_ := index_ + 1
			end
			
			if move_ then
				container := menu
			else
				create_container
			end
		end
	
	create_container is
		local
			container_ : Q_HUD_CONTAINER_3D
		do
			create container_.make
			container_.scale( 2, 2, 2 )
			container_.translate( -0.25, -0.25, -0.5 )
			container_.set_bounds( 0, 0, 1, 1 )
			container_.add( menu )
			menu.set_move_distance( 0 )
			
			container := container_
		end
		
	
	create_background( container_ : Q_HUD_CONTAINER ) is
		local
			back_ : Q_HUD_CONTAINER_3D
			panel_ : Q_HUD_PANEL
		do
			create back_.make
			create panel_.make
			
			back_.translate( 0, 0, -0.2 )
			
			back_.set_bounds( 0, 0, 1, 1 )
			panel_.set_bounds( 0.2, 0.2, 0.6, 0.6 )
			back_.add( panel_ )
			container_.add( back_ )
		end
		

	create_main_menu( defaults_ : Q_INI_FILE_READER ) is
		local
			game_, option_, help_, exit_ : Q_HUD_BUTTON
		do
			create main_menu.make
			main_menu.set_bounds( 0, 0, 1, 1 )
			main_menu.set_focus_handler( create {Q_FOCUS_DEFAULT_HANDLER} )
			
			create game_.make
			create option_.make
			create help_.make
			create exit_.make
			create return_button.make
			
			main_menu.add( game_ )
			main_menu.add( option_ )
			main_menu.add( help_ )
			main_menu.add( exit_ )
			
			game_.actions.extend( agent new_game( ?,? ))
			option_.actions.extend( agent goto_option_menu( ?, ? ))
			help_.actions.extend( agent help( ?, ? ))
			exit_.actions.extend( agent goto_quit_dialog( ?, ? ))
			return_button.actions.extend( agent return_to_game( ?, ? ))
			
			game_.set_text( defaults_.value( "main", "new game" ))
			option_.set_text( defaults_.value( "main", "option" ))
			help_.set_text( defaults_.value( "main", "help" ))
			exit_.set_text( defaults_.value( "main", "quit" ))
			return_button.set_text(  defaults_.value( "main", "return" ))
			
			game_.set_bounds( 0.1, 0.1, 0.8, 0.1 )
			option_.set_bounds( 0.1, 0.25, 0.8, 0.1 )
			help_.set_bounds( 0.1, 0.4, 0.8, 0.1 )
			exit_.set_bounds( 0.1, 0.55, 0.8, 0.1 )
			return_button.set_bounds( 0.5, 0.8, 0.4, 0.1 )
		end
		
	create_quit_dialog( defaults_ : Q_INI_FILE_READER ) is
		local
			container_ : Q_HUD_CONTAINER
			button_ : Q_HUD_BUTTON
			label_ : Q_HUD_LABEL
		do
			create container_.make
			container_.set_bounds( 0, 1, 1, 1 )
			container_.set_focus_handler( create {Q_FOCUS_DEFAULT_HANDLER} )
			
			create label_.make
			label_.set_text( defaults_.value( "quit", "question" ))
			label_.set_bounds( 0.1, 0.4, 0.8, 0.1 )
			label_.set_insets( create {Q_HUD_INSETS}.make( 0.01, 0.05, 0.01, 0.01 ))
			container_.add( label_ )
			
			create button_.make
			button_.set_text( defaults_.value( "quit", "no" ))
			button_.set_bounds( 0.6, 0.55, 0.3, 0.1 )
			container_.add( button_ )
			button_.actions.extend( agent goto_main_menu( ?, ? ))			
			
			create button_.make
			button_.set_text( defaults_.value( "quit", "yes" ))
			button_.set_bounds( 0.2, 0.55, 0.3, 0.1 )
			container_.add( button_ )
			button_.actions.extend( agent exit( ?, ? ))
			
			quit_dialog := container_
		end
		
	
	create_option_menu( defaults_ : Q_INI_FILE_READER ) is
		local
			menu_, secondary_ : Q_HUD_BUTTON
			group_ : Q_HUD_SELECTABLE_BUTTON_GROUP
			label_1_, label_2_ : Q_HUD_LABEL
		do
			create option_menu.make
			option_menu.set_focus_handler( create {Q_FOCUS_DEFAULT_HANDLER} )
			
			create human_player_zero.make
			create human_player_one.make
			create human_player_two.make
			
			create menu_.make
			create secondary_.make
			create group_.make
			
			create player_name_1.make
			create player_name_2.make
			
			create label_1_.make
			create label_2_.make
			label_1_.set_insets( create {Q_HUD_INSETS}.make( 0.01, 0.05, 0.01, 0.01 ))
			label_2_.set_insets( create {Q_HUD_INSETS}.make( 0.01, 0.05, 0.01, 0.01 ))
			
			group_.add( human_player_zero )
			group_.add( human_player_one )
			group_.add( human_player_two )
			
			human_player_two.set_selected( true )
			
			human_player_zero.set_text( defaults_.value( "option", "ai ai" ))
			human_player_one.set_text( defaults_.value( "option", "human ai" ))
			human_player_two.set_text( defaults_.value( "option", "human human" ))
			
			label_1_.set_text( defaults_.value( "option", "name player 1" ))
			label_2_.set_text( defaults_.value( "option", "name player 2" ))
			
			menu_.set_text( defaults_.value( "option", "return" ))
			secondary_.set_text( defaults_.value( "option", "secondary" ))
			
			option_menu.add( human_player_zero )
			option_menu.add( human_player_one )
			option_menu.add( human_player_two )
			option_menu.add( label_1_ )
			option_menu.add( label_2_ )
			option_menu.add( player_name_1 )
			option_menu.add( player_name_2 )
			option_menu.add( secondary_ )
			option_menu.add( menu_ )
			
			human_player_zero.set_bounds( 0.1, 0.1, 0.8, 0.08 )
			human_player_one.set_bounds( 0.1, 0.2, 0.8, 0.08 )
			human_player_two.set_bounds( 0.1, 0.3, 0.8, 0.08 )
			
			label_1_.set_bounds( 0.1, 0.5, 0.35, 0.08 )
			label_2_.set_bounds( 0.55, 0.5, 0.35, 0.08 )

			player_name_1.set_bounds( 0.1, 0.6, 0.35, 0.08 )
			player_name_2.set_bounds( 0.55, 0.6, 0.35, 0.08 )			
			
			menu_.set_bounds( 0.55, 0.8, 0.35, 0.08 )
			menu_.actions.extend( agent goto_main_menu( ?, ? ))
			
			secondary_.set_bounds( 0.15, 0.8, 0.35, 0.08 )
			secondary_.actions.extend( agent goto_secondary_option )
		end
		
	create_secondary_options( defaults_ : Q_INI_FILE_READER ) is
		local
			menu_, option_ : Q_HUD_BUTTON
		do
			create secondary_option.make
			secondary_option.set_focus_handler( create {Q_FOCUS_DEFAULT_HANDLER} )
			secondary_option.set_bounds( 0, 1, 1, 1 )
			
			create follow_on_shot.make
			follow_on_shot.set_text( defaults_.value( "secondary", "follow" ))
			follow_on_shot.set_bounds( 0.1, 0.1, 0.8, 0.1 )
			secondary_option.add( follow_on_shot )

			create menu_.make
			menu_.set_text( defaults_.value( "secondary", "menu" ))
			menu_.set_bounds( 0.15, 0.8, 0.35, 0.08 )
			menu_.actions.extend( agent goto_main_menu )
			secondary_option.add( menu_ )
			
			create option_.make
			option_.set_text( defaults_.value( "secondary", "option" ))
			option_.set_bounds( 0.55, 0.8, 0.35, 0.08 )
			option_.actions.extend( agent goto_option_menu( ?, ? ))
			secondary_option.add( option_ )
		end
		
		
	create_game_menu( defaults_ : Q_INI_FILE_READER ) is
		local
			container_ : Q_HUD_CONTAINER
			button_ : Q_HUD_BUTTON
		do
			create container_.make
			create button_.make
			container_.set_focus_handler( create {Q_FOCUS_DEFAULT_HANDLER} )
			container_.set_bounds( 0, 0, 1, 1 )
			
			button_.set_text( defaults_.value( "game", "8ball" ))
			button_.set_bounds( 0.1, 0.1, 0.8, 0.1 )
			container_.add( button_ )
			button_.actions.extend( agent start_8_ball( ?, ? ))


			create button_.make
			button_.set_bounds( 0.1, 0.25, 0.8, 0.1 )
			button_.set_text( defaults_.value( "game", "eth" ))
			container_.add( button_ )
			button_.actions.extend( agent start_eth ( ?, ? ))

			create button_.make
			button_.set_bounds( 0.5, 0.8, 0.4, 0.1 )
			button_.set_text( defaults_.value( "game", "return" ))
			container_.add( button_ )
			button_.actions.extend( agent goto_main_menu( ?, ? ))
			
			game_menu := container_
		end
		
	create_new_game_dialog( defaults_ : Q_INI_FILE_READER ) is
		local
			container_ : Q_HUD_CONTAINER
			button_ : Q_HUD_BUTTON
			label_ : Q_HUD_LABEL
		do
			create container_.make
			container_.set_focus_handler( create {Q_FOCUS_DEFAULT_HANDLER} )
			container_.set_bounds( 0, 1, 1, 1 )
			
			create label_.make
			label_.set_text( defaults_.value( "new_game", "question" ))
			label_.set_bounds( 0.1, 0.4, 0.8, 0.1 )
			label_.set_insets( create {Q_HUD_INSETS}.make( 0.01, 0.05, 0.01, 0.01 ))
			container_.add( label_ )
			
			create button_.make
			button_.set_text( defaults_.value( "new_game", "no" ))
			button_.set_bounds( 0.6, 0.55, 0.3, 0.1 )
			container_.add( button_ )
			button_.actions.extend( agent goto_main_menu( ?, ? ))			
			
			create button_.make
			button_.set_text( defaults_.value( "new_game", "yes" ))
			button_.set_bounds( 0.2, 0.55, 0.3, 0.1 )
			container_.add( button_ )
			button_.actions.extend( agent goto_game_menu( ?, ? ))
			
			game_dialog := container_
		end
		
	create_help_menu( menu_ : INTEGER; text_ : Q_INI_FILE_READER ) : Q_HUD_CONTAINER is
		local
			labels_ : ARRAY[ Q_HUD_LABEL ]
			label_ : Q_HUD_LABEL
			index_ : INTEGER
			container_ : Q_HUD_CONTAINER
			button_ : Q_HUD_BUTTON
			string_ : STRING
			insets_ : Q_HUD_INSETS
			height_ : DOUBLE
		do
			-- create plane for writing
			create labels_.make( 1, text_.value( "help", "labels" ).to_integer )
			create container_.make
			create insets_.make( 0.001, 0.05, 0.001, 0.001 )
			container_.set_bounds( 0, help_menu_move( menu_ ), 1, 1 )
			container_.set_focus_handler( create{Q_FOCUS_DEFAULT_HANDLER} )
			moves.item( help_menu_side( menu_ ) ).add( container_ )
			
			height_ := 0.7 / labels_.count
			from index_ := 1 until index_ > labels_.upper loop
				create label_.make
				labels_.force( label_, index_ )
				container_.add( label_ )
				label_.set_bounds( 0.1, 0.1 + (index_-1)*height_, 0.8, height_ )
				label_.set_insets( insets_ )
				index_ := index_ + 1
			end
			
			-- add some buttons
			create button_.make
			button_.set_text( text_.value( "help", "back" ))
			button_.actions.extend( agent goto_help( ?,?,menu_-1 ) )
			button_.set_bounds( 0.1, 0.81, 0.2, 0.09 )
			container_.add( button_ )
			
			create button_.make
			button_.set_text( text_.value( "help", "menu" ))
			button_.actions.extend( agent goto_main_menu( ?,? ) )
			button_.set_bounds( 0.4, 0.81, 0.2, 0.09 )
			container_.add( button_ )
			
			create button_.make
			button_.set_text( text_.value( "help", "next" ))
			button_.actions.extend( agent goto_help( ?,?,menu_+1 ) )
			button_.set_bounds( 0.7, 0.81, 0.2, 0.09 )
			container_.add( button_ )			
			
			-- set text
			from index_ := 1 until index_ > labels_.upper loop
				string_ := text_.value( menu_.out, index_.out )
				if string_ /= void then
					labels_.item( index_ ).set_text( string_ )					
				end
				index_ := index_ + 1
			end
			
			result := container_
		end
	
	help_menu_side( index__ : INTEGER ) : INTEGER is
		local
			index_ : INTEGER
		do
			if index__ > 5 then
				index_ := index__ - 5
			elseif index__ < 1 then
				index_ := index__ + 5
			else
				index_ := index__
			end
			
			inspect index_
			when 1 then result := 1
			when 2 then result := 2
			when 3 then result := 3
			when 4 then result := 3
			when 5 then result := 4
			end
		end
	
	help_menu_move( index__ : INTEGER ) : INTEGER is
		local
			index_ : INTEGER
		do
			if index__ > 5 then
				index_ := index__ - 5
			elseif index__ < 1 then
				index_ := index__ + 5
			else
				index_ := index__
			end
			
			inspect index_
			when 1 then result := -1
			when 2 then result := -1
			when 3 then result := 0
			when 4 then result := -1
			when 5 then result := -1
			end			
		end
		
	
feature{NONE} -- event-handling
	settings_read : BOOLEAN
	
	read_settings is
		local
			value_ : STRING
		do
			settings_read := true
			
			value_ := ressources.values.value( "escape", "human player" )
			if value_ /= void then
				if value_.is_equal( "0" ) then
					human_player_zero.set_selected( true )
				elseif value_.is_equal( "1" ) then
					human_player_one.set_selected( true )
				else
					human_player_two.set_selected( true )
				end
			end
			
			value_ := ressources.values.value( "escape", "player name a" )
			if value_ /= void then
				player_name_1.set_text( value_ )
			end
			
			value_ := ressources.values.value( "escape", "player name b" )
			if value_ /= void then
				player_name_2.set_text( value_ )
			end
			
			value_ := ressources.values.value( "escape", "follow" )
			if value_ /= void then
				follow_on_shot.set_selected( value_.to_boolean )
			end			
		end
		

	save_settings is
		do
			if human_player_zero.selected then
				ressources.values.put( "escape", "human player", "0" )
			elseif human_player_one.selected then
				ressources.values.put( "escape", "human player", "1" )
			else
				ressources.values.put( "escape", "human player", "2" )
			end
			
			if player_name_1.text.count > 0 then
				ressources.values.put( "escape", "player name a", player_name_1.text )				
			end
			
			if player_name_2.text.count > 0 then
				ressources.values.put( "escape", "player name b", player_name_2.text )
			end
			
			ressources.values.put( "escape", "follow", follow_on_shot.selected.out )
		end
		

	new_game( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			if return_state = void then
				goto_game_menu( command_, button_ )
			else
				goto_new_game_dialog( command_, button_ )
			end
		end

	help( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			goto_help( command_, button_, 1 )
		end

	exit( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			if menu.rotated_to /= 1 or moves.item( 1 ).destination_position.rounded /= 1 then
				goto_quit_dialog( command_, button_ )
			else
				save_settings
				ressources.logic.quit
			end
		end

	goto_option_menu( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			goto_side( 2, 0 )
			option_menu.focus_handler.focus_default( option_menu )
		end

	goto_secondary_option( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			goto_side( 2, 1 )
			secondary_option.focus_handler.focus_default( secondary_option )
		end
		

	goto_quit_dialog( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			goto_side( 1, 1 )
			quit_dialog.focus_handler.focus_default( quit_dialog )
		end
		
	goto_game_menu( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			goto_side( 4, 0 )
			game_menu.focus_handler.focus_default( game_menu )
		end
		
	goto_new_game_dialog( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			goto_side( 4, 1 )
			game_dialog.focus_handler.focus_default( game_dialog )
		end
		

	goto_main_menu( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			goto_side( 1, 0 )
			main_menu.focus_handler.focus_default( main_menu )
		end
		

	return_to_game( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			do_return := true
		end
		
	goto_help( command_ : STRING; button_ : Q_HUD_BUTTON; index__: INTEGER ) is
		local
			focus_ : Q_HUD_CONTAINER
			index_ : INTEGER
		do
			if index__ > 5 then
				index_ := index__ - 5
			elseif index__ < 1 then
				index_ := index__ + 5
			else
				index_ := index__
			end			
			
			goto_side( help_menu_side( index_ ), help_menu_move( index_ ) )
			focus_ := help_menus.item( index_ )
			focus_.focus_handler.focus_default( focus_ )
		end
		
	
	goto_side( side_, move_ : INTEGER ) is
		do
			menu.rotate_to( side_ )
			moves.item( side_ ).move_to( move_ )
		end
		
feature{NONE} -- new games
	game_menu_armed : BOOLEAN is
			-- Tests, if the game-menu is visible
		do
			result := menu.rotated_to = 4 and moves.item( 4 ).destination_position.rounded = 0
		end

	start_8_ball( command_ : STRING; button_ : Q_HUD_BUTTON ) is
			-- Starts an 8ball-game
		local
			eball: Q_8BALL
			player_a_, player_b_ : Q_PLAYER
		do
			if game_menu_armed then
				eball ?= ressources.request_mode( "8ball" )
				if eball = void then
					create eball.make
					ressources.put_mode( eball )
				end
				-- reset the balls
				eball.reset_balls
				if human_player_zero.selected then
					player_a_ := eball.ai_player
					player_b_ := eball.ai_player
				elseif human_player_one.selected then
					player_a_ := eball.human_player
					player_b_ := eball.ai_player					
				else
					player_a_ := eball.human_player
					player_b_ := eball.human_player
				end
				
				player_a_.set_name( player_name_1.text )
				player_b_.set_name( player_name_2.text )
				
				eball.set_player_a( player_a_ )
				eball.set_player_b( player_b_ )
				
				ressources.set_mode( eball )
				next_state := eball.first_state( ressources )
			else
				goto_game_menu( command_, button_ )
			end
		end
		
	start_eth(command_: STRING; button_ : Q_HUD_BUTTON) is
			-- starts an eth game
		local
			eth: Q_ETH
			player_a_ : Q_PLAYER
		do
			if game_menu_armed then
				eth ?= ressources.request_mode( "eth" )
				if eth = void then
					create eth.make
					ressources.put_mode( eth )
				end
				player_a_ := eth.human_player
				player_a_.set_name (player_name_1.text)
				eth.set_player( player_a_ )
				ressources.set_mode( eth )
				-- reset the balls
				eth.restart
				next_state := eth.first_state( ressources )
			else
				goto_game_menu( command_, button_ )
			end
		end
		
		

end -- class Q_ESCAPE_STATE
