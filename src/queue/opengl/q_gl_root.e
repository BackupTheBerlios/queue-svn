indexing
	description: "Root of the Queue-OpenGL-Part. Thats not the Scene, put all OpenGL-Parts are managed from this class"
	author: "Benjamin Sigg"

class
	Q_GL_ROOT

creation
	init,
	init_lighting

feature{NONE} -- initialisation
	init is
		do
			init_lighting( true )
		end

	init_lighting( lighting_ : BOOLEAN ) is
		do
			lighting := lighting_

			create live_manager.make
			open_gl := create {Q_GL_DRAWABLE_IMPLEMENTATION}.make( live_manager )
			
			set_left( -1.0 )
			set_right( 1.0 )
			set_top( 1.0 )
			set_bottom( -1.0 )
			set_near( 1 )
			set_far( 10000 )
			
			open_gl.gl.gl_enable( open_gl.gl_constants.esdl_gl_depth_test )
			
			if lighting_ then
				open_gl.gl.gl_enable( open_gl.gl_constants.esdl_gl_lighting )
			end
			
			create hud.make
			hud.set_bounds ( 0, 0, 1, 1 )
			set_hud( hud )
		end

feature -- visualisation
	live_manager : Q_GL_LIVE_MANAGER
	open_gl : Q_GL_DRAWABLE

	draw() is
			-- draws the area
		do
			-- prepare
			open_gl.gl.gl_clear( open_gl.gl_constants.esdl_gl_depth_buffer_bit.bit_or( open_gl.gl_constants.esdl_gl_color_buffer_bit ) )

			open_gl.gl.gl_matrix_mode( open_gl.gl_constants.esdl_gl_projection )
			open_gl.gl.gl_load_identity
			open_gl.gl.gl_frustum ( left, right, bottom, top, near, far )
			
			open_gl.gl.gl_matrix_mode( open_gl.gl_constants.esdl_gl_modelview )
			
			if lighting then
				open_gl.gl.gl_enable( open_gl.gl_constants.esdl_gl_lighting )
			else
				open_gl.gl.gl_disable( open_gl.gl_constants.esdl_gl_lighting )				
			end
			
			live_manager.grow
			
			-- draw
			if inside /= void then
				if transform /= void then
					transform.transform( open_gl )
					inside.draw( open_gl )
					transform.untransform( open_gl )
				else
					inside.draw( open_gl )
				end
			end
			
			if hud /= void then
				draw_hud
			end
			
			-- delete no longer used objects
			live_manager.kill
		end

feature {NONE} -- helpfeatures
	draw_hud is
		require
			open_gl_not_void : open_gl /= void
			hud_not_void : hud /= void
		local
			display_x_, display_y_, display_z_ : DOUBLE
			width_, height_ : DOUBLE
		do
			if lighting then
				open_gl.gl.gl_disable( open_gl.gl_constants.esdl_gl_lighting )
			end
			
			open_gl.gl.gl_load_identity
		    open_gl.gl.gl_push_matrix
		    
		    display_x_ := ( left + right ) / 2.0;
		    display_y_ := ( top + bottom ) / 2.0;
		    display_z_ := -near;
		    
		    width_ := right - left;
		    height_ := top - bottom;
		    
		    open_gl.gl.gl_translated( display_x_ - width_/2, -(display_y_ - height_/2), display_z_ );
		    open_gl.gl.gl_scaled( width_, -height_, 1.0 );
		    open_gl.gl.gl_normal3f( 0, 0, 1 );
		    
		    open_gl.gl.gl_disable( open_gl.gl_constants.esdl_gl_depth_test )
		    hud.draw( open_gl )
		    open_gl.gl.gl_enable( open_gl.gl_constants.esdl_gl_depth_test )
		    
		    open_gl.gl.gl_pop_matrix
		    
		    if lighting then
				open_gl.gl.gl_enable( open_gl.gl_constants.esdl_gl_lighting )
			end
		end
		

feature -- parts to be displayed
	inside : Q_GL_OBJECT
	hud : Q_HUD_ROOT_PANE
	transform : Q_GL_TRANSFORM
	
	set_inside( inside_ : Q_GL_OBJECT ) is
			-- The object to be displayed
		do
			inside := inside_
		end
		
	set_hud( hud_ : Q_HUD_ROOT_PANE ) is
			-- set the Heads-Up-Display
		require
			no_one_elses_hud : hud_.root = void
		do
			if hud /= void then
				hud.set_root( void )
			end
			
			hud := hud_
			
			if hud /= void then
				hud_.set_root( current )
			end
		end
		
	set_transform( transform_ : Q_GL_TRANSFORM ) is
			-- sets the transformation of the inside-object
		do
			transform := transform_
		end

feature -- geometrics
	direction_in_hud( x_, y_ : DOUBLE ) : Q_VECTOR_3D is
			-- Gets the direction under a point. All points on the
			-- line from x_, y_ and direction (in the huds-coorinate-system)
			-- are projected into x_, y_.
			-- The point 0/0 is at the top-left, the point 1/1 at the bottom-right

		do
			create result.make(
				left / (right - left) + x_,
				bottom / (top - bottom) + y_,
				-near)
				
			result.normaliced	
		end
		


feature -- frustum
 -- private double left = -1, right = 1, bottom = -1, top = 1, near = 1, far = 10000;
 
 	left : DOUBLE
 	right : DOUBLE
 	bottom : DOUBLE
 	top : DOUBLE
 	near : DOUBLE
 	far : DOUBLE
 	
 	set_left( left_ : DOUBLE ) is
 		do
 			left := left_
 		end
 		
 	set_right( right_ : DOUBLE ) is
 		do
 			right := right_
 		end
 		
 	set_bottom( bottom_ : DOUBLE ) is
 		do
 			bottom := bottom_
 		end
 		
 	set_top( top_ : DOUBLE ) is
 		do
 			top := top_
 		end
 		
 	set_near( near_ : DOUBLE ) is
 		do
 			near := near_
 		end
 		
 	set_far( far_ : DOUBLE ) is
 		do
 			far := far_
 		end
 		
feature -- values
	lighting : BOOLEAN
	
	
	set_lighting( lighting_ : BOOLEAN ) is
		do
			lighting := lighting_
		end
		
end -- class Q_GL_ROOT
