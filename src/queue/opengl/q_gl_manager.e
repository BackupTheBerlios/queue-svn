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
	description: "An outside view of the GL-Tree. Used to exchange some parts of the tree"
	author: "Benjamin Sigg"

class
	Q_GL_MANAGER

creation
	make, make_timed
	
feature{NONE} -- creation
	make( width_, height_ : INTEGER ) is
			-- Creates the manager
		do
			create root.init_lighting( true )
			make_intern( width_, height_ )
		end
		
	make_timed( width_, height_ : INTEGER; time_ : Q_TIME ) is
		do
			create root.init_timed( time_ )
			make_intern( width_, height_ )
		end
		
	make_intern( width_, height_ : INTEGER ) is
		do
			create group.make
			
			create camera
			create navigator.make_camera( camera )
			
			root.set_transform( camera ) 
			navigator.set_bounds( 0, 0, 1, 1 )
			root.hud.add( navigator )
			root.set_inside( group )
			
			if width_ > height_ then
				root.set_top( height_ / width_ / 1.5 )
				root.set_bottom( -height_ / width_ / 1.5 )
				root.set_left( 1 / 1.5 )
				root.set_right( -1 / 1.5 )
			else
				root.set_top( 1 / 1.5 )
				root.set_bottom( -1 / 1.5 )
				root.set_left( width_ / height_ / 1.5 )
				root.set_right( -width_ / height_ / 1.5 )
			end
		end
		
		
feature{NONE} -- internal values
	root : Q_GL_ROOT
	
	navigator : Q_HUD_CAMERA_NAVIGATOR
	
	group : Q_GL_GROUP[ Q_GL_OBJECT ]
	
feature -- manage GL-Tree
	draw is
			-- Draws the GL-part
		do
			root.draw
		end
		
	process( events_ : Q_EVENT_QUEUE ) is
		do
			root.hud.process( events_ )
		end
		
		
	unused_events : Q_EVENT_QUEUE is
			-- A queue of all events, that are not used by the HUD
		do
			result := root.hud.unused_events
		end
	

	add_hud( hud_ : Q_HUD_COMPONENT ) is
			-- Adds a component to the hud
		do
			navigator.add( hud_ )
		end
		
	remove_hud( hud_ : Q_HUD_COMPONENT ) is
			-- Removes a component from the hus
		do
			navigator.remove( hud_ )
		end
	
	camera : Q_GL_CAMERA
	
	camera_behaviour : Q_CAMERA_BEHAVIOUR is
		do
			result := navigator.behaviour
		end
	
	set_camera_behaviour( behaviour_ : Q_CAMERA_BEHAVIOUR ) is
			-- Sets the camera-behaviour. How the camera reacts on different events.
		do
			navigator.set_behaviour( behaviour_ )
		end
		
	add_object( object_ : Q_GL_OBJECT ) is
		do
			group.extend( object_ ) 
		end
		
	remove_object( object_ : Q_GL_OBJECT ) is
		do
			group.start
			group.prune( object_ )
		end
		
		
feature -- hud / world interaction
	position_hud_to_world( x_, y_ : DOUBLE ) : Q_VECTOR_3D is
			-- From a position in the hud to a position in the real world
		do
			result := root.position_in_space( x_, y_ )
			result := camera.untransform_position( result )
		end
		
	direction_hud_to_world( x_, y_ : DOUBLE ) : Q_VECTOR_3D is
			-- The direction under witch all points are mapped to x/y in the hud
		do
			result := root.direction_in_space( x_, y_ )
			result := camera.untransform_direction( result )
		end
		
	position_world_to_hud( position_ : Q_VECTOR_3D ) : Q_VECTOR_2D is
			-- Where a position in the real world is showed relative to the hud
		local
			vector_ : Q_VECTOR_3D
		do
			vector_ := camera.transform_position( position_ )
			result := root.position_in_hud( vector_.x, vector_.y, vector_.z )
		end

	direction_world_to_hud( direction_ : Q_VECTOR_3D ) : Q_VECTOR_2D is
			-- The direction under witch all points are mapped to x/y in the hud
		local
			vector_ : Q_VECTOR_3D
		do
			vector_ := camera.transform_direction( direction_ )
			result := root.direction_in_hud( vector_.x, vector_.y, vector_.z )
		end		
	
end -- class Q_GL_MANAGER
