indexing
	description: "Main class of the physics cluster. Called by the game loop."
	author: "Andreas Kaegi"

class
	Q_SIMULATION

feature -- interface

	new is
			-- Start a new simulation.
		do
		end
		
	step (table: Q_TABLE) is
			-- Compute one step of the current simulation.
		require
			ta
		do
			
		end
		

feature {NONE} -- implementation

end -- class SIMULATION
