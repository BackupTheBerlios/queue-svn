indexing
	description: "A button showed on the screen. Can be pressed by the mouse"
	author: "Benjamin Sigg"

class
	Q_HUD_BUTTON

inherit
	Q_HUD_TEXTED
	rename
		background as background_normal,
		set_background as set_background_normal
	redefine
		process_mouse_button_down,
		process_mouse_button_up,
		process_mouse_enter,
		process_mouse_exit,
		process_key_down,
		process_component_removed,
		draw_background
	end
	
creation
	make

feature {NONE} -- creation
	make is
		do
			default_create
			
			create actions	
			set_focusable( true )
			set_enabled( true )
			set_command( "no command" )
			
			set_alignement_x( 0.5 )
			set_alignement_y( 0.5 )

			set_background_normal( create {Q_GL_COLOR}.make_orange )	
			set_background_pressed( create {Q_GL_COLOR}.make_red )
			set_background_rollover( create {Q_GL_COLOR}.make_yellow )
		end
		

feature -- drawing
	background_pressed, background_rollover : Q_GL_COLOR
		
	set_background_pressed( color_ : Q_GL_COLOR ) is
		require
			color_not_void : color_ /= void
		do
			background_pressed := color_
		end
		
	set_background_rollover( color_ : Q_GL_COLOR ) is
		require
			color_not_void : color_ /= void
		do
			background_rollover := color_
		end
		
	draw_background( open_gl : Q_GL_DRAWABLE ) is
		do
			if pressed then
				background_pressed.set( open_gl )
			elseif mouse_over then
				background_rollover.set( open_gl )
			else
				background_normal.set( open_gl )
			end
			
			open_gl.gl.gl_begin( open_gl.gl_constants.esdl_gl_quads )
			open_gl.gl.gl_vertex2d( 0, 0 )
			open_gl.gl.gl_vertex2d( width, 0 )
			open_gl.gl.gl_vertex2d( width, height )
			open_gl.gl.gl_vertex2d( 0, height )
			open_gl.gl.gl_end
		end
		

feature -- eventhandling
	pressed, mouse_over : BOOLEAN
	
	actions : EVENT_TYPE[ TUPLE[ STRING, Q_HUD_BUTTON ] ] 
	
	command : STRING
	
	set_command( command_ : STRING ) is
			-- Sets the command of this button
		do
			command := command_
		end
		
	
	do_click is
			-- calls a click on all known agents
		do
			from
				actions.start
			until
				actions.after
			loop
				actions.item.call( [command, current] )
				actions.forth
			end
		end
		
	process_component_removed( parent_ : Q_HUD_CONTAINER ) is
		do
			pressed := false
			mouse_over := false
		end
	
	process_mouse_button_down( event_ : ESDL_MOUSEBUTTON_EVENT; x_, y_ : DOUBLE ) : BOOLEAN is
		do
			pressed := true
			result := true
		end
		
	process_mouse_button_up( event_ : ESDL_MOUSEBUTTON_EVENT; x_, y_ : DOUBLE ) : BOOLEAN is
		do
			if pressed then
				pressed := false
				
				if inside( x_, y_ ) then
					do_click
				end
			end
		end
		
	process_mouse_enter( x_, y_ : DOUBLE ) is
		do
			mouse_over := true
		end
		
	process_mouse_exit( x_, y_ : DOUBLE ) is
		do
			mouse_over := false
		end
		
	process_key_down( event_ : ESDL_KEYBOARD_EVENT ) : BOOLEAN is
		do
			if event_.key = event_.sdlk_return then
				do_click
				result := true
			else
				result := false
			end
		end
		

end -- class Q_HUD_BUTTON
