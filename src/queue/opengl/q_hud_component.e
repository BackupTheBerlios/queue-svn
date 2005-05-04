indexing
	-- description: "[A HUD-Component is painted at the top of
	-- an OpenGL-Drawable. Always the z-Coordinates are 0 (the
	-- glVertex2d-Methods can directly be used), the 0/0 coordinates
	-- markes the bottom left of the window, the 1/1 coordinates
	-- the top right.]"
	author: "Benjamin Sigg"

deferred class
	Q_HUD_COMPONENT

	inherit 
		Q_GL_OBJECT

feature -- position and size
	x : DOUBLE
	y : DOUBLE
	width : DOUBLE
	height : DOUBLE
	
	set_x( x_ : DOUBLE ) is
		do
			x := x_
		end
		
	set_y( y_ : DOUBLE ) is
		do
			y := y_
		end
		
	set_width( width_ : DOUBLE ) is
		do
			width := width_
		end
		
	set_height( height_ : DOUBLE ) is
		do
			height := height_
		end

end -- class Q_HUD_COMPONENT
