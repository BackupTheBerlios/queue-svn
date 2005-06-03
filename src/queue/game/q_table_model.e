indexing
	description: "Objects that represent a 3D-model of the table"
	author: "Basil Fierz, bfierz@student.ethz.ch"
	date: "$Date: 2005/05/12 $"
	revision: "$Revision: 1.0 $"

class
	Q_TABLE_MODEL

inherit
	Q_GL_OBJECT
	redefine
		draw
	end

create
	make_from_file

feature -- Interface
	draw( open_gl : Q_GL_DRAWABLE ) is
		-- paint the table
	do
		model.draw (open_gl)
--		shapes.draw (open_gl)
	end
	
	model: Q_GL_GROUP[Q_GL_MODEL]
		-- the model
		
--	shapes: Q_GL_GROUP[Q_GL_OBJECT]
		-- bounding shapes
		
	banks: ARRAY[Q_BANK]
		-- the banks
		
	holes: ARRAY[Q_HOLE]
		-- the holes
		
	height: DOUBLE
		-- the size in cm in y direction
		
	width: DOUBLE
		-- the size in cm in x direction
		
feature {NONE} -- internal properties
	root: Q_VECTOR_2D

feature -- coordinate-system
	position_table_to_world( table_ : Q_VECTOR_2D ) : Q_VECTOR_3D is
		do
			create result.make (root.x - table_.x, -2.86, root.y - table_.y)
		end
	
	direction_table_to_world( table_ : Q_VECTOR_2D ) : Q_VECTOR_3D is
		do
			create result.make (table_.x, 0, table_.y)
		end
		
	position_world_to_table( world_ : Q_VECTOR_3D ) : Q_VECTOR_2D is
		do
			create result.make (root.x + world_.x, root.y + world_.z)
		end
		
	direction_world_to_table( world_ : Q_VECTOR_3D ) : Q_VECTOR_2D is
		do
			create result.make (world_.x, world_.z)
		end
		

feature {NONE} -- Implementation
	make_from_file (file_name_: STRING) is
			-- create the model from out of a file
		require
			file_name_ /= void
		local
			loader : Q_GL_3D_ASE_LOADER
		do
			create loader.make
		
			-- create the modell	
			loader.load_file (file_name_)
			model := loader.create_flat_model
			
			-- create the logical modell
			banks := make_banks (loader.shape_objects)
			holes := make_holes (loader.shape_objects)
			make_table_size (holes)
			
--			shapes := loader.create_shapes
--			shapes.extend (
--				create {Q_GL_LINE}.make_position_material (
--					create {Q_VECTOR_3D}.make (0, 0, 0),
--					create {Q_VECTOR_3D}.make (200, 0, 0),
--					create {Q_GL_MATERIAL}.make_single_colored (create {Q_GL_COLOR}.make_white)
--					)
--				)
		end
	
	make_table_size (holes_ : ARRAY[Q_HOLE]) is 
			-- calculates the width and the length
		require
			holes_ /= void
		local
			index_: INTEGER
			
			curr_: Q_VECTOR_2D
		do
			-- calculate the root point
			create root
			
			from
				index_ := holes_.lower
			until
				index_ > holes_.upper
			loop
				curr_ := holes_.item (index_).position
				if curr_.x <= root.x and curr_.y <= root.y then
					root.set_x_y (curr_.x, curr_.y)
				end
				
				index_ := index_ + 1
			end
			
			-- calculate the length
			width := root.x.abs * 2
			
			-- calculate the width
			height := root.y.abs * 2
		end
	
	make_holes (shapes_ : ARRAY[Q_GL_3D_ASE_SHAPEOBJ]) : ARRAY[Q_HOLE] is
			-- setup the logial bounds of the table
		local
			index_ : INTEGER
			shape_ : Q_GL_3D_ASE_SHAPEOBJ
			
			inner_index_ : INTEGER
			corner_ : Q_VECTOR_3D
			
			points_ : ARRAY[Q_VECTOR_2D]
			
			counter_ : INTEGER
			
			holes_count_ : INTEGER
		do
			-- create the holes
			create result.make (0,1)
			create points_.make (0,2)
			
			from
				index_ := shapes_.lower
			until
				index_ > shapes_.upper
			loop
				shape_ := shapes_.item (index_)
				if shape_.name.has_substring ("shape_loch") then
					-- collect the knots and omit the interpolated points
					
					create corner_.default_create
					from
						counter_ := 0
						inner_index_ := shape_.knots.lower
					until
						inner_index_ > shape_.knots.upper
					loop
						if shape_.knot_types.item(inner_index_) then
							points_.force (create {Q_VECTOR_2D}.make( shape_.knots.item (inner_index_).x, shape_.knots.item (inner_index_).z), counter_)
							counter_ := counter_ + 1
						end
						
						inner_index_ := inner_index_ + 1
					end
					
					result.force (create {Q_HOLE}.make_from_points (points_), holes_count_)
					holes_count_ := holes_count_ + 1
				end
				
				index_ := index_ + 1
			end
		end
		
	make_banks (shapes_ : ARRAY[Q_GL_3D_ASE_SHAPEOBJ]) : ARRAY[Q_BANK] is
			-- load the banks from the model file
		require
			shapes_ /= void
		local
			index_ : INTEGER
			shape_ : Q_GL_3D_ASE_SHAPEOBJ
			
			inner_index_ : INTEGER
			
			edge1_, edge2_ : Q_VECTOR_2D
			
			list_ : LINKED_LIST[Q_BANK]
		do
			create list_.make
			
			from
				index_ := shapes_.lower
			until
				index_ > shapes_.upper
			loop
				shape_ := shapes_.item (index_)
				if shape_.name.is_equal ("shape_bande") then
					from
						inner_index_ := shape_.knots.lower
					until
						inner_index_ > shape_.knots.upper
					loop
						if shape_.knot_types.item(inner_index_) then
							if inner_index_ < shape_.knots.upper and then shape_.knot_types.item(inner_index_ + 1) then
								create edge1_.make (shape_.knots.item(inner_index_).x, shape_.knots.item(inner_index_).z)
								create edge2_.make (shape_.knots.item(inner_index_+1).x, shape_.knots.item(inner_index_+1).z)
								
								list_.extend (create {Q_BANK}.make (edge1_, edge2_))
							end
						end
						
						inner_index_ := inner_index_ + 1
					end
				end
			
				index_ := index_ + 1	
			end
			
			create result.make (0, list_.count -1 )
			
			from
				list_.start
				index_ := 0
			until
				list_.after
			loop
				result.put (list_.item, index_)
				
				list_.forth
				index_ := index_ + 1
			end
		end
		
end -- class Q_TABLE_MODEL
