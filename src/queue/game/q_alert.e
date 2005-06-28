indexing
	description: "Shows a message for a given duration"
	author: "Benjamin Sigg"

class
	Q_ALERT
inherit
	Q_HUD_LABEL
	redefine
		draw, make
	end

creation
	make

feature{NONE}
	make is
		do
			precursor
			
			set_bounds( 0.1, 0.1, 0.8, 0.09 )
		end

feature
	draw( open_gl : Q_GL_DRAWABLE ) is
		do
			precursor( open_gl )
			time := time - open_gl.time.delta_time_millis
			if time < 0 and ressources /= void then
				ressources.gl_manager.remove_hud( current )
				ressources := void
			end
		end
		
	display( ressources_ : Q_GAME_RESSOURCES; text_ : STRING ) is
		do
			display_timed( ressources_, text_, 5000 )
		end
		
	display_timed( ressources_ : Q_GAME_RESSOURCES; text_ : STRING; duration_ : INTEGER ) is
		do
			if ressources /= void then
				ressources.gl_manager.remove_hud( current )
				ressources := void
			end
			
			ressources := ressources_
			ressources.gl_manager.add_hud( current )
			
			set_text( text_ )
			time := duration_
		end
		
	ensure_removed is
		do
			if ressources = void then
				ressources.gl_manager.remove_hud( current )
				ressources := void
			end
		end
		
		
	
feature{NONE} -- implementation
	ressources : Q_GAME_RESSOURCES
	
	time : INTEGER

end -- class Q_HUD_ALERT
