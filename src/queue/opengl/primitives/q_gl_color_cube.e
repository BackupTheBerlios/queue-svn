--
--  queue
--
--  Copyright (C) 2005  
--  Basil Fierz, Severin Hacker, Andreas Kaegi, Benjamin Sigg
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU Library General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
--

indexing
	description: "A colored cube"
	author: "Benjamin Sigg"

class
	Q_GL_COLOR_CUBE

inherit
	Q_GL_OBJECT

creation
	make,
	make_sized,
	make_positioned,
	make_positioned_and_sized

feature -- constructors
	make is
		do
			make_positioned( 0, 0, 0 )
		end
		

	make_sized( size_ : DOUBLE ) is
		do
			make_positioned_and_sized( 0, 0, 0, size_ )
		end
		
	make_positioned( x_, y_, z_ : DOUBLE ) is
		do
			make_positioned_and_sized( x_, y_, z_, 10.0 )
		end
	
	make_positioned_and_sized( x_, y_, z_, size_ : DOUBLE ) is
		do
			set_x( x_ )
			set_y( y_ )
			set_z( z_ )
			set_size( size_ )
		end

feature -- position, size
	x, y, z, size : DOUBLE
	
	set_x( x_ : DOUBLE ) is
		do
			x := x_
		end
		
	set_y( y_ : DOUBLE ) is
		do
			y := y_
		end
		
	set_z( z_ : DOUBLE ) is
		do
			z := z_
		end
		
	set_size( size_ : DOUBLE ) is
		do
			size := size_
		end
		
feature -- visualisation
	draw( open_gl : Q_GL_DRAWABLE ) is
		local
			gl_ : GL_FUNCTIONS
			delta_ : DOUBLE
		do
			gl_ := open_gl.gl
			delta_ := size/2
			
			-- side 1
			gl_.gl_color3f( 1, 0, 0 )
			gl_.gl_normal3f( 1, 0, 0 )
			
			gl_.gl_begin( open_gl.gl_constants.esdl_gl_quads )
			gl_.gl_vertex3d( x+delta_, y+delta_, z+delta_ )
			gl_.gl_vertex3d( x+delta_, y+delta_, z-delta_ )
			gl_.gl_vertex3d( x+delta_, y-delta_, z-delta_ )
			gl_.gl_vertex3d( x+delta_, y-delta_, z+delta_ )
			gl_.gl_end
			
			-- side 2
			gl_.gl_color3f( 0, 1, 0 )
			gl_.gl_normal3f( -1, 0, 0 )
			
			gl_.gl_begin( open_gl.gl_constants.esdl_gl_quads )
			gl_.gl_vertex3d( x-delta_, y+delta_, z+delta_ )
			gl_.gl_vertex3d( x-delta_, y+delta_, z-delta_ )
			gl_.gl_vertex3d( x-delta_, y-delta_, z-delta_ )
			gl_.gl_vertex3d( x-delta_, y-delta_, z+delta_ )
			gl_.gl_end
			
			-- side 3
			gl_.gl_color3f( 0, 0, 1 )
			gl_.gl_normal3f( 0, 1, 0 )
			
			gl_.gl_begin( open_gl.gl_constants.esdl_gl_quads )
			gl_.gl_vertex3d( x+delta_, y+delta_, z+delta_ )
			gl_.gl_vertex3d( x+delta_, y+delta_, z-delta_ )
			gl_.gl_vertex3d( x-delta_, y+delta_, z-delta_ )
			gl_.gl_vertex3d( x-delta_, y+delta_, z+delta_ )
			gl_.gl_end
			
			-- side 4
			gl_.gl_color3f( 0, 1, 1 )
			gl_.gl_normal3f( 0, -1, 0 )
			
			gl_.gl_begin( open_gl.gl_constants.esdl_gl_quads )
			gl_.gl_vertex3d( x+delta_, y-delta_, z+delta_ )
			gl_.gl_vertex3d( x+delta_, y-delta_, z-delta_ )
			gl_.gl_vertex3d( x-delta_, y-delta_, z-delta_ )
			gl_.gl_vertex3d( x-delta_, y-delta_, z+delta_ )
			gl_.gl_end
			
			-- side 5
			gl_.gl_color3f( 1, 0, 1 )
			gl_.gl_normal3f( 0, 0, 1 )
			
			gl_.gl_begin( open_gl.gl_constants.esdl_gl_quads )
			gl_.gl_vertex3d( x+delta_, y+delta_, z+delta_ )
			gl_.gl_vertex3d( x-delta_, y+delta_, z+delta_ )
			gl_.gl_vertex3d( x-delta_, y-delta_, z+delta_ )
			gl_.gl_vertex3d( x+delta_, y-delta_, z+delta_ )
			gl_.gl_end
			
			-- side 6
			gl_.gl_color3f( 1, 1, 0 )
			gl_.gl_normal3f( 0, 0, 1 )
			
			gl_.gl_begin( open_gl.gl_constants.esdl_gl_quads )
			gl_.gl_vertex3d( x+delta_, y+delta_, z-delta_ )
			gl_.gl_vertex3d( x-delta_, y+delta_, z-delta_ )
			gl_.gl_vertex3d( x-delta_, y-delta_, z-delta_ )
			gl_.gl_vertex3d( x+delta_, y-delta_, z-delta_ )
			gl_.gl_end
		end
end -- class Q_GL_COLOR_CUBE
