indexing
	description: "A slider allows the user to choose a value between a minimum and a maximum"
	author: "Benjamin Sigg"

class
	Q_HUD_SLIDER

inherit
	Q_HUD_COMPONENT
	redefine
		make, 
		draw_background
	end
	
creation
	make
	
feature{NONE}--creation
	make is
		do
			precursor
			
			set_focusable( false )
			set_foreground( create {Q_GL_COLOR}.make_magenta )
			set_background( create {Q_GL_COLOR}.make_magenta )
			
			mouse_button_up_listener.extend( agent mouse_button_up( ?,?,?,?,? ))
			mouse_button_down_listener.extend( agent mouse_button_down( ?,?,?,?,? ))
			mouse_moved_listener.extend( agent mouse_moved( ?,?,?,?,? ))
		end
		
feature
	visible : BOOLEAN is
		do
			result := true
		end


feature -- drawing
	border : DOUBLE is
		do
			result := 0.1 * width.min( height )
		end
		

	draw_foreground( open_gl : Q_GL_DRAWABLE ) is
		do
			if foreground /= void then
				if blend_background then
					open_gl.gl.gl_enable( open_gl.gl_constants.esdl_gl_blend )
					open_gl.gl.gl_blend_func( 
						open_gl.gl_constants.esdl_gl_src_alpha,
						open_gl.gl_constants.esdl_gl_one_minus_src_alpha )
				end
				
				foreground.set( open_gl )
				open_gl.gl.gl_rectd( border, border, 
					value_to_screen( value ), height - border )
					
				if blend_background then
					open_gl.gl.gl_disable( open_gl.gl_constants.esdl_gl_blend )
				end
			end
		end
		
	draw_background( open_gl: Q_GL_DRAWABLE ) is
		do
			if background /= void then
				open_gl.gl.gl_begin( open_gl.gl_constants.esdl_gl_line_loop )
				background.set( open_gl ) 
				
				open_gl.gl.gl_vertex2d( 0, 0 )
				open_gl.gl.gl_vertex2d( width, 0 )
				open_gl.gl.gl_vertex2d( width, height )
				open_gl.gl.gl_vertex2d( 0, height )
			
				open_gl.gl.gl_end				
			end
		end
		
feature -- calclations
	value_to_screen( value_ : DOUBLE ) : DOUBLE is
			-- Calculates, where the given value would be on the screen
			-- The result is a value between 0.1 * width and 0.9 * width,
			-- if 'value_' is between minimum and maximum
		do
			if minimum = maximum then
				result := 0.5
			else
				result := (value_ - minimum) / (maximum - minimum)
			end
			
			result := border + result * ( width - 2*border )
		end

	screen_to_value( screen_ : DOUBLE ) : DOUBLE is
			-- The inverse of value_to_screen
		do
			if minimum = maximum then
				result := minimum
			else
				result := (screen_ - border) / ( width - 2*border )
				result := result * (maximum - minimum) + minimum
			end
			
			if result < minimum then
				result := minimum
			elseif result > maximum then
				result := maximum
			end
		end
		

feature -- event - handling
	mouse_pressed : BOOLEAN

	mouse_button_down( event_: ESDL_MOUSEBUTTON_EVENT; x_: DOUBLE; y_: DOUBLE; map_ : Q_KEY_MAP; consumed_ : BOOLEAN ) : BOOLEAN is
		do
			if not consumed_ then
				mouse_pressed := true
				set_value( screen_to_value( x_ ))
				result := true
			end
		end
		
	mouse_button_up( event_: ESDL_MOUSEBUTTON_EVENT; x_: DOUBLE; y_: DOUBLE; map_ : Q_KEY_MAP; consumed_ : BOOLEAN ) : BOOLEAN is
		do
			if not consumed_ then
				mouse_pressed := false
				result := false
			end
		end
	
	mouse_moved( event_: ESDL_MOUSEMOTION_EVENT; x_: DOUBLE; y_: DOUBLE; map_ : Q_KEY_MAP; consumed_ : BOOLEAN ) : BOOLEAN is
		do
			if not consumed_ then		
				if mouse_pressed then
					set_value( screen_to_value( x_ ))
					result := true
				else
					result := false
				end
			end
		end
		

feature -- values
	minimum, maximum : DOUBLE
	value : DOUBLE
	
	set_minimum( minimum_ : DOUBLE ) is
		require
			minimum_ < maximum
		do
			minimum := minimum_
		end
	
	set_maximum( maximum_ : DOUBLE ) is
		require
			maximum_ > minimum
		do
			maximum := maximum_
		end
	
	set_min_max( minimum_, maximum_ : DOUBLE ) is
		require
			minimum_ < maximum_
		do
			minimum := minimum_
			maximum := maximum_
		end
		
	set_value( value_ : DOUBLE ) is
		require
			minimum <= value_
			maximum >= value_
		do
			value := value_
		end

end -- class Q_HUD_SLIDER
