indexing
	description: "This choice-menu also shows the info-menu of a 8-Ball-Mode"
	author: "Benjamin Sigg"

class
	Q_ETH_CHOICE_STATE

inherit
	Q_CHOICE_STATE
	redefine
		install, uninstall
	end
	
creation
	make_mode, make_mode_titled
	
feature{NONE} -- creation	
	make_mode( mode_ : Q_ETH; identifier_ : STRING; count_ : INTEGER ) is
		do
			make( identifier_, count_, true )
			mode := mode_
		end

	make_mode_titled( mode_ : Q_ETH; title_, identifier_ : STRING; count_ : INTEGER ) is
		do
			make_titled( title_, identifier_, count_, true )
			mode := mode_
		end
		
feature
	mode : Q_ETH
	
	set_mode( mode_ : Q_ETH ) is
		do
			mode := mode_
		end
		
	install( ressources_ : Q_GAME_RESSOURCES ) is
		do
			precursor( ressources_ )
			ressources_.gl_manager.add_hud( mode.time_info_hud )
		end
		
	uninstall( ressources_ : Q_GAME_RESSOURCES ) is
		do
			precursor( ressources_ )
			ressources_.gl_manager.remove_hud( mode.time_info_hud )
		end

end -- class Q_8BALL_CHOICE_STATE
