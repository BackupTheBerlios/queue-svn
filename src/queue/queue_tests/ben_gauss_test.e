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

class
	BEN_GAUSS_TEST


inherit
	Q_TEST_CASE

feature
	name : STRING is "Gauss"	
		
	init is
			-- Invoked when this test ist choosen.
		do
		end
		
	lighting : BOOLEAN is false

	object : Q_GL_OBJECT is do
		result := void
	end
	
	system : ARRAY2[ Q_HUD_TEXT_FIELD ]
	b : ARRAY[ Q_HUD_TEXT_FIELD ]
	res : ARRAY[ Q_HUD_LABEL ]
	size : INTEGER is 3
	
	hud : Q_HUD_COMPONENT is
			-- A Hud-Component. The size of this component will not be changed.
			-- The value can be void, if the test does not need a hut
		local
			row_, column_ : INTEGER
			container_ : Q_HUD_CONTAINER
			font_ : Q_HUD_FONT
			button_ : Q_HUD_BUTTON
			
			field_ : Q_HUD_TEXT_FIELD
			label_ : Q_HUD_LABEL
		do
			font_ := create {Q_HUD_IMAGE_FONT}.make_standard( "Arial", 64, false, false );
			create container_.make
			container_.set_bounds( 0, 0, 1, 1 )

			create system.make( size, size )
			create b.make( 1, size )
			create res.make( 1, size )
			
			from row_ := 1 until row_ > size loop
				from column_ := 1 until column_ > size loop
					create field_.make
					system.put( field_, row_, column_ )
					container_.add( field_ )
					field_.set_bounds( column_/10, row_/10, 0.09, 0.09 )
					field_.set_font( font_ )
					field_.set_font_size( 0.05 )
					field_.set_text( "0" )
					field_.set_alignement_x( 1.0 )
					
					column_ := column_ + 1
				end
				
				create label_.make
				res.put( label_, row_ )
				container_.add( label_ )
				label_.set_bounds( (size+1)/10, row_/10, 0.19, 0.09 )
				label_.set_font( font_ )
				label_.set_font_size( 0.05 )
				label_.set_text( "-" )
				label_.set_alignement_x ( 0.5 )
				
				create field_.make
				b.put( field_, row_ )
				container_.add( field_ )
				field_.set_bounds( (size+3)/10, row_/10, 0.09, 0.09 )
				field_.set_font( font_ )
				field_.set_font_size( 0.05 )
				field_.set_text( "0" )
				field_.set_alignement_x( 1.0 )
				
				row_ := row_ + 1
			end

			create button_.make
			button_.set_text( "Solve" )
			container_.add( button_ )
			button_.set_font( font_ )
			button_.set_font_size( 0.05 )
			button_.set_bounds( 0.8, 0.9, 0.19, 0.09 )
			button_.actions.extend( agent work(?,?) )
			
			result := container_
		end
		
	work( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		local
			matrix_ : ARRAY2[ DOUBLE ]
			vector_ : ARRAY[ DOUBLE ]
			
			row_, column_ : INTEGER
		do
			create matrix_.make( size, size )
			create vector_.make( 1, size )
			
			from row_ := 1 until row_ > size loop
				from column_ := 1 until column_ > size loop
					matrix_.put( system.item( row_, column_ ).text.to_double, row_, column_ )
					column_ := column_ + 1
				end
				vector_.put( b.item ( row_ ).text.to_double, row_ )
				row_ := row_ + 1
			end
			
			vector_ := (create {Q_MATH}).gauss_changing( matrix_, vector_ )
			
			if vector_ /= void then
				from row_ := 1 until row_ > size loop
					res.item( row_ ).set_text( vector_.item( row_ ).out )
					row_ := row_ + 1
				end
			else
				from row_ := 1 until row_ > size loop
					res.item( row_ ).set_text( "-" )
					row_ := row_ + 1
				end			
			end
		end
		
		
	max_bound : Q_VECTOR_3D is do
		result := void
	end
		
	min_bound : Q_VECTOR_3D is do
		result := void
	end
		
	initialized( root_ : Q_GL_ROOT ) is
			-- Called after the test-case is initialized. If you want, you
			-- can change some settings...
		do
		end



end -- class BEN_GAUSS_TEST
