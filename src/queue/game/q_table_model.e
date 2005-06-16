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

feature -- Debug

	draw_track (ogl: Q_GL_DRAWABLE; ballpos_list: LINKED_LIST[Q_VECTOR_2D]) is
			-- Draw track lines for ball
		local
			glf: GL_FUNCTIONS
			v: Q_VECTOR_3D
		do
			glf := ogl.gl
			
			-- don't use color3b or color3i, that does not work!
			glf.gl_color3f(1,1,1)
			glf.gl_line_width (2)
			glf.gl_disable (ogl.gl_constants.esdl_gl_lighting)
			glf.gl_begin (ogl.gl_constants.esdl_gl_line_strip)

			if ballpos_list /= Void then
				from ballpos_list.start
				until
					ballpos_list.after
				loop
					v := position_table_to_world (ballpos_list.item)
					glf.gl_vertex3d (v.x, v.y, v.z)
					ballpos_list.forth
				end
			end
			
			glf.gl_end
			glf.gl_enable (ogl.gl_constants.esdl_gl_lighting)
			
		end
		
	draw_ballvectors (ogl: Q_GL_DRAWABLE; b: Q_BALL) is
			-- Draw ball velocity vectors
		local
			glf: GL_FUNCTIONS
			a, v: Q_VECTOR_3D
		do
			glf := ogl.gl
			
			v := position_table_to_world (b.center)
			a := direction_table_to_world (b.velocity)
			glf.gl_color3f(1,1,0)
			glf.gl_line_width (2)
			glf.gl_disable (ogl.gl_constants.esdl_gl_lighting)
			
			glf.gl_begin (ogl.gl_constants.esdl_gl_lines)
				glf.gl_vertex3d (v.x, v.y, v.z)
				glf.gl_vertex3d (v.x + a.x, v.y + a.y, v.z + a.z)
			glf.gl_end
			
			a := b.angular_velocity.scale (10) --.cross (b.radvec)
			
			glf.gl_color3f(0,1,1)
			glf.gl_line_width (2)
			glf.gl_begin (ogl.gl_constants.esdl_gl_lines)
				glf.gl_vertex3d (v.x, v.y, v.z)
				glf.gl_vertex3d (v.x + a.x, v.y + a.y, v.z - a.z)
			glf.gl_end
			glf.gl_enable (ogl.gl_constants.esdl_gl_lighting)
			
		end
		
feature -- Interface
	draw( open_gl : Q_GL_DRAWABLE ) is
		-- paint the table
	do
		model.draw (open_gl)
		
		-- START DEBUG (AK) --
		balls.start
		draw_track (open_gl, balls.item.ball.ball0_track)
		draw_ballvectors (open_gl, balls.item.ball)
		-- END DEBUG --
	end
	
	balls : ARRAYED_LIST[ Q_BALL_MODEL ]
		-- the balls
	
	model: Q_GL_GROUP[Q_GL_MODEL]
		-- the model
		
	banks: ARRAY[Q_BANK]
		-- the banks
		
	holes: ARRAY[Q_HOLE]
		-- the holes
		
	height: DOUBLE
		-- the size in cm in y direction
		
	width: DOUBLE
		-- the size in cm in x direction
		
	position_table_to_world( table_ : Q_VECTOR_2D ) : Q_VECTOR_3D is
		do
			create result.make (root.x + table_.x, zero_level, root.y - table_.y)
		end
	
	direction_table_to_world( table_ : Q_VECTOR_2D ) : Q_VECTOR_3D is
		do
			create result.make (table_.x, 0, -table_.y)
		end
		
	position_world_to_table( world_ : Q_VECTOR_3D ) : Q_VECTOR_2D is
		do
--			create result.make (world_.x - root.x, world_.z + root.y)

-- don't know how this should work in real, but the old one is false
			create result.make (world_.x - root.x, root.y - world_.z )
		end
		
	direction_world_to_table( world_ : Q_VECTOR_3D ) : Q_VECTOR_2D is
		do
			create result.make (world_.x, -world_.z)
		end
feature {NONE} -- internal properties
	root: Q_VECTOR_2D
	
	zero_level: DOUBLE
feature {NONE} -- Implementation
	make_from_file (file_name_: STRING) is
			-- create the model from out of a file
		require
			file_name_ /= void
		local
			loader : Q_GL_3D_ASE_LOADER
		do
			create loader.make
			create balls.make( 15 )
			
			-- create the modell	
			loader.load_file (file_name_)
			model := loader.create_flat_model
			
			-- create the logical modell
			holes := make_holes (loader.shape_objects)
			make_table_size (holes)
			banks := make_banks (loader.shape_objects)
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
--				if curr_.x <= root.x and curr_.y <= root.y then
--					root.set_x_y (curr_.x, curr_.y)
--				end

				if curr_.x <= root.x then
					root.set_x (curr_.x)
				end
				if curr_.y > root.y then
					root.set_y (curr_.y)
				end
				
				index_ := index_ + 1
			end
			
			-- calculate the length
			width := root.x.abs * 2
			
			-- calculate the width
			height := root.y.abs * 2
			
			-- adjust the middle points of the holes
			from
				index_ := holes_.lower
			until
				index_ > holes_.upper
			loop
				curr_ := holes_.item (index_).position
				holes_.item (index_).set_position (position_world_to_table (create {Q_VECTOR_3D}.make (curr_.x, 0, curr_.y)))
				
				index_ := index_ + 1
			end
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
					
					zero_level := shape_.knots.item (index_).y
					
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
								
								list_.extend (create {Q_BANK}.make (
									position_world_to_table (shape_.knots.item(inner_index_)),
									position_world_to_table (shape_.knots.item(inner_index_+1))
								))
							end
						end
						
						inner_index_ := inner_index_ + 1
					end
				end
			
				index_ := index_ + 1	
			end
			
			-- copy the banks to the result set
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
