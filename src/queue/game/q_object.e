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
	description: "Superclass for physical objects."
	author: "Andreas Kaegi"

deferred class
	Q_OBJECT
	
feature -- interface

	do_update_position (step: DOUBLE) is
			-- Update object position for one time step (given in ms).
		require
			step > 0
		do
		end
		
	revert_update_position is
			-- Revert last position update of object
		do
			if old_state /= Void then
				old_state.apply_to (Current)
			end
		end
	
	is_stationary: BOOLEAN is
		do
			result := True
		end
		
	on_collide (other: like Current) is
			-- Collisionn with other detected!
		require
			other /= void
		do
		end

	set_bounding_object (bo: Q_BOUNDING_OBJECT) is
			-- Assign new bounding object.
		require
			bo /= void
		do
			bounding_object := bo	
		end
		
	bounding_object: Q_BOUNDING_OBJECT
			-- Currently assigned bounding object

	old_state: Q_PHYS_STATE
			-- Old variables
	
	typeid: INTEGER is
			-- Makes life easy :-) (Collision response)
		deferred
		end	

end -- class Q_OBJECT
