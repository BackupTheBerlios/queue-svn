indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_CONSTANTS
	
feature -- different modes
	escape_menu : INTEGER is 10
	bird_mode :   INTEGER is 20
	reset_mode:   INTEGER is 30
	frog_mode :	  INTEGER is 40
	spin_mode :   INTEGER is 50
	shoot_mode:	  INTEGER is 60
	sim_mode:     INTEGER is 70
	
	AI_mode : 	  INTEGER is 80
	
feature -- different object types
	ball_type_id :INTEGER is 1
	bank_type_id :INTEGER is 2
	hole_type_id :INTEGER is 3
	
feature -- different balls
	white_number :INTEGER is 0 -- this is the white ball
end -- class Q_CONSTANTS
