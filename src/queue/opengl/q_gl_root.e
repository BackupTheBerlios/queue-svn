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
	description: "Root of the Queue-OpenGL-Part. Thats not the Scene, put all OpenGL-Parts are managed from this class"
	author: "Benjamin Sigg"

class
	Q_GL_ROOT

creation
	init,
	init_lighting,
	init_timed

feature{NONE} -- initialisation
	init is
		do
			init_lighting( true )
		end
		
	init_timed( time_ : Q_TIME ) is
		do
			lighting := true
			
			create live_manager.make
			create open_gl_impl.make_timed( live_manager, time_ )
			
			init_intern
		end
		

	init_lighting( lighting_ : BOOLEAN ) is
		do
			lighting := lighting_

			create live_manager.make
			create open_gl_impl.make( live_manager )
			
			init_intern
		end
			
	init_intern is
		do
			set_left( -1.0 )
			set_right( 1.0 )
			set_top( 0.75 )
			set_bottom( -0.75 )
			set_near( 1 )
			set_far( 10000 )
			
			open_gl.gl.gl_enable( open_gl.gl_constants.esdl_gl_depth_test )
			
			if lighting then
				open_gl.gl.gl_enable( open_gl.gl_constants.esdl_gl_lighting )
			end
			
			create hud.make
			hud.set_bounds ( 0, 0, 1, 1 )
			set_hud( hud )
		end

feature{NONE}
	open_gl_impl : Q_GL_DRAWABLE_IMPLEMENTATION

feature -- visualisation
	live_manager : Q_GL_LIVE_MANAGER
	open_gl : Q_GL_DRAWABLE is
		do
			result := open_gl_impl
		end
		

	draw() is
			-- draws the area
		do
			-- prepare
			open_gl_impl.restart
			
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
			
			if smooth then
				open_gl.gl.gl_enable( open_gl.gl_constants.esdl_gl_point_smooth )
				open_gl.gl.gl_enable( open_gl.gl_constants.esdl_gl_line_smooth )
				open_gl.gl.gl_enable( open_gl.gl_constants.esdl_gl_polygon_smooth )				
			else
				open_gl.gl.gl_disable( open_gl.gl_constants.esdl_gl_point_smooth )
				open_gl.gl.gl_disable( open_gl.gl_constants.esdl_gl_line_smooth )
				open_gl.gl.gl_disable( open_gl.gl_constants.esdl_gl_polygon_smooth )								
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
			live_manager.kill( open_gl )
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
			hud.reset_queue
		    
			open_gl.gl.gl_load_identity
		    hud.queue.load_identity
		    
		    display_x_ := ( left + right ) / 2.0;
		    display_y_ := ( top + bottom ) / 2.0;
		    display_z_ := -near;
		    
		    width_ := right - left;
		    height_ := top - bottom;
		    
		    open_gl.gl.gl_disable( open_gl.gl_constants.esdl_gl_depth_test )
		    
		    hud.queue.translate( display_x_ - width_/2, -(display_y_ - height_/2), display_z_ );
		    hud.queue.scale( width_, -height_, 1.0 );
		    
		    open_gl.gl.gl_normal3f( 0, 0, 1 );
		    hud.enqueue( hud.queue )
		    hud.queue.draw( open_gl )
		    
		    open_gl.gl.gl_enable( open_gl.gl_constants.esdl_gl_depth_test )
		    
		    if lighting then
				open_gl.gl.gl_enable( open_gl.gl_constants.esdl_gl_lighting )
			end
		end
		
	math : Q_MATH is
		once
			create result
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

feature -- geometrics with the hud
	direction_in_space( x_, y_ : DOUBLE ) : Q_VECTOR_3D is
			-- Gets the direction under a point. All points on the
			-- line from x_, y_ and direction (in the huds-coorinate-system)
			-- are projected into x_, y_.
			-- The point 0/0 is at the top-left, the point 1/1 at the bottom-right

		do
			result := position_in_space( x_, y_ )
			result.normaliced
		end
		
	direction_in_hud( x_, y_, z_ : DOUBLE ) : Q_VECTOR_2D is
			-- 
		do
			result := position_in_hud( x_, y_, z_ )
		end
		
	
	position_in_hud( x_, y_, z_ : DOUBLE ) : Q_VECTOR_2D is
			-- Gets the position in the hud of a 3d-point (in the huds-
			-- coordinate system).
		do
			create result.make((x_/-z_ - left) / (right - left), (y_/-z_ - top) / (bottom - top) )
		end
		
	position_in_space( x_, y_ : DOUBLE ) : Q_VECTOR_3D is
		do
			create result.make( left + x_*( right - left ), top + y_ * ( bottom - top ), -near )
		end	
		
	line_hud_to_point( point_ : Q_VECTOR_3D ) : Q_LINE_3D is
			-- creates a line from the hud to the given point
		local
			hud_ : Q_VECTOR_2D
		do
			hud_ := position_in_hud( point_.x, point_.y, point_.z )
			create result.make_vectorized( point_, direction_in_space( hud_.x, hud_.y ))
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
		-- true if lighting should be enabled
		
	smooth : BOOLEAN
		-- true if smooth painting for points, lines and polygons should be enabled
	
	set_lighting( lighting_ : BOOLEAN ) is
		do
			lighting := lighting_
		end
		
	set_smooth( smooth_ : BOOLEAN ) is
		do
			smooth := smooth_
		end
		
		
end -- class Q_GL_ROOT
