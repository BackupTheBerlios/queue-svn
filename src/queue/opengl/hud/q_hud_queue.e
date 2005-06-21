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
	description: "A Queue of hud-components, sorted by distanc to the screen"
	author: "Benjamin Sigg"

class
	Q_HUD_QUEUE

creation
	make

feature{NONE} -- creation
	make( root_ : Q_HUD_ROOT_PANE ) is
		do
			create stack.make( 3 )
			create matrix.identity
			create list.make( 10 )
			
			root_pane := root_
		end

feature -- root
	root_pane : Q_HUD_ROOT_PANE
		
	root : Q_GL_ROOT is
		do
			result := root_pane.root
		end
	
feature -- matrix
	load_identity is
			-- loads the identity-matrix
		do
			create stack.make( 3 )
			matrix.identity
		end
		
	load_matrix( matrix_ : Q_MATRIX_4X4 ) is
			-- loads a matrix
		do
			create stack.make( 3 )
			matrix := matrix_
		end
	
	matrix_multiplication( matrix_ : Q_MATRIX_4X4 ) is
			-- multiplicates the current matrix
		do
			matrix := matrix.mul( matrix_ )
		end
		
	
	translate( dx_, dy_, dz_ : DOUBLE ) is
			-- translates the current matrix
		local
			matrix_ : Q_MATRIX_4X4
		do
			create matrix_.identity
			matrix_.translate( dx_, dy_, dz_ )
			matrix_multiplication( matrix_ )
		end
		
	scale( sx_, sy_, sz_ : DOUBLE ) is
			-- scales the current matrix
		local
			matrix_ : Q_MATRIX_4X4
		do
			create matrix_.identity
			matrix_.scale( sx_, sy_, sz_ )
			matrix_multiplication( matrix_ )
		end	
		
	rotate( ax_, ay_, az_, angle_ : DOUBLE ) is
			-- rotates the current matrix
		local
			matrix_ : Q_MATRIX_4X4
		do
			create matrix_.identity
			matrix_.rotate( ax_, ay_, az_, angle_ )
			matrix_multiplication( matrix_ )
		end
		
	rotate_around( ax_, ay_, az_, angle_, px_, py_, pz_ : DOUBLE ) is
			-- rotates the current matrix
		local
			matrix_ : Q_MATRIX_4X4
		do
			create matrix_.identity
			matrix_.rotate_at( ax_, ay_, az_, angle_, px_, py_, pz_ )
			matrix_multiplication( matrix_ )
		end		
		
	push_matrix is
		do
			stack.extend( matrix )
			create matrix.copy( matrix )
		end
		
	pop_matrix is
		do
			matrix := stack.last
			stack.go_i_th( stack.count )
			stack.remove
		end
		
feature -- component
	insert( component_ : Q_HUD_COMPONENT ) is
			-- inserts a component into this list
		local
			position_, dir_a_, dir_b_ : Q_VECTOR_3D
			entry_ : Q_HUD_QUEUE_ENTRY
			
			matrix_ : Q_MATRIX_4X4
		do
			create position_.make( 0, 0, 0 )
			create dir_a_.make( component_.width, 0, 0 )
			create dir_b_.make( 0, component_.height, 0 )

			create matrix_.copy( matrix )
			
			position_ := matrix_.mul_vector_3_as_4( position_ )
			dir_a_ := matrix_.mul_vector_3( dir_a_ )
			dir_b_ := matrix_.mul_vector_3( dir_b_ )
			
			create entry_
			entry_.set_component( component_ )
			entry_.set_matrix( matrix_ )
			
			entry_.set_vectorized_plane( create {Q_VECTORIZED_PLANE}.make_vectorized( position_, dir_a_, dir_b_ ))
			
			insert_into_list( entry_ )
		end
		
feature{Q_GL_ROOT} -- draw the hud
	draw( open_gl : Q_GL_DRAWABLE ) is
			-- draws all components so far registered
		local
			index_ : INTEGER
			entry_ : Q_HUD_QUEUE_ENTRY
		do
			from
				index_ := list.count
			until
				index_ = 0
			loop
				open_gl.gl.gl_push_matrix
				entry_ := list.i_th( index_ )
				entry_.matrix.set( open_gl )
				entry_.component.draw( open_gl )
				open_gl.gl.gl_pop_matrix
				
				index_ := index_ - 1
			end
		end

feature{Q_HUD_ROOT_PANE} -- list of components
	cut( line_ : Q_LINE_3D; component_ : Q_HUD_COMPONENT ) : Q_VECTOR_2D is
		do
			from
				list.start
				result := void
			until
				list.after or result /= void
			loop
				if list.item.component = component_ then
					result := cut_plane( line_, component_, list.item.vectorized_plane )
				end
				
				list.forth
			end
		end
		
	cut_plane( line_ : Q_LINE_3D; component_ : Q_HUD_COMPONENT; plane_ : Q_VECTORIZED_PLANE ) : Q_VECTOR_2D is
			-- Cuts a line with a plane, and returns a 2dimensional vector
			-- witch is a transformation of the coordinates into the
			-- planes-coordinatesystem.
			-- This method is directly used to find out, where a line
			-- cuts a component
		local
			sizes_ : ARRAY[ DOUBLE ]
		do
			sizes_ := list.item.vectorized_plane.cut_line_sizes( line_ ) 
			if sizes_ /= void then
				create result.make( 
					sizes_.item( 1 ) * component_.width, 
					sizes_.item( 2 ) * component_.height )
			end
		end
		
	
	index_of_component( component_ : Q_HUD_COMPONENT ) : INTEGER is
		do
			from
				result := 1
				list.start
			until
				list.after or else list.item.component = component_
			loop
				result := result + 1
				list.forth
			end
			
			if list.after then
				result := 0
			end
		end
		
	
	next_component_under( x_, y_ : DOUBLE; index_ : INTEGER; jump_ : BOOLEAN ) : Q_HUD_QUEUE_SEARCH_RESULT is
		do
			result := next_component_on(
				create {Q_LINE_3D}.make_vectorized(
					root.position_in_space( x_, y_ ), root.direction_in_space( x_, y_ )),
					index_, jump_ )
		end
		

	next_component_on( line_ : Q_LINE_3D; index_ : INTEGER; jump_ : BOOLEAN ) : Q_HUD_QUEUE_SEARCH_RESULT is
			-- searches the next component witch cuts the line.
			-- Take an index of 0, if you want to start a new search
			-- If jump is true, the component at "index_" will not be tested,
			-- otherwise this component will be included
			-- Returns the index, the component itself and the coordinates on the component,
			-- where the cutting is, or void
		local
			component_ : Q_HUD_COMPONENT
			list_index_ : INTEGER
			location_ : Q_VECTOR_2D
			
			visible_, stop_ : BOOLEAN
		do
			if index_ <= list.count then			
				if index_ < 1 then
					list.go_i_th( 1 )
					list_index_ := 1
					visible_ := true
				elseif jump_ then
					list.go_i_th( index_ )
					visible_ := list.item.component.visible
						
					list.forth
					list_index_ := index_ + 1
				else
					list.go_i_th( index_ )
					visible_ := list.item.component.visible
					list_index_ := index_
				end
				result := void

				from
					stop_ := false
				until
					stop_ or result /= void
				loop
					from
						-- nothing
					until
						list.after or result /= void
					loop
						if list.item.component.visible = visible_ then
							location_ := cut_plane( line_, list.item.component, list.item.vectorized_plane )

							if location_ /= void then
								component_ := list.item.component
						
								if component_.inside( location_.x, location_.y ) then
									create result.make( list_index_, component_, location_ )
								end
							end
						end
				
						list.forth
						list_index_ := list_index_ + 1
					end
					
					if result = void then
						if visible_ then
							visible_ := false
							list_index_ := 1
							list.start
						else
							stop_ := true
						end
					end
				end			
			end
		end
		

feature {Q_HUD_COMPONENT_QUEUE} -- Queue & Stack
	insert_into_list( entry_ : Q_HUD_QUEUE_ENTRY ) is
		local
			left_, right_, middle_, compare_ : INTEGER
			stop_ : BOOLEAN
		do			
			if list.count = 0 then
				list.extend( entry_ )
			else
				from
					left_ := 1
					right_ := list.count
					stop_ := false
				until
					stop_
				loop
					if left_ = right_ then
						compare_ := compare( entry_, list.i_th( left_ ))
						if compare_ < 0 then
							insert_into_list_at( entry_, left_ ) 
						else
							insert_into_list_at( entry_, left_ + 1 ) 
						end
						
						stop_ := true
					else
						middle_ := (left_ + right_) // 2
						compare_ := compare( entry_, list.i_th( middle_ ))
			
						if compare_ > 0 then
							-- entry is far away
							if left_ = middle_ then
								left_ := right_
							else
								left_ := middle_
							end
						elseif compare_ < 0 then
							-- entry is near
							if right_ = middle_ then
								right_ := left_
							else
								right_ := middle_
							end
						else
							insert_into_list_at( entry_, middle_+1 ) 
							stop_ := true
						end
					end
				end
			end
		end
		
	insert_into_list_at( entry_ : Q_HUD_QUEUE_ENTRY; index_ : INTEGER ) is
			-- inserts an element at a given index into the list
		local
			move_ : INTEGER
		do
	--		list.put_i_th( entry_, index_ )
			from
				move_ := list.count
				list.extend( entry_ )
			until
				move_ = index_ - 1
			loop
				list.put_i_th( list.i_th( move_ ), move_ + 1 )
				move_ := move_ - 1
			end
			
			list.put_i_th( entry_, index_ )
		end
		

	list : ARRAYED_LIST[ Q_HUD_QUEUE_ENTRY ]
		-- The (ordered) list of the components, and their 3-dimensional rectangle, in
		-- the form (component, position, width, height)

	stack : ARRAYED_LIST[ Q_MATRIX_4X4 ]
		-- The matrixes
		
	matrix : Q_MATRIX_4X4
		
feature{NONE} -- Math
	math : Q_MATH is
		once
			create result
		end
		
	tolerance : DOUBLE is 0.0001
		
	compare( first_, second_ : Q_HUD_QUEUE_ENTRY ) : INTEGER is
			-- compares the position of two components. 
			-- A negative return value means, that first_ is nearer
			-- to the screen
		local
			dist_f_, dist_s_ : DOUBLE
		do			
			dist_f_ := first_.vectorized_plane.position.z + 
				0.5 * first_.vectorized_plane.a.z + 
				0.5 * first_.vectorized_plane.b.z

			dist_s_ := second_.vectorized_plane.position.z + 
				0.5 * second_.vectorized_plane.a.z + 
				0.5 * second_.vectorized_plane.b.z
			
			if (dist_f_ - dist_s_).abs < tolerance then
				result := compare_parents( first_.component, second_.component )
			elseif dist_f_ > dist_s_ then
				result := -1
			elseif dist_f_ < dist_s_ then
				result := 1
			else
				result := compare_parents( first_.component, second_.component )
			end
		end
		
	compare_parents( first_, second_ : Q_HUD_COMPONENT ) : INTEGER is 
		local
			temp_ : Q_HUD_COMPONENT
			stop_ : BOOLEAN
		do
			stop_ := false
			result := 0
			
			from
				temp_ := first_
			until
				temp_ = void or stop_
			loop
				if temp_ = second_ then
					result := -1
					stop_ := true
				else
					temp_ := temp_.parent	
				end
			end
			
			from
				temp_ := second_
			until
				temp_ = void or stop_
			loop
				if temp_ = first_ then
					result := 1
					stop_ := true
				else
					temp_ := temp_.parent
				end
			end
		end
end -- class Q_HUD_QUEUE
