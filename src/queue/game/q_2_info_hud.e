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
	description: "A hud menu showing a big and a small label for two informations. One of the label-group can be active."
	author: "Benjamin Sigg"

class
	Q_2_INFO_HUD

inherit
	Q_HUD_CONTAINER

creation
	make_ordered
	
feature{NONE}
	make_ordered( big_top_ : BOOLEAN ) is
		local
			panel_ : Q_HUD_PANEL
			container_ : Q_HUD_CONTAINER_3D
		do
			make

			create left.make
			create right.make
			create plane.make
			
			create big_left.make
			create big_right.make
			create small_left.make
			create small_right.make
			
			create loop_big_left.make
			create loop_big_right.make
			create loop_small_left.make
			create loop_small_right.make

			create panel_.make
			create container_.make
			
			panel_.set_bounds( 0, 0, 0.4, 0.2 )
			plane.add( panel_ )
			
			big_left.set_bounds( 0, 0, 0.4, 0.09 )
			big_right.set_bounds( 0, 0, 0.4, 0.09 )
			small_left.set_bounds( 0, 0, 0.35, 0.09 )
			small_right.set_bounds( 0, 0, 0.35, 0.09 )
			
			if big_top_ then
				loop_big_left.set_bounds( 0, 0, 0.4, 0.09 )
				loop_small_left.set_bounds( 0.05, 0.1, 0.35, 0.1 )
				loop_big_right.set_bounds( 0, 0, 0.4, 0.09 )
				loop_small_right.set_bounds( 0.05, 0.1, 0.35, 0.1 )				
			else
				loop_big_left.set_bounds( 0, 0.1, 0.4, 0.1 )
				loop_small_left.set_bounds( 0.0, 0, 0.35, 0.09 )
				loop_big_right.set_bounds( 0, 0.1, 0.4, 0.1 )
				loop_small_right.set_bounds( 0.0, 0, 0.35, 0.09 )				
			end

			loop_big_left.add( big_left )
			loop_big_right.add( big_right )
			loop_small_left.add( small_left )
			loop_small_right.add( small_right )

			loop_big_left.set_axis( create {Q_VECTOR_3D}.make( 1, 0, 0 ))
			loop_big_right.set_axis( create {Q_VECTOR_3D}.make( 1, 0, 0 ))
			loop_small_left.set_axis( create {Q_VECTOR_3D}.make( 1, 0, 0 ))
			loop_small_right.set_axis( create {Q_VECTOR_3D}.make( 1, 0, 0 ))

			left.add( loop_big_left )
			left.add( loop_small_left )
			right.add( loop_big_right )
			right.add( loop_small_right )
			
			left.set_bounds( 0.0, 0, 0.4, 0.2 )
			right.set_bounds( 0.5, 0, 0.4, 0.2 )
			plane.set_bounds( 0.0, 0, 0.9, 0.2 )
			
			container_.add( left )
			container_.add( right )
			container_.add( plane )
			
			add( container_ )
			container_.translate( 0, 0, -0.05 )
			
			set_size( 0.9, 0.2 )
			
			force_no_active
		end
		
feature{NONE} -- hud
	left, right, plane : Q_HUD_SLIDING_3D
	
	big_left, small_left, big_right, small_right : Q_HUD_LABEL
	loop_big_left, loop_small_left, loop_big_right, loop_small_right : Q_HUD_LOOPING
	
feature -- hud
	set_big_left_text( text_ : STRING ) is
		do
			if not big_left.text.same_string ( text_ ) then
				big_left.set_text( text_ )
				loop_big_left.looping
			end
		end

	set_small_left_text( text_ : STRING ) is
		do
			if not small_left.text.same_string( text_ ) then
				small_left.set_text( text_ )
				loop_small_left.looping	
			end
		end
		
	set_big_right_text( text_ : STRING ) is
		do
			if not big_right.text.same_string( text_ ) then
				big_right.set_text( text_ )
				loop_big_right.looping	
			end
		end
		
	set_small_right_text( text_ : STRING ) is
		do
			if not small_right.text.same_string( text_ ) then
				small_right.set_text( text_ )
				loop_small_right.looping
			end
		end

	set_left_active is
		do
			plane.move_to( create {Q_VECTOR_3D}.make( 0, 0, 0.11 ))
			left.move_to( create {Q_VECTOR_3D}.make( 0, 0, 0 ))
			right.move_to( create {Q_VECTOR_3D}.make( 0, 0, 0.1 ))
		end
		
	set_right_active is
		do
			plane.move_to( create {Q_VECTOR_3D}.make( -0.5, 0, 0.11 ))
			left.move_to( create {Q_VECTOR_3D}.make( 0, 0, 0.1 ))
			right.move_to( create {Q_VECTOR_3D}.make( 0, 0, 0 ))			
		end
	
	set_no_active is
		do
			plane.move_to( create {Q_VECTOR_3D}.make( -0.25, 0, 0.3 ))
			left.move_to( create {Q_VECTOR_3D}.make( 0, 0, 0.2 ))
			right.move_to( create {Q_VECTOR_3D}.make( 0, 0, 0.2 ))
		end
		
	force_no_active is
		do
			plane.set_position( create {Q_VECTOR_3D}.make( -0.25, 0, 0.3 ))
			left.set_position( create {Q_VECTOR_3D}.make( 0, 0, 0.2 ))
			right.set_position( create {Q_VECTOR_3D}.make( 0, 0, 0.2 ))			
		end
		
end -- class Q_2_INFO_HUD
