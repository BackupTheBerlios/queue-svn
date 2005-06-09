indexing
	description: "Shows a text to the user. When the user presses the ok-button, the next state will be shown"
	author: "Benjamin Sigg"

class
	Q_8BALL_INFO_STATE

inherit
	Q_INFO_STATE
	redefine
		install, uninstall
	end
	
creation
	make_mode
	
feature{NONE}
	make_mode( mode_ : Q_8BALL; right_to_left_ : BOOLEAN; identifier_ : STRING ) is
		do
			make_positioned( right_to_left_, true, identifier_ )
			mode := mode_
		end

	mode : Q_8BALL
	
feature
	install( ressources_ : Q_GAME_RESSOURCES ) is
		do
			precursor( ressources_ )
			ressources_.gl_manager.add_hud( mode.info_hud )
		end
	
	uninstall( ressources_ : Q_GAME_RESSOURCES ) is
		do
			precursor( ressources_ )
			ressources_.gl_manager.remove_hud( mode.info_hud )
		end

end -- class Q_8BALL_INFO_STATE
