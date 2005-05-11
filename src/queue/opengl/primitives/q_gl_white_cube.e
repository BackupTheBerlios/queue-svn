indexing
	description: "A white cube"
	author: "Benjamin Sigg"

class
	Q_GL_WHITE_CUBE

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
	resolution : INTEGER is 20

	draw( open_gl : Q_GL_DRAWABLE ) is
		local
			gl_ : GL_FUNCTIONS
			delta_ : DOUBLE
		do
			gl_ := open_gl.gl
			delta_ := size/2
			
			gl_.gl_color3f( 1, 1, 1 )

			-- side 1
			gl_.gl_normal3f( 1, 0, 0 )
			
			draw_side(
				x+delta_, y+delta_, z+delta_,
				x+delta_, y+delta_, z-delta_,
				x+delta_, y-delta_, z-delta_,
				x+delta_, y-delta_, z+delta_,
				resolution, open_gl )
			
			-- side 2
			gl_.gl_normal3f( -1, 0, 0 )
			
			draw_side(
				x-delta_, y+delta_, z+delta_,
				x-delta_, y+delta_, z-delta_,
				x-delta_, y-delta_, z-delta_,
				x-delta_, y-delta_, z+delta_,
				resolution, open_gl )
			
			-- side 3
			gl_.gl_normal3f( 0, 1, 0 )
			
			draw_side(
				x+delta_, y+delta_, z+delta_,
				x+delta_, y+delta_, z-delta_,
				x-delta_, y+delta_, z-delta_,
				x-delta_, y+delta_, z+delta_,
				resolution, open_gl )

			
			-- side 4
			gl_.gl_normal3f( 0, -1, 0 )

			draw_side( 
				x+delta_, y-delta_, z+delta_,
				x+delta_, y-delta_, z-delta_,
				x-delta_, y-delta_, z-delta_,
				x-delta_, y-delta_, z+delta_,
				resolution, open_gl )
			
			-- side 5
			gl_.gl_normal3f( 0, 0, 1 )

			draw_side( 
				x+delta_, y+delta_, z+delta_,
				x-delta_, y+delta_, z+delta_,
				x-delta_, y-delta_, z+delta_,
				x+delta_, y-delta_, z+delta_,
				resolution, open_gl )
			
			-- side 6
			gl_.gl_normal3f( 0, 0, 1 )
			
			draw_side( 
				x+delta_, y+delta_, z-delta_,
				x-delta_, y+delta_, z-delta_,
				x-delta_, y-delta_, z-delta_,
				x+delta_, y-delta_, z-delta_,
				resolution, open_gl )
			
			gl_.gl_end
		end

feature {NONE}
	draw_side( x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4 : DOUBLE; resolution_ : INTEGER; open_gl : Q_GL_DRAWABLE ) is
		local
			a, b : INTEGER
			gl_ : GL_FUNCTIONS
		do
			gl_ := open_gl.gl
			gl_.gl_begin( open_gl.gl_constants.esdl_gl_quads )
								
			from a := 0 until a >= resolution_ loop
				from b := 0 until b >= resolution_ loop
					gl_.gl_vertex3d( 
						between_large( x1, x2, x4, x3, a/resolution_, b/resolution_ ),
						between_large( y1, y2, y4, y3, a/resolution_, b/resolution_ ),
						between_large( z1, z2, z4, z3, a/resolution_, b/resolution_ ) )
						
					gl_.gl_vertex3d( 
						between_large( x1, x2, x4, x3, (a+1)/resolution_, b/resolution_ ),
						between_large( y1, y2, y4, y3, (a+1)/resolution_, b/resolution_ ),
						between_large( z1, z2, z4, z3, (a+1)/resolution_, b/resolution_ ) )
						
					gl_.gl_vertex3d( 
						between_large( x1, x2, x4, x3, (a+1)/resolution_, (b+1)/resolution_ ),
						between_large( y1, y2, y4, y3, (a+1)/resolution_, (b+1)/resolution_ ),
						between_large( z1, z2, z4, z3, (a+1)/resolution_, (b+1)/resolution_ ) )
						
					gl_.gl_vertex3d( 
						between_large( x1, x2, x4, x3, a/resolution_, (b+1)/resolution_ ),
						between_large( y1, y2, y4, y3, a/resolution_, (b+1)/resolution_ ),
						between_large( z1, z2, z4, z3, a/resolution_, (b+1)/resolution_ ) )

					b := b+1
				end
				a := a+1
			end
			
			gl_.gl_end
		end
		
	between_large( a_, b_, c_, d_, x_, y_ : DOUBLE ) : DOUBLE is
		do
			result := between( between( a_, b_, x_ ), between( c_, d_, x_ ), y_ )
		end
		
		
	between( a_, b_, x_ : DOUBLE ) : DOUBLE is
		do
			result := a_*x_ + b_*(1 - x_)
		end

end -- class Q_GL_WHITE_CUBE
