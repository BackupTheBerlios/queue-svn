indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BEN_INGAME_MENU_TEST_STATE

inherit
	Q_GAME_STATE
	
feature
	menu : Q_2_INFO_HUD
	
	install (ressources_: Q_GAME_RESSOURCES) is
		local
			button_ : Q_HUD_BUTTON
		do
			create menu.make_ordered( true )
			menu.set_bounds( 0.05, 0.2, 0.9, 0.2 )
			ressources_.gl_manager.add_hud( menu )
			
			menu.set_big_left_text( "Beni" )
			menu.set_big_right_text( "Andy" )
			menu.set_small_left_text( "251" )
			menu.set_small_right_text( "250" )
			
			create button_.make
			button_.set_bounds( 0.1, 0.5, 0.4, 0.09 )
			button_.set_text( "Player A" )
			button_.actions.extend( agent player_a )
			ressources_.gl_manager.add_hud( button_ )
			
			create button_.make
			button_.set_bounds( 0.1, 0.6, 0.4, 0.09 )
			button_.set_text( "Player B" )
			button_.actions.extend( agent player_b )
			ressources_.gl_manager.add_hud( button_ )
			
			create button_.make
			button_.set_bounds( 0.1, 0.7, 0.4, 0.09 )
			button_.set_text( "No player" )
			button_.actions.extend( agent player_no )
			ressources_.gl_manager.add_hud( button_ )
		end
		
	player_a( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			menu.set_left_active
		end
		
	player_b( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			menu.set_right_active
		end
		
	player_no( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			menu.set_no_active
		end
	uninstall (ressources_: Q_GAME_RESSOURCES) is
		do
			
		end
		
	step (ressources_: Q_GAME_RESSOURCES) is
		do
			
		end
		
	next (ressources_: Q_GAME_RESSOURCES) : Q_GAME_STATE is
		do
			
		end

	identifier : STRING is "test"

end -- class BEN_INGAME_MENU_TEST_STATE
