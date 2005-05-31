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

		end
		
	table: Q_TABLE is
			-- creates/returns the opening table for this game mode, all balls are in a triangle, the white is set at the head of the table
		local
			balls_: ARRAY[Q_BALL]
			banks_: ARRAY[Q_BANK]
			holes_: ARRAY[Q_HOLE]
			ball_ : Q_BALL
			bank_ : Q_BANK
			hole_ : Q_HOLE
			i,x,y,nr : INTEGER
			rand_ : RANDOM
			center_ : Q_VECTOR_2D
			used_integers : LINKED_LIST[INTEGER]
		do
			-- build positions
			create used_integers.make
			
			-- create the balls
			create balls_.make (0,15)
			
			-- create the white ball
			create ball_.make_empty
			ball_.set_number (white_number)
			ball_.set_center (head_point)		
			balls_.force (ball_,white_number)
			used_integers.force (white_number)
			-- create the 8 (black) ball
			ball_ := ball_.twin
			ball_.set_number(8)
			create center_.make(root_point.x+0.866025*(4*ball_radius),root_point.y)
			ball_.set_center (center_)
			balls_.force (ball_,8)
			used_integers.force (8)
			
			-- create left rack
			ball_ := ball_.twin			
			from
			until
				not used_integers.has (nr)
			loop				
				nr := random_range(1,15)
			end
			ball_.set_number (nr)
			center_ := center_.twin
			center_.set_x_y (root_point.x+0.866025*(8*ball_radius), root_point.y-4*ball_radius)
			ball_.set_center(center_)
			balls_.force (ball_,nr)
			used_integers.force(nr)
			
			-- create right rack
			ball_ := ball_.twin	
			if nr <8 then
				nr := random_range(9,15)
			else
				nr := random_range(1,7)
			end
			ball_.set_number (nr)
			center_ := center_.twin
			center_.set_x_y(root_point.x+0.866025*(8*ball_radius), root_point.y+4*ball_radius)
			ball_.set_center(center_)
			balls_.force (ball_,nr)
			used_integers.force(nr)
			
			-- create the last line
			from
				y := -2
			until
				y > 2
			loop
				ball_ := ball_.twin				
				from
				until
					not used_integers.has (nr)
				loop				
					nr := random_range(1,15)
				end
				ball_.set_number (nr)
				center_ := center_.twin
				center_.set_x_y(root_point.x+0.866025*(8*ball_radius), root_point.y+(y*ball_radius))
				ball_.set_center(center_)
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
				ball_ := ball_.twin				
				from
				until
					not used_integers.has (nr)
				loop				
					nr := random_range(1,15)
				end
				ball_.set_number (nr)
				center_ := center_.twin
				center_.set_x_y(root_point.x+0.866025*(6*ball_radius), root_point.y+(y*ball_radius))
				ball_.set_center(center_)
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
				ball_ := ball_.twin				
				from
				until
					not used_integers.has (nr)
				loop				
					nr := random_range(1,15)
				end
				ball_.set_number (nr)
				center_ := center_.twin
				center_.set_x_y(root_point.x+0.866025*(4*ball_radius), root_point.y+(y*ball_radius))
				ball_.set_center(center_)
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
				ball_ := ball_.twin				
				from
				until
					not used_integers.has (nr)
				loop				
					nr := random_range(1,15)
				end
				ball_.set_number (nr)
				center_ := center_.twin
				center_.set_x_y(root_point.x+0.866025*(2*ball_radius), root_point.y+(y*ball_radius))
				ball_.set_center(center_)
				used_integers.force(nr)
				balls_.force (ball_,nr)
				y := y +2
			end
			-- create first ball
			ball_ := ball_.twin				
			from
			until
				not used_integers.has (nr)
			loop				
				nr := random_range(1,15)
			end
			ball_.set_number (nr)
			center_ := center_.twin
			center_.set_x_y(root_point.x,root_point.y)
			ball_.set_center(center_)
			used_integers.force(nr)
			balls_.force (ball_,nr)
			create Result.make (balls_, void, void)
		end
		
	table_model: Q_TABLE_MODEL is
			-- creates/returns a 3D-model of the table for this game mode
	
		do	
		end
		
	ai_player: Q_AI_PLAYER is
			-- creates/returns an AI-Player for this game mode
		do
		end
		
	root_point : Q_VECTOR_2D is
		-- fusspunkt of the table
		do
			create Result.make (100,100)
		end
	head_point : Q_VECTOR_2D is
		-- the point in the middle of the head line (kopflinie)
		do
			create Result.make(200,100)
			
		end
	ball_radius : DOUBLE is 5.0


feature {NONE} -- Implementation

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
			own_colored_first_ := first_ball_collision (collisions_).owner = player_
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
		
	random_range(min:INTEGER; max:INTEGER): INTEGER is
			-- returns random in the range [min..max]
		local 
			r_: RANDOM
		do
			create r_.make
			Result := (r_.double_i_th (random_i)*(max-min)+min).rounded
			random_i := random_i+1
		ensure
			result >= min and result <= max
		end
		
	random_i :INTEGER
invariant
	invariant_clause: True -- Your invariant here

end -- class Q_8BALL
