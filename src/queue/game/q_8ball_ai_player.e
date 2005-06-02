indexing
--	description: "Objects that implement a simple AI player. The algorithm computes for all balls
--	the nearest hole and looks whether a direct shot might bring the ball into the hole. The ability
--	of the AI player can vary with random variations in the shot direction and shot strength."
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_8BALL_AI_PLAYER

inherit
	Q_AI_PLAYER
	MATH_CONST

create
	make
	
feature
	
	ability : INTEGER
	
	set_ability (ability_ :INTEGER) is
			-- set the ability of the AI-player
		do
			ability := ability_
		end
		
	make is
			-- creates a default 8Ball-AI-player
		do
			ability := 5
		end
		
	next_shot(gr_ : Q_GAME_RESSOURCES) : Q_SHOT is
			-- compute the "best" next shot
		local
			possible_direct_shots_ : LINKED_LIST[Q_SHOT]
			i,j :INTEGER
			shot_ : Q_SHOT
			obstacle_free : BOOLEAN
			rand_ : Q_RANDOM
		do
			create rand_
			table := gr_.table
			create possible_direct_shots_.make
			-- compute possible shots
			from
				i := table.balls.lower
			until
				i > table.balls.upper
			loop
				-- if I am the owner of this ball
				if table.balls.item (i).owner.has (Current) then
					from
						j := table.holes.lower
					until
						j > table.holes.upper
					loop
						create shot_.make(gr_.simulation.cue_vector_for_collision (table.balls.item (i), table.holes.item(j).position))
						obstacle_free := is_obstacle_free (table.balls.item(i), table.holes.item(j).position)
						if shot_ /= void and then obstacle_free then
							possible_direct_shots_.force (shot_)
						end
						j := j+1
					end	
				end
				i := i+1
			end
			-- if there is no meaningful direct shot, just make a dummy random shot
			if possible_direct_shots_.is_empty then
				Result := create {Q_SHOT}.make (create {Q_VECTOR_2D}.make (rand_.random_range (-5,5),rand_.random_range (-5,5)))
			else
				Result := possible_direct_shots_.first
				Result.direction.rotate (rand_.random_gaussian (0,ability_to_variance))
			end
		end
		
feature {NONE}
	
	table : Q_TABLE
	
	ability_to_variance:DOUBLE is
			-- compute the variance for a given ability
			-- must be 0 for ability = 10
		do
			Result := 10-ability
		ensure
			ability = 10 implies result.rounded = 0
		end
		
	nearest_hole(ball_ :Q_BALL): Q_HOLE is
			-- compute the nearest hole for ball ball_
		local
			i: INTEGER
			min_: DOUBLE
		do
			from 
				Result := table.holes.item (table.holes.lower)
				i := table.holes.lower
				min_ := 1000000
			until
				i > table.holes.upper
			loop
				if ball_.center.distance (table.holes.item(i).position)< min_ then
					min_ := ball_.center.distance (table.holes.item(i).position)
					Result := table.holes.item(i)
				end
				i := i+1
			end
		ensure
			Result /= Void
		end
		
	
	is_obstacle_free(ball_: Q_BALL; target_: Q_VECTOR_2D): BOOLEAN is
			-- is the way from ball_'s position to target free of other balls?
		local
			i : INTEGER
			gliding_area_ : ORTHOGONAL_RECTANGLE
			ball_to_target_: Q_VECTOR_2D
			ortho_ : Q_VECTOR_2D
		do
			ball_to_target_ := target_.deep_twin
			ball_to_target_ := ball_to_target_ - (ball_.center)
			ortho_ := ball_to_target_.deep_twin
			ortho_.rotate (-pi/2)
			ortho_.normalize
			ortho_.scale_to (ball_.radius*2)
			create gliding_area_.make (ball_.center + ortho_, ball_.center+ball_to_target_-ortho_)
			from
				i := table.balls.lower
			until
				i > table.balls.upper
			loop
				Result := Result and gliding_area_.has (table.balls.item (i).center)
				i := i+1
			end
		end
		
	
end -- class Q_8BALL_AI_PLAYER
