indexing
	description: "Paints a text on the screen, with a background"
	author: "Benjamin Sigg"
	revision: "1.0"

class
	Q_HUD_LABEL

inherit
	Q_HUD_TEXTED


creation
	make
	
feature {NONE} -- creation
	make is
		do
			default_create
			set_alignement_x( 0.0 )
			set_alignement_y( 0.5 )
			set_background( create {Q_GL_COLOR}.make_gray )
		end
		
feature -- interface
	draw (open_gl: Q_GL_DRAWABLE) is
		do			
			draw_background( open_gl )
			draw_foreground( open_gl )
		end
	
feature {Q_HUD_LABEL} -- drawing
	draw_background( open_gl : Q_GL_DRAWABLE ) is
		do
			if background /= void then
				background.set( open_gl )

				open_gl.gl.gl_begin( open_gl.gl_constants.esdl_gl_quads )
				open_gl.gl.gl_vertex2d( 0, 0 )
				open_gl.gl.gl_vertex2d( width, 0 )
				open_gl.gl.gl_vertex2d( width, height )
				open_gl.gl.gl_vertex2d( 0, height )
				open_gl.gl.gl_end		
			end
		end		
	
feature -- values		
	background : Q_GL_COLOR
		
	set_background( background_ : Q_GL_COLOR ) is
			-- Sets the background-color of this label. A value of
			-- void means, that no background should be painted
		do
			background := background_
		end
		
		
end -- class Q_HUD_LABEL
