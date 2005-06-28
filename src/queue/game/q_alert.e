indexing
	description: "Shows a message for a given duration"
	author: "Benjamin Sigg"

class
	Q_ALERT
inherit
	Q_HUD_ROTATING
	redefine
		draw, make
	end

creation
	make

feature{NONE}
	make is
		do
			precursor
			
			set_bounds( 0.1, -0.1, 0.8, 0.3 )
			
			create label.make
			label.set_size( 0.8, 0.09 )
			label.set_y( 0.2 )
			add( label )
			
			set_axis( create {Q_VECTOR_3D}.make( 0, 0, 1 ))
			set_duration( 2000 )
		end

feature
	draw( open_gl : Q_GL_DRAWABLE ) is
		do
			precursor( open_gl )
			if wait_alert then
				wait_alert := false			
			else
				time := time - open_gl.time.delta_time_millis
			end

			if time < duration and not disappearing then
				disappearing := true
				set_angle( math.pi+0.01 )
			end

			if time < 0 and ressources /= void then
				ressources.gl_manager.remove_hud( current )
				ressources := void
				disappearing := false
			end
		end
		
	display( ressources_ : Q_GAME_RESSOURCES; text_ : STRING ) is
		do
			display_timed( ressources_, text_, 9000 )
		end
		
	display_timed( ressources_ : Q_GAME_RESSOURCES; text_ : STRING; duration_ : INTEGER ) is
		do
			if ressources /= void then
				ressources.gl_manager.remove_hud( current )
				ressources := void
				disappearing := false
			end
			
			ressources := ressources_
			ressources.gl_manager.add_hud( current )
			
			label.set_text( text_ )
			time := duration_
			
			force_angle( math.pi-0.01 )
			set_angle ( 0 )
			wait_alert := true
		end
		
	remove_alert is
		do
			time := time.min( duration )
		end
	
	ensure_removed is
		-- removes this Q_ALERT
		do
			if ressources /= void then
				ressources.gl_manager.remove_hud( current )
				ressources := void
			end
		end
		
		
	
feature{NONE} -- implementation
	ressources : Q_GAME_RESSOURCES
	label : Q_HUD_LABEL
	time : INTEGER
	disappearing : BOOLEAN
	wait_alert : BOOLEAN

end -- class Q_HUD_ALERT
