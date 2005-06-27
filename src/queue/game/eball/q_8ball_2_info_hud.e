indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_8BALL_2_INFO_HUD

inherit
	Q_2_INFO_HUD
	redefine
		make_ordered
	end
	
creation
	make_ordered
	
feature{NONE}
	make_ordered( big_top_ : BOOLEAN ) is
		do
			precursor( big_top_ )
			
			left_balls := make_ball_list( left )
			right_balls := make_ball_list( right )
		end
		
	make_ball_list( panel_ : Q_HUD_CONTAINER ) : ARRAY[ Q_HUD_BALL ] is
		local
			size_, y_ : DOUBLE
			index_ : INTEGER
			ball_ : Q_HUD_BALL
		do
			size_ := panel_.width / 7
			y_ := panel_.height
			
			create result.make( 1, 7 )
			from index_ := result.lower	until index_ > result.upper loop
				create ball_.make
				result.put( ball_, index_ )
				panel_.add( ball_ )
				ball_.set_bounds( (index_-result.lower)*size_, y_, size_, size_ )
				
				index_ := index_ + 1
			end
		end
		
		
	left_balls, right_balls : ARRAY[ Q_HUD_BALL ]

feature
	set_left_ball( ball_ : Q_BALL_MODEL; index_ : INTEGER ) is
		do
			left_balls.item( index_ ).set_ball( ball_ )
		end
		
	set_right_ball( ball_ : Q_BALL_MODEL; index_ : INTEGER ) is
		do
			right_balls.item( index_ ).set_ball( ball_ )
		end
		
	remove_all_balls is
		local
			index_ : INTEGER
		do
			from index_ := left_balls.lower until index_ > left_balls.upper	loop
				left_balls.item( index_ ).set_ball( void )
				index_ := index_ + 1
			end
			
			from index_ := right_balls.lower until index_ > right_balls.upper	loop
				right_balls.item( index_ ).set_ball( void )
				index_ := index_ + 1
			end
		end
		

end -- class Q_8BALL_2_INFO_HUD
