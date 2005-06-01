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
			
		end
		

feature
	install( ressources_: Q_GAME_RESSOURCES ) is
		do
			if main_menu = void then
				create_main_menu
			end
			ressources_.gl_manager.set_hud( main_menu )
		end

	uninstall( ressources_: Q_GAME_RESSOURCES ) is
		do
			ressources_.gl_manager.set_hud( void )
		end

	step( ressources_: Q_GAME_RESSOURCES ) is
		do
			-- nothing to calculate
		end

	next( ressources_: Q_GAME_RESSOURCES ): Q_GAME_STATE is
		do
		end

	identifier: STRING is
		do
			result := "escape"
		end
		
feature{NONE} -- menus
	main_menu, open_menu, game_menu : Q_HUD_CONTAINER
		-- the Menus
		
	return_button : Q_HUD_BUTTON
		-- only used, if the menu is called by a state from a game

	font : Q_HUD_FONT is
			-- 
		do
			result := create{Q_HUD_IMAGE_FONT}.make_standard( "Arial", 32, false, false )
		end
		

	create_main_menu is
		local
			game_, option_, help_, exit_ : Q_HUD_BUTTON
			font_ : Q_HUD_FONT
		do
			font_:= font
			
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
			exit_.actions.extend( agent exit( ?, ? ))
			return_button.actions.extend( agent return_to_game( ?, ? ))
			
			game_.set_text( "New Game" )
			option_.set_text( "Options" )
			help_.set_text( "Help" )
			exit_.set_text( "Exit" )
			return_button.set_text( "Return" )
			
			game_.set_bounds( 0.1, 0.1, 0.8, 0.1 )
			option_.set_bounds( 0.1, 0.25, 0.8, 0.1 )
			help_.set_bounds( 0.1, 0.4, 0.8, 0.1 )
			exit_.set_bounds( 0.1, 0.55, 0.8, 0.1 )
			return_button.set_bounds( 0.1, 0.7, 0.8, 0.1 )
		end
	
feature{NONE} -- event-handling
	new_game( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			
		end
		
	option( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			
		end

	help( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			
		end

	exit( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			
		end

	return_to_game( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			
		end

end -- class Q_ESCAPE_STATE
