indexing
	description: "A component reacting on the mouse by using a special background if the mouse enters, or the mouse is pressed"
	author: "Benjamin Sigg"

deferred class
	Q_HUD_MOUSE_SENSITIVE_COMPONENT

inherit
	Q_HUD_COMPONENT
	rename
		background as background_normal,
		set_background as set_background_normal
	redefine
		process_mouse_button_down,
		process_mouse_button_up,
		process_mouse_enter,
		process_mouse_exit,
		process_component_removed,
		draw_background
	end
	
feature{Q_HUD_MOUSE_SENSITIVE_COMPONENT} -- event-handling
	pressed, mouse_over : BOOLEAN

	do_click() is
			-- called, when the mouse was pressed and is not realeased inside the component
		deferred
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

end -- class Q_HUD_MOUSE_SENSITIVE_COMPONENT
