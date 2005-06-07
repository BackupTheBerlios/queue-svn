indexing
	description: "An object that draws a simple cross (a line for each direction)"
	author: "Benjamin Sigg"

class
	Q_GL_CROSS

inherit
	Q_GL_OBJECT

creation
	make
	
feature{NONE} -- creation
	make( position_ : Q_VECTOR_3D; color_ : Q_GL_COLOR; size_ : DOUBLE ) is
		do
			set_position( position_ )
			set_color( color_ )
			set_size( size_ )
		end
		
feature -- draw
	draw( open_gl : Q_GL_DRAWABLE ) is
		do
			open_gl.gl.gl_disable( open_gl.gl_constants.esdl_gl_lighting )
			
			open_gl.gl.gl_begin( open_gl.gl_constants.esdl_gl_lines )
			color.set( open_gl )
			
			open_gl.gl.gl_vertex3d( position.x-size, position.y, position.z )
			open_gl.gl.gl_vertex3d( position.x+size, position.y, position.z )

			open_gl.gl.gl_vertex3d( position.x, position.y+size, position.z )
			open_gl.gl.gl_vertex3d( position.x, position.y-size, position.z )
			
			open_gl.gl.gl_vertex3d( position.x, position.y, position.z+size )
			open_gl.gl.gl_vertex3d( position.x, position.y, position.z-size )			
			
			open_gl.gl.gl_end
			
			open_gl.gl.gl_enable( open_gl.gl_constants.esdl_gl_lighting )
		end
		

feature -- position and size
	position : Q_VECTOR_3D
	color : Q_GL_COLOR
	size : DOUBLE
	
	set_position( position_ : Q_VECTOR_3D ) is
		require
			position_ /= void
		do
			position := position_
		end
		
	set_color( color_ : Q_GL_COLOR ) is
		require
			color_ /= void
		do
			color := color_
		end

	set_size( size_ : DOUBLE ) is
		do
			size := size_
		end
	
end -- class Q_GL_CROSS
