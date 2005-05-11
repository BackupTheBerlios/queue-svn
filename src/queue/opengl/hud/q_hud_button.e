indexing
	description: "A button showed on the screen. Can be pressed by the mouse"
	author: "Benjamin Sigg"

class
	Q_HUD_BUTTON

inherit
	Q_HUD_TEXTED
	redefine
		process_mouse_button_down,
		process_mouse_button_up,
		process_mouse_enter,
		process_mouse_exit,
		process_key_down,
		process_component_removed,
		draw_text
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
			set_font_color( create {Q_GL_COLOR}.make_black )
			
			set_alignement_x( 0.5 )
			set_alignement_y( 0.5 )
			
			create background_normal.make_orange
			create background_pressed.make_red
			create background_rollover.make_yellow
			create focus_border.make_black
		end
		

feature -- drawing
	background_normal, background_pressed, background_rollover, focus_border : Q_GL_COLOR
	
	draw( open_gl : Q_GL_DRAWABLE ) is
		do
			draw_background( open_gl )
			draw_foreground( open_gl )
		end
		
	
	draw_text( text_ : STRING; x_, base_, ascent_, descent_ : DOUBLE; open_gl : Q_GL_DRAWABLE ) is
		local
			bx_, by_, bw_, bh_ : DOUBLE
		do
			precursor( text_, x_, base_, ascent_, descent_, open_gl )
			if focused then
				focus_border.set( open_gl )
				
				bx_ := x_ - font_size / 10
				by_ := base_ - ascent_ - font_size / 10
				bw_ := font_size / 5 + font.string_width( text_, font_size )
				bh_ := font_size / 5 + ascent_ + descent_
				
				if bx_ < 0 then bx_ := 0 end
				if by_ < 0 then by_ := 0 end
				
				if bw_ > width then
					bw_ := width
					bx_ := 0
				end
				
				if bh_ > height then
					bh_ := height
					by_ := 0
				end
				
				open_gl.gl.gl_begin( open_gl.gl_constants.esdl_gl_line_loop )
				
				open_gl.gl.gl_vertex2d( bx_, by_ )
				open_gl.gl.gl_vertex2d( bx_, by_ + bh_ )
				open_gl.gl.gl_vertex2d( bx_ + bw_, by_ + bh_ )
				open_gl.gl.gl_vertex2d( bx_ + bw_, by_ )
				
				open_gl.gl.gl_end
			end
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
