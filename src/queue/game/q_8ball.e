indexing
	description: "This class implements the official 8-Ball billard game and rules (according to www.billardaire.de)"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_8BALL

inherit
	Q_MODE
	Q_CONSTANTS
	
create
	make	

feature -- Interface
	
	make is
			-- creation procedure
		do
			-- create the model and the table
			new_table_model
			new_table
		end
		
	table : Q_TABLE	
	table_model: Q_TABLE_MODEL
	ball_models: ARRAY[Q_BALL_MODEL]
	ai_player : Q_AI_PLAYER
	
	ball_to_ball_model(ball_ :Q_BALL):Q_BALL_MODEL is
			-- see base class
		do
			
		end

	position_table_to_world( table_ : Q_VECTOR_2D ) : Q_VECTOR_3D is
		do
			Result := table_model.position_table_to_world (table_)
		end
	
	direction_table_to_world( table_ : Q_VECTOR_2D ) : Q_VECTOR_3D is
		do
			Result := table_model.direction_table_to_world (table_)
		end
		
	position_world_to_table( world_ : Q_VECTOR_3D ) : Q_VECTOR_2D is
		do
			Result := table_model.position_world_to_table (world_)
		end
		
	direction_world_to_table( world_ : Q_VECTOR_3D ) : Q_VECTOR_2D is
		do
			Result := table_model.position_world_to_table (world_)
		end
		
	origin: Q_VECTOR_2D is
			-- the (0,0) of the table, this is the lower left corner, when the triangle is in the upper half
		do
			
		end
		
	root_point :Q_VECTOR_2D is
		-- fusspunkt of the table
		do
			--Result := table_model.root
		end
		
	head_point : Q_VECTOR_2D is
		-- the point in the middle of the head line (kopflinie)
		do
			create Result.make(100,100)
		end
		
	ball_radius : DOUBLE is 5.0
	width: DOUBLE is
			-- the size of the table in x-direction
		do
			result := table_model.width
		end
	height: DOUBLE is
			-- the size of the table in y-direction
		do
			result := table_model.height
		end


feature {NONE} -- Implementation

	new_table is
			-- creates the opening table for this game mode, all balls are in a triangle, the white is set at the head of the table
		local
			balls_: ARRAY[Q_BALL]
			ball_ : Q_BALL
			y,nr : INTEGER
			rand_ : Q_RANDOM
			used_integers : LINKED_LIST[INTEGER]
		do
			create rand_
			-- build positions
			create used_integers.make
			
			-- create the balls
			create balls_.make (0,15)
			
			-- create the white ball
			create ball_.make_empty
			ball_.set_radius (ball_radius)
			
			ball_.set_number (white_number)
			ball_.set_center (head_point)		
			balls_.force (ball_,white_number)
			used_integers.force (white_number)
			-- create the 8 (black) ball
			ball_ := ball_.deep_twin
			ball_.set_number(8)
			ball_.set_center (create {Q_VECTOR_2D}.make (root_point.x+0.866025*(4*ball_radius),root_point.y))
			balls_.force (ball_,8)
			used_integers.force (8)
			
			-- create left rack
			ball_ := ball_.deep_twin			
			from
			until
				not used_integers.has (nr)
			loop				
				nr := rand_.random_range(1,15)
			end
			ball_.set_number (nr)
			ball_.set_center (create {Q_VECTOR_2D}.make (root_point.x+0.866025*(8*ball_radius), root_point.y-4*ball_radius))
			balls_.force (ball_,nr)
			used_integers.force(nr)
			
			-- create right rack
			ball_ := ball_.deep_twin	
			if nr <8 then
				nr := rand_.random_range(9,15)
			else
				nr := rand_.random_range(1,7)
			end
			ball_.set_number (nr)
			ball_.set_center (create {Q_VECTOR_2D}.make (root_point.x+0.866025*(8*ball_radius), root_point.y+4*ball_radius))
			balls_.force (ball_,nr)
			used_integers.force(nr)
			
			-- create the last line
			from
				y := -2
			until
				y > 2
			loop
				ball_ := ball_.deep_twin				
				from
				until
					not used_integers.has (nr)
				loop				
					nr := rand_.random_range(1,15)
				end
				ball_.set_number (nr)
				ball_.set_center (create {Q_VECTOR_2D}.make (root_point.x+0.866025*(8*ball_radius), root_point.y+(y*ball_radius)))
				used_integers.force(nr)
				balls_.force (ball_,nr)
				y := y +2
			end
			-- create the second last line
			from
				y := -3
			until
				y > 3
			loop
				ball_ := ball_.deep_twin				
				from
				until
					not used_integers.has (nr)
				loop				
					nr := rand_.random_range(1,15)
				end
				ball_.set_number (nr)
				ball_.set_center (create {Q_VECTOR_2D}.make (root_point.x+0.866025*(6*ball_radius), root_point.y+(y*ball_radius)))
				used_integers.force(nr)
				balls_.force (ball_,nr)
				y := y +2
			end
			-- create the middle line
			from
				y := -2
			until
				y > 2
			loop
				ball_ := ball_.deep_twin				
				from
				until
					not used_integers.has (nr)
				loop				
					nr := rand_.random_range(1,15)
				end
				ball_.set_number (nr)
				ball_.set_center (create {Q_VECTOR_2D}.make (root_point.x+0.866025*(4*ball_radius), root_point.y+(y*ball_radius)))
				used_integers.force(nr)
				balls_.force (ball_,nr)
				y := y +4 -- skip the black ball
			end
			-- create the second line
			from
				y := -1
			until
				y > 1
			loop
				ball_ := ball_.deep_twin				
				from
				until
					not used_integers.has (nr)
				loop				
					nr := rand_.random_range(1,15)
				end
				ball_.set_number (nr)
				ball_.set_center (create {Q_VECTOR_2D}.make (root_point.x+0.866025*(2*ball_radius), root_point.y+(y*ball_radius)))
				used_integers.force(nr)
				balls_.force (ball_,nr)
				y := y +2
			end
			-- create first ball
			ball_ := ball_.deep_twin				
			from
			until
				not used_integers.has (nr)
			loop				
				nr := rand_.random_range(1,15)
			end
			ball_.set_number (nr)
			ball_.set_center (create {Q_VECTOR_2D}.make (root_point.x,root_point.y))
			used_integers.force(nr)
			balls_.force (ball_,nr)
			create table.make (balls_, table_model.banks, table_model.holes)
		end
		
	new_table_model is
			-- creates/returns a 3D-model of the table for this game mode
		do
			create table_model.make_from_file ("model/pool.ase")
		end
		
	new_ai_player is
			-- creates/returns an AI-Player for this game mode
		do
		end
		

	is_correct_opening(collisions_: LIST[Q_COLLISION_EVENT]):BOOLEAN is
			-- this implements rule 4.6 for a correct opening, the definition
		local
			ball_fallen_, four_balls_: BOOLEAN
			touched_balls_: LINKED_LIST[INTEGER]
			ball_ : Q_BALL
			
		do
			-- (a) a ball has fallen into a hole
			ball_fallen_ := is_any_ball_in_hole(collisions_)
			
			-- (b) or at least four balls have touched a bank
			create touched_balls_.make
			
			from
				collisions_.start
			until
				collisions_.after
			loop
				if collisions_.item.defendent.typeid = bank_type_id then
					-- it is a collision with a bank the aggressor must be a ball
					ball_ ?= collisions_.item.aggressor
					if not touched_balls_.has (ball_.number) then
						touched_balls_.force (ball_.number)
					end
				end
				collisions_.forth
			end
			four_balls_ := touched_balls_.count >=4
			
			Result := ball_fallen_ or else four_balls_
		end
		
	is_correct_shot(collisions_ :LIST[Q_COLLISION_EVENT]; player_: Q_PLAYER): BOOLEAN is
			-- implements rule 4.12 correct shot, definition
		require
			collisions_ /= Void
			player_ /= Void
		local
			own_colored_first_ :BOOLEAN
			colored_ball_fallen_ : BOOLEAN
			any_bank_touched_ : BOOLEAN
		do
			own_colored_first_ := first_ball_collision (collisions_).owner.has (player_)
			colored_ball_fallen_ := is_any_ball_in_hole (collisions_) and not is_ball_in_hole (white_number,collisions_)	
			from
				collisions_.start
			until
				collisions_.after
			loop
				any_bank_touched_ := any_bank_touched_ or collisions_.item.defendent.typeid = bank_type_id
				collisions_.forth
			end
			
			Result := own_colored_first_ and then (colored_ball_fallen_ or else any_bank_touched_)
		end

	is_any_ball_in_hole(collisions_: LIST[Q_COLLISION_EVENT]): BOOLEAN is
			-- has any ball fallen into a hole?
		require
			collisions_ /= Void
		do
			Result := false
			from 
				collisions_.start
			until
				collisions_.after
			loop
				Result := Result or collisions_.item.defendent.typeid = hole_type_id
				collisions_.forth
			end
		end
		
	is_ball_in_hole(ball_number_:INTEGER ; collisions_:LIST[Q_COLLISION_EVENT]): BOOLEAN is
			-- has the ball with ball_number fallen into a hole?
		require
			collisions_ /= Void
		local
			ball_ : Q_BALL
		do
			Result := false
			from 
				collisions_.start
			until
				collisions_.after
			loop
				if collisions_.item.defendent.typeid = hole_type_id then
					ball_ ?= collisions_.item.aggressor
					Result := Result or ball_.number = ball_number_
				end
				collisions_.forth
			end
		end		
		
	first_ball_collision(collisions_:LIST[Q_COLLISION_EVENT]): Q_BALL is
			-- returns the ball that the did the first collision with the white ball
		require
			collisions_ /= Void
		do
			Result ?= collisions_.first.defendent	
		end
		
invariant
	invariant_clause: True -- Your invariant here

end -- class Q_8BALL
