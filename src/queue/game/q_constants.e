--
--  queue
--
--  Copyright (C) 2005  
--  Basil Fierz, Severin Hacker, Andreas Kaegi, Benjamin Sigg
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU Library General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
--

indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_CONSTANTS
	
feature -- different modes
--	escape_menu : INTEGER is 10
--	bird_mode :   INTEGER is 20
--	reset_mode:   INTEGER is 30
--	frog_mode :	  INTEGER is 40
--	spin_mode :   INTEGER is 50
--	shoot_mode:	  INTEGER is 60
--	sim_mode:     INTEGER is 70
--	
--	AI_mode : 	  INTEGER is 80
	
feature -- different object types
	ball_type_id :INTEGER is 1
	bank_type_id :INTEGER is 2
	hole_type_id :INTEGER is 3
	
feature -- different balls
	white_number :INTEGER is 0 -- this is the white ball
	
end -- class Q_CONSTANTS
