indexing
	description: "Objects that represent real billard tables with ball, banks and holes"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_TABLE
	
create make
	
feature -- Interface

	balls:ARRAY[BALL] -- all balls of the table
	banks:ARRAY[BANK] -- all banks of the table
	holes:ARRAY[HOLE] -- all holes of the table
	
	set_balls(balls_ : ARRAY[BALL]) is
			-- sets the balls of this table
		require
			balls_exist: balls_ /= Void
		do
			balls := balls_
		ensure
			balls = balls_
		end
		
	set_banks(banks_ : ARRAY[BANK]) is
			-- sets the banks of this table
		require
			banks_exist: banks_ /= Void	
		do
			banks := banks_
		ensure
			banks = banks_
		end
		
	set_holes(holes_ : ARRAY[HOLE]) is
			-- sets the holes of this table
		require
			holes_exist: holes_ /= Void
		do
			holes := holes_
		ensure
			holes = holes_
		end
	
	make(balls_:ARRAY[BALL]; banks_:ARRAY[BANK]; holes_:ARRAY[HOLE]) is
			-- creates a table
		require
			balls_exist: balls_ /= Void
			banks_exist: banks_ /= Void
			banks_exist: banks_ /= Void
		do
			balls := balls_
			banks := banks_
			holes := holes_
		end

		
feature{NONE} -- Implementation

invariant
	balls_exist: balls /= Void
	banks_exist: banks /= Void
	banks_exist: banks /= Void
	six_banks : banks.count = 6
	eight_holes: holes.count = 8
	pos_balls : balls.count >= 0
	
end -- class Q_TABLE
