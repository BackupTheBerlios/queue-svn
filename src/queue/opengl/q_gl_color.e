indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_GL_COLOR

creation
	make, make_rgb, make_rgba,
	make_red, make_green, make_blue, make_yellow,
	make_magenta, make_cyan, make_black, make_white,
	make_orange, make_gray

feature -- public creation
	make is
			-- Creats a black color-version
		do
			
		end
	
	make_rgb( red_, green_, blue_ : DOUBLE ) is
		do
			make_rgba( red_, green_, blue_, 1 )
		end
		
	make_rgba( red_, green_, blue_, alpha_ : DOUBLE ) is
		do
			set_red( red_ )
			set_green( green_ )
			set_blue( blue_ )
			set_alpha( alpha_ )
		end
		
	make_red is
		do
			make_rgb( 1, 0, 0 )
		end

	make_green is
		do
			make_rgb( 0, 1, 0 )
		end

	make_blue is
		do
			make_rgb( 0, 0, 1 )
		end

	make_yellow is
		do
			make_rgb( 1, 1, 0 )
		end

	make_magenta is
		do
			make_rgb( 1, 0, 1 )
		end
		
	make_cyan is
		do
			make_rgb( 0, 1, 1 )
		end
		
	make_black is
		do
			make_rgb( 0, 0, 0 )
		end
		
	make_white is
		do
			make_rgb( 1, 1, 1 )
		end
		
	make_orange is
		do
			make_rgb( 0.5, 0.5, 0 )
		end
		
	make_gray is
		do
			make_rgb( 0.5, 0.5, 0.5 )
		end
		

feature -- The color-values
	red, green, blue, alpha : DOUBLE
	
	set_red( red_ : DOUBLE ) is
		do
			red := red_
		end

	set_green( green_ : DOUBLE ) is
		do
			green := green_
		end
		
	set_blue( blue_ : DOUBLE ) is
		do
			blue := blue_
		end
		
	set_alpha( alpha_ : DOUBLE ) is
		do
			alpha := alpha_
		end
	
	set( open_gl : Q_GL_DRAWABLE ) is
			-- Applies this color to the drawable
		require
			open_gl_not_void : open_gl /= void
		do
			open_gl.gl.gl_color4d( red, green, blue, alpha )
		end
		

invariant
	invariant_clause: True -- Your invariant here

end -- class Q_GL_COLOR
