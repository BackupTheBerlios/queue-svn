indexing
	description: "The ETH mode is a single player mode. The starting table is an ETH logo written with balls. "
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_ETH

inherit
	Q_8BALL
	redefine
		identifier,
		new_table,
		ball_number_to_texture_name,
		number_of_balls,
		make
	end
	
creation
	make

feature -- Interface

	make is
			-- create an eth mode
		do
			precursor
		end
		
		
	identifier :STRING is "eth"	
	
	number_of_balls : INTEGER is 28
feature {NONE} -- Implementation
	
	new_table is
			-- create an eth table
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
			create balls_.make (0,28)
			
			-- create the white ball
			create ball_.make_empty
			ball_.set_radius (ball_radius)
			ball_.set_number (white_number)
			ball_.set_center (head_point)
			balls_.force (ball_,white_number)
			
			-- create the rest of the balls
			from
				nr := 1
			until
				nr > 28
			loop
				ball_ := ball_.deep_twin				
				ball_.set_number (nr)
				ball_.set_center (eth_position (nr))
				balls_.force (ball_,nr)
				nr := nr +1
			end
			create table.make (balls_, table_model.banks, table_model.holes)
			link_table_and_balls
		end
		
	ball_number_to_texture_name (number_: INTEGER):STRING is
			-- convertes the ball number to the apropriate texture name
		do
			inspect number_
				when  0 then result := "model/voll_00_weiss.png"
				else  
					result := "model/voll_08_schwarz.png"
			end
		
		end
		
	eth_position(nr_:INTEGER):Q_VECTOR_2D is
			-- give a position in the ETH created by balls
		do
			inspect nr_
			when 1 then create result.make (root_point.x+8*ball_radius, root_point.y-8*ball_radius)
			when 2 then create result.make (root_point.x+8*ball_radius, root_point.y-6*ball_radius)
			when 3 then create result.make (root_point.x+8*ball_radius, root_point.y-4*ball_radius)
			when 4 then create result.make (root_point.x+8*ball_radius, root_point.y-2*ball_radius)
			when 5 then create result.make (root_point.x+8*ball_radius, root_point.y)
			when 6 then create result.make (root_point.x+8*ball_radius, root_point.y+2*ball_radius)
			when 7 then create result.make (root_point.x+8*ball_radius, root_point.y+4*ball_radius)
			when 8 then create result.make (root_point.x+8*ball_radius, root_point.y+8*ball_radius)
			when 9 then create result.make (root_point.x+6*ball_radius, root_point.y-8*ball_radius)
			when 10 then create result.make (root_point.x+6*ball_radius, root_point.y)
			when 11 then create result.make (root_point.x+6*ball_radius, root_point.y+4*ball_radius)
			when 12 then create result.make (root_point.x+6*ball_radius, root_point.y+8*ball_radius)
			when 13 then create result.make (root_point.x+4*ball_radius, root_point.y-8*ball_radius)
			when 14 then create result.make (root_point.x+4*ball_radius, root_point.y-6*ball_radius)
			when 15 then create result.make (root_point.x+4*ball_radius, root_point.y)
			when 16 then create result.make (root_point.x+4*ball_radius, root_point.y+4*ball_radius)
			when 17 then create result.make (root_point.x+4*ball_radius, root_point.y+6*ball_radius)
			when 18 then create result.make (root_point.x+4*ball_radius, root_point.y+8*ball_radius)
			when 19 then create result.make (root_point.x+2*ball_radius, root_point.y-8*ball_radius)
			when 20 then create result.make (root_point.x+2*ball_radius, root_point.y)
			when 21 then create result.make (root_point.x+2*ball_radius, root_point.y+4*ball_radius)
			when 22 then create result.make (root_point.x+2*ball_radius, root_point.y+8*ball_radius)
			when 23 then create result.make (root_point.x, root_point.y-8*ball_radius)
			when 24 then create result.make (root_point.x, root_point.y-6*ball_radius)
			when 25 then create result.make (root_point.x, root_point.y-4*ball_radius)
			when 26 then create result.make (root_point.x, root_point.y)
			when 27 then create result.make (root_point.x, root_point.y+4*ball_radius)
			when 28 then create result.make (root_point.x, root_point.y+8*ball_radius)
			end
		end
		
		
end -- class Q_ETH
