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
	make is
		do
			create_menus
		end
		

feature
	install( ressources_: Q_GAME_RESSOURCES ) is
		do
			ressources_.gl_manager.set_hud( menu )
			ressources := ressources_
		end

	uninstall( ressources_: Q_GAME_RESSOURCES ) is
		do
			ressources_.gl_manager.set_hud( void )
			ressources := void
			
			human_player_one.set_enabled( true )
			human_player_two.set_enabled( true )
			human_player_zero.set_enabled( true )
			
			main_menu.remove( return_button )
			return_state := void
		end

	step( ressources_: Q_GAME_RESSOURCES ) is
		do
			-- do nothing
		end

	next( ressources_: Q_GAME_RESSOURCES ): Q_GAME_STATE is
		do
			if do_return then
				result := return_state
			else
				result := next_state
			end
			
			return_state := void
			next_state := void
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
	menu : Q_HUD_4_CUBE_SIDES
	move_1 : Q_HUD_SLIDING
	move_4 : Q_HUD_SLIDING
	
	main_menu, option_menu : Q_HUD_CONTAINER
		-- the Menus
		
	return_button : Q_HUD_BUTTON
		-- only used, if the menu is called by a state from a game

	human_player_zero, human_player_one, human_player_two : Q_HUD_RADIO_BUTTON
		-- how many human players should be allowed
		
	player_name_1, player_name_2 : Q_HUD_TEXT_FIELD
		-- name of the player(s)

	font : Q_HUD_FONT is
			-- 
		do
			result := create{Q_HUD_IMAGE_FONT}.make_standard( "Arial", 32, false, false )
		end
		
feature{NONE} -- menu creation
	create_menus is
		do
			create menu.make
			create move_1.make
			create move_4.make
			menu.set_bounds( 0, 0, 1, 1 )
			move_1.set_bounds( 0, 0, 1, 1 )
			move_4.set_bounds( 0, 0, 1, 1 )
			
			create_main_menu
			create_option_menu
			
			menu.side( 1 ).add( move_1 )
			menu.side( 2 ).add( option_menu )
			menu.side( 4 ).add( move_4 )
			
			move_1.add( main_menu )
			move_1.add( create_quit_dialog )
			move_4.add( create_game_menu )
			move_4.add( create_new_game_dialog )
		end
		

	create_main_menu is
		local
			game_, option_, help_, exit_ : Q_HUD_BUTTON
		do
			create main_menu.make
			main_menu.set_bounds( 0, 0, 1, 1 )
			
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
			option_.actions.extend( agent option( ?, ? ))
			help_.actions.extend( agent help( ?, ? ))
			exit_.actions.extend( agent goto_quit_dialog( ?, ? ))
			return_button.actions.extend( agent return_to_game( ?, ? ))
			
			game_.set_text( "New Game" )
			option_.set_text( "Options" )
			help_.set_text( "Help" )
			exit_.set_text( "Quit" )
			return_button.set_text( "Return" )
			
			game_.set_bounds( 0.1, 0.1, 0.8, 0.1 )
			option_.set_bounds( 0.1, 0.25, 0.8, 0.1 )
			help_.set_bounds( 0.1, 0.4, 0.8, 0.1 )
			exit_.set_bounds( 0.1, 0.55, 0.8, 0.1 )
			return_button.set_bounds( 0.1, 0.7, 0.8, 0.1 )
		end
		
	create_quit_dialog : Q_HUD_COMPONENT is
		local
			container_ : Q_HUD_CONTAINER
			button_ : Q_HUD_BUTTON
			label_ : Q_HUD_LABEL
		do
			create container_.make
			container_.set_bounds( 0, 1, 1, 1 )
			
			create label_.make
			label_.set_text( "Press Yes to quit now" )
			label_.set_bounds( 0.1, 0.4, 0.8, 0.1 )
			container_.add( label_ )
			
			create button_.make
			button_.set_text( "Yes" )
			button_.set_bounds( 0.2, 0.55, 0.3, 0.1 )
			container_.add( button_ )
			button_.actions.extend( agent exit( ?, ? ))
			
			create button_.make
			button_.set_text( "No" )
			button_.set_bounds( 0.6, 0.55, 0.3, 0.1 )
			container_.add( button_ )
			button_.actions.extend( agent goto_main_menu( ?, ? ))
			
			result := container_
		end
		
	
	create_option_menu is
		local
			menu_ : Q_HUD_BUTTON
			group_ : Q_HUD_SELECTABLE_BUTTON_GROUP
			label_1_, label_2_ : Q_HUD_LABEL
		do
			create option_menu.make
			
			create human_player_zero.make
			create human_player_one.make
			create human_player_two.make
			
			create menu_.make
			create group_.make
			
			create player_name_1.make
			create player_name_2.make
			
			create label_1_.make
			create label_2_.make
			
			group_.add( human_player_zero )
			group_.add( human_player_one )
			group_.add( human_player_two )
			
			human_player_two.set_selected( true )
			
			human_player_zero.set_text( "AI vs. AI" )
			human_player_one.set_text( "Human vs. AI" )
			human_player_two.set_text( "Human vs. Human" )
			
			label_1_.set_text( "Name Player 1" )
			label_2_.set_text( "Name Player 2" )
			
			menu_.set_text( "Return" )
			
			option_menu.add( human_player_zero )
			option_menu.add( human_player_one )
			option_menu.add( human_player_two )
			option_menu.add( label_1_ )
			option_menu.add( label_2_ )
			option_menu.add( player_name_1 )
			option_menu.add( player_name_2 )
			option_menu.add( menu_ )
			
			human_player_zero.set_bounds( 0.1, 0.1, 0.8, 0.08 )
			human_player_one.set_bounds( 0.1, 0.2, 0.8, 0.08 )
			human_player_two.set_bounds( 0.1, 0.3, 0.8, 0.08 )
			
			label_1_.set_bounds( 0.1, 0.5, 0.35, 0.08 )
			label_2_.set_bounds( 0.55, 0.5, 0.35, 0.08 )

			player_name_1.set_bounds( 0.1, 0.6, 0.35, 0.08 )
			player_name_2.set_bounds( 0.55, 0.6, 0.35, 0.08 )			
			
			menu_.set_bounds( 0.5, 0.8, 0.4, 0.08 )

			menu_.actions.extend( agent goto_main_menu( ?, ? ))
		end
		
		
	create_game_menu : Q_HUD_COMPONENT is
		local
			container_ : Q_HUD_CONTAINER
			button_ : Q_HUD_BUTTON
		do
			create container_.make
			create button_.make
			
			container_.set_bounds( 0, 0, 1, 1 )
			
			button_.set_text( "8 Ball" )
			button_.set_bounds( 0.1, 0.1, 0.8, 0.1 )
			container_.add( button_ )
			button_.actions.extend( agent start_8_ball( ?, ? ))
			
			create button_.make
			button_.set_bounds( 0.5, 0.8, 0.4, 0.1 )
			button_.set_text( "Return" )
			container_.add( button_ )
			button_.actions.extend( agent goto_main_menu( ?, ? ))
			
			result := container_
		end
		
	create_new_game_dialog : Q_HUD_COMPONENT is
		local
			container_ : Q_HUD_CONTAINER
			button_ : Q_HUD_BUTTON
			label_ : Q_HUD_LABEL
		do
			create container_.make
			container_.set_bounds( 0, 1, 1, 1 )
			
			create label_.make
			label_.set_text( "Press Yes to start a new game" )
			label_.set_bounds( 0.1, 0.4, 0.8, 0.1 )
			container_.add( label_ )
			
			create button_.make
			button_.set_text( "Yes" )
			button_.set_bounds( 0.2, 0.55, 0.3, 0.1 )
			container_.add( button_ )
			button_.actions.extend( agent goto_game_menu( ?, ? ))
			
			create button_.make
			button_.set_text( "No" )
			button_.set_bounds( 0.6, 0.55, 0.3, 0.1 )
			container_.add( button_ )
			button_.actions.extend( agent goto_main_menu( ?, ? ))
			
			result := container_
		end
		
		
	
feature{NONE} -- event-handling
	new_game( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			goto_new_game_dialog( command_, button_ )
		end
		
	option( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			menu.rotate_to( 2 )
		end

	help( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			
		end

	exit( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			if menu.rotated_to /= 1 or move_1.location.rounded /= 1 then
				goto_quit_dialog( command_, button_ )
			else
				ressources.logic.quit
			end
		end

	goto_quit_dialog( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			menu.rotate_to( 1 )
			move_1.move_to( 1 )
		end
		
	goto_game_menu( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			menu.rotate_to( 4 )
			move_4.move_to( 0 )
		end
		
	goto_new_game_dialog( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			menu.rotate_to( 4 )
			move_4.move_to( 1 )			
		end
		

	goto_main_menu( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			menu.rotate_to( 1 )
			move_1.move_to( 0 )
		end
		

	return_to_game( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			do_return := true
		end
		
feature{NONE} -- new games
	game_menu_armed : BOOLEAN is
			-- Tests, if the game-menu is visible
		do
			result := menu.rotated_to = 4 and move_4.location.rounded = 0
		end
		
		

	start_8_ball( command_ : STRING; button_ : Q_HUD_BUTTON ) is
			-- 
		do
			if game_menu_armed then
				-- create menu
				-- next_state := ...
			else
				goto_game_menu( command_, button_ )
			end
		end
		

end -- class Q_ESCAPE_STATE
