indexing
	description: "Objects that represent real billard tables with ball, banks and holes"
	author: "Severin Hacker"

class
	Q_TABLE
	
create 
	make

feature -- create

	make (balls_:ARRAY[Q_BALL]; banks_:ARRAY[Q_BANK]; holes_:ARRAY[Q_HOLE]) is
			-- Creates table.
		require
			balls_exist: balls_ /= Void
			
			-- hackers: commented out for testing purposes
			--banks_exist: banks_ /= Void
			--banks_exist: banks_ /= Void
		do
			balls := balls_
			banks := banks_
			holes := holes_
		end

	
feature -- interface

	balls: ARRAY[Q_BALL] 
		-- All balls of the table
		
	banks: ARRAY[Q_BANK]
		-- All banks of the table
		
	holes:ARRAY[Q_HOLE]
		-- All holes of the table
		
	width: REAL
		-- The width of the table
	
	height: REAL
		-- The height of the table
	
	set_balls (balls_: ARRAY[Q_BALL]) is
			-- Set balls.
		require
			balls_exist: balls_ /= Void
		do
			balls := balls_
		ensure
			balls = balls_
		end
		
	set_banks (banks_: ARRAY[Q_BANK]) is
			-- Set banks.
		require
			banks_exist: banks_ /= Void	
		do
			banks := banks_
		ensure
			banks = banks_
		end
		
	set_holes (holes_: ARRAY[Q_HOLE]) is
			-- Set holes.
		require
			-- ace: commented out for testing purposes (no holes yet!)
			-- holes_exist: holes_ /= Void
		do
			holes := holes_
		ensure
			holes = holes_
		end
	
	
feature {NONE} -- implementation

invariant
	balls_exist: balls /= Void
	-- hackers: commented out for testing purposes 
	--banks_exist: banks /= Void

-- ace: commented out for testing purposes (no holes yet!)
			
--	holes_exist: holes /= Void
--	six_banks : banks.count = 6
--	eight_holes: holes.count = 8
--	pos_balls : balls.count >= 0
	
end -- class Q_TABLE
