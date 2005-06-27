indexing
	description: "Displays a ball in the hud"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_HUD_BALL

inherit
	Q_HUD_COMPONENT
	redefine
		draw_foreground, make, set_width, set_height
	end
	
creation
	make
	
feature{NONE}
	make is
		do
			precursor
			set_focusable( false )
			set_enabled( true )
			set_background( void )
			create axis.make( 0, 1, 0 )
		end
		
	
feature -- draw
	visible : BOOLEAN is
		do
			result := true
		end
		

	draw_foreground( open_gl : Q_GL_DRAWABLE ) is
		local
			visible_ : BOOLEAN
		do
			if ball /= void then
				ball.set_position( create {Q_VECTOR_3D} )
				open_gl.gl.gl_enable( open_gl.gl_constants.esdl_gl_depth_test )
				open_gl.gl.gl_push_matrix

				open_gl.gl.gl_scaled( scale, scale, scale )
				open_gl.gl.gl_translated( width/2/scale, 0, 0 )
				
				visible_ := ball.visible
				ball.set_visible ( true )
				ball.draw ( open_gl )
				ball.set_visible( visible_ )
				
				ball.add_rotation( axis, open_gl.time.delta_time_millis * 3.14 / 2000 )
				
				open_gl.gl.gl_pop_matrix
				open_gl.gl.gl_disable( open_gl.gl_constants.esdl_gl_depth_test )
			end
		end
		
feature{NONE}
	axis : Q_VECTOR_3D
	scale : DOUBLE

	update is
		do
			if( ball /= void )then
				scale := (width / ball.radius).min( height / ball.radius ) / 2
			end
		end
		

feature -- position
	set_width( width_ : DOUBLE ) is
		do
			precursor( width_ )
			update
		end
		
	set_height( height_ : DOUBLE ) is
		do
			precursor( height_ )
			update
		end		
		
feature -- ball
	ball : Q_BALL_MODEL
	
	set_ball( ball_ : Q_BALL_MODEL ) is
		do
			ball := ball_
			
			if ball /= void then
				ball.set_position( create {Q_VECTOR_3D}.make( 0, 0, 0 ))
				update
			end
		end
		
	
end -- class Q_HUD_BALL
