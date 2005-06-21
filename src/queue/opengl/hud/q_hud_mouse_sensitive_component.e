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
	description: "A component reacting on the mouse by using a special background if the mouse enters, or the mouse is pressed"
	author: "Benjamin Sigg"

deferred class
	Q_HUD_MOUSE_SENSITIVE_COMPONENT

inherit
	Q_HUD_COMPONENT
	rename
		background as background_normal,
		set_background as set_background_normal
	redefine
		draw_background, make
	end
	
feature{Q_HUD_MOUSE_SENSITIVE_COMPONENT} -- creation
	make is
		do
			precursor
			make_sensitive
		end
		
	make_sensitive is
		do
			mouse_button_down_listener.extend( agent mouse_button_down( ?,?,?,?,? ))
			mouse_button_up_listener.extend( agent mouse_button_up( ?,?,?,?,? ))
			mouse_enter_listener.extend( agent mouse_enter( ?,?,? ))
			mouse_exit_listener.extend( agent mouse_exit( ?,?,? ))
			component_removed_listener.extend( agent component_removed( ?,? ))
		end
		
	
feature{Q_HUD_MOUSE_SENSITIVE_COMPONENT} -- event-handling
	pressed, mouse_over : BOOLEAN

	do_click() is
			-- called, when the mouse was pressed and is not realeased inside the component
		deferred
		end
		

	component_removed( parent_ : Q_HUD_CONTAINER; child_ : Q_HUD_COMPONENT ) is
		do
			pressed := false
			mouse_over := false
		end

	mouse_button_down( event_ : ESDL_MOUSEBUTTON_EVENT; x_, y_ : DOUBLE; map_ : Q_KEY_MAP; consumed_ : BOOLEAN ) : BOOLEAN is
		do			
			if not consumed_ then
				pressed := true
				result := true
			end
		end
		
	mouse_button_up( event_ : ESDL_MOUSEBUTTON_EVENT; x_, y_ : DOUBLE; map_ : Q_KEY_MAP; consumed_ : BOOLEAN ) : BOOLEAN is
		do
			if not consumed_ then
				if pressed then
					pressed := false
					
					if inside( x_, y_ ) then
						do_click
					end
				end
			end
		end
		
	mouse_enter( x_, y_ : DOUBLE; map_ : Q_KEY_MAP ) is
		do
			mouse_over := true
		end
		
	mouse_exit( x_, y_ : DOUBLE; map_ : Q_KEY_MAP ) is
		do
			mouse_over := false
		end

feature -- drawing
	background_pressed, background_rollover : Q_GL_COLOR
		
	set_background_pressed( color_ : Q_GL_COLOR ) is
		require
			color_not_void : color_ /= void
		do
			background_pressed := color_
		end
		
	set_background_rollover( color_ : Q_GL_COLOR ) is
		require
			color_not_void : color_ /= void
		do
			background_rollover := color_
		end
		
	draw_background( open_gl : Q_GL_DRAWABLE ) is
		do
			if pressed then
				background_pressed.set( open_gl )
			elseif mouse_over then
				background_rollover.set( open_gl )
			else
				background_normal.set( open_gl )
			end
			
			if blend_background then
				open_gl.gl.gl_enable( open_gl.gl_constants.esdl_gl_blend )
				open_gl.gl.gl_blend_func( 
				open_gl.gl_constants.esdl_gl_src_alpha,
				open_gl.gl_constants.esdl_gl_one_minus_src_alpha )
			end
			
			open_gl.gl.gl_begin( open_gl.gl_constants.esdl_gl_quads )
			open_gl.gl.gl_vertex2d( 0, 0 )
			open_gl.gl.gl_vertex2d( width, 0 )
			open_gl.gl.gl_vertex2d( width, height )
			open_gl.gl.gl_vertex2d( 0, height )
			open_gl.gl.gl_end
			
			if blend_background then
				open_gl.gl.gl_disable( open_gl.gl_constants.esdl_gl_blend )
			end
		end

end -- class Q_HUD_MOUSE_SENSITIVE_COMPONENT
