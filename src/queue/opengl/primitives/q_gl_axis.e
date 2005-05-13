indexing
	description: "A simple implementation of 3 Axis. x=red, y=green, z=blue. The size of each axis is 1, the center at point 0/0/0"
	author: "Benjamin Sigg"

class
	Q_GL_AXIS

inherit
	Q_GL_OBJECT

feature
	draw( open_gl : Q_GL_DRAWABLE ) is
		local
			gl : GL_FUNCTIONS
		do
			gl := open_gl.gl
			
			gl.gl_begin( open_gl.gl_constants.esdl_gl_lines )

			-- x
			gl.gl_color3f( 1, 0, 0 )
			
			gl.gl_vertex3d( 0, 0, 0 )
			gl.gl_vertex3d( 1, 0, 0 )
			
			gl.gl_vertex3d( 1, 0, 0 )
			gl.gl_vertex3d( 0.75, 0, 0.25 )
			
			gl.gl_vertex3d( 1, 0, 0 )
			gl.gl_vertex3d( 0.75, 0, -0.25 )
			
			-- y
			gl.gl_color3f( 0, 1, 0 )
			
			gl.gl_vertex3d( 0, 0, 0 )
			gl.gl_vertex3d( 0, 1, 0 )
			
			gl.gl_vertex3d( 0, 1, 0 )
			gl.gl_vertex3d( 0.25, 0.75, 0 )
			
			gl.gl_vertex3d( 0, 1, 0 )
			gl.gl_vertex3d( -0.25, 0.75, 0 )			
			
			-- z
			gl.gl_color3f( 0, 0, 1 )
			
			gl.gl_vertex3d( 0, 0, 0 )
			gl.gl_vertex3d( 0, 0, 1 )
			
			gl.gl_vertex3d( 0, 0, 1 )
			gl.gl_vertex3d( 0.25, 0, 0.75 )
			
			gl.gl_vertex3d( 0, 0, 1 )
			gl.gl_vertex3d( -0.25, 0, 0.75 )
			
			gl.gl_end
		end
		

end -- class Q_GL_AXIS
