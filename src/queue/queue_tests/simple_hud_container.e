indexing
	description: "A container with a background color, but no spezial abilities"

class
	SIMPLE_HUD_CONTAINER

inherit
	Q_HUD_CONTAINER
	redefine
		draw
	end

creation
	make_color
	
feature
	make_color( red_, green_, blue_ : DOUBLE ) is
		do
			default_create
			make
			create color.make_rgb( red_, green_, blue_ )
		end
		
	draw( open_gl : Q_GL_DRAWABLE ) is
		do

			open_gl.gl.gl_begin( open_gl.gl_constants.esdl_gl_quads )
			color.set( open_gl )
			
			open_gl.gl.gl_vertex2d( 0, 0 )
			open_gl.gl.gl_vertex2d( 0, height )
			open_gl.gl.gl_vertex2d( width, height )
			open_gl.gl.gl_vertex2d( width, 0 )			
			
			open_gl.gl.gl_end
			
			precursor( open_gl )
		end
		

feature
	color : Q_GL_COLOR

end -- class SIMPLE_HUD_CONTAINER
