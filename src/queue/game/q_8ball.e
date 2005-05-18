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
			-- creates/returns the opening table for this game mode, all balls are in a triangle, the white is set at the head of table
		local
			balls_: ARRAY[Q_BALL]
			banks_: ARRAY[Q_BANK]
			holes_: ARRAY[Q_HOLE]
			ball_ : Q_BALL
			bank_ : Q_BANK
			hole_ : Q_HOLE
			i : INTEGER
		do
			-- create the balls
			
			-- create the white ball
			create ball_.make_empty
			-- create the full balls 1-7
			from
				i := 1
			until
				i = 7
			loop
				
				i := i+1
			end
			-- create the 8 (black) ball
			
			-- create the half balls 9-15
		end
		
	table_model: Q_TABLE_MODEL is
			-- creates/returns a 3D-model of the table for this game mode
	
		do	
		end
		
	ai_player: Q_AI_PLAYER is
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
		
	

feature {NONE} -- Implementation

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
