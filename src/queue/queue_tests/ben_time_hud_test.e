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
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BEN_TIME_HUD_TEST
inherit
	Q_TEST_CASE
	Q_HUD_CONTAINER
	redefine
		draw
	end

creation
	make

feature
	name : STRING is "Time hud"	
		
	init is
			-- Invoked when this test ist choosen.
		do
		end
		
	lighting : BOOLEAN is false

	object : Q_GL_OBJECT is
		do
			result := void
		end
	
	time : Q_TIME_INFO_HUD
	count : INTEGER
	over : BOOLEAN
	
	set( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			count := count+1
			time.set_small_text( count.out )
			time.set_big_text( "bla" )
		end
	

	start( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			time.start
			over := false
		end

	restart( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			time.restart
			over := false
		end
		
	stop( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			time.stop
		end
	
	draw( open_gl : Q_GL_DRAWABLE ) is
			-- 
		do
			precursor( open_gl )
			if time.over and not over then
				over := true
				time.set_big_text( "over" )
			end
		end
		
	
	hud : Q_HUD_COMPONENT is
			-- A Hud-Component. The size of this component will not be changed.
			-- The value can be void, if the test does not need a hut
		local
			button_ : Q_HUD_BUTTON
		do
			set_bounds( 0, 0, 1, 1 )
			
			create time.make
			time.set_location( 0.05, 0.9 )
			time.set_time_max( 15*1000 )
			time.set_time_cuts( 10 )
			
			create button_.make
			button_.set_bounds( 0.1, 0.1, 0.4, 0.1 )
			button_.set_text( "set" )
			button_.actions.extend( agent set )
			add( button_ )
			
			create button_.make
			button_.set_bounds( 0.1, 0.2, 0.4, 0.1 )
			button_.set_text( "start" )
			button_.actions.extend( agent start )
			add( button_ )
			
			create button_.make
			button_.set_bounds( 0.1, 0.3, 0.4, 0.1 )
			button_.set_text( "restart" )
			button_.actions.extend( agent restart )
			add( button_ )
			
			create button_.make
			button_.set_bounds( 0.1, 0.4, 0.4, 0.1 )
			button_.set_text( "stop" )
			button_.actions.extend( agent stop )
			add( button_ )
			
			count := 0
			time.set_big_text( "Hallo" )
			time.set_small_text( "0" )
			
			add( time )
			add( button_ )
			result := current
		end
		
	max_bound : Q_VECTOR_3D is
			-- A vector, the maximal coordinates of the object.
			-- This method is only invoked if object does not return void
		do
			create result.make( 10, 10, 10 )
		end
		
	min_bound : Q_VECTOR_3D is
			-- A vector, the minimal coordinates of the object.
			-- This method is only invoked if object does not return void
		do
			create result.make( -10, -10, -10 )
		end
		
	initialized( root_ : Q_GL_ROOT ) is
			-- Called after the test-case is initialized. If you want, you
			-- can change some settings...
		do
		end



end -- class BEN_TIME_HUD_TEST
