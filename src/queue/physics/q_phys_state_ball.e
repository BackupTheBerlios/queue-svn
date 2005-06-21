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
	description: "Captures the changing vars of a ball"
	author: "Andreas Kaegi"

class
	Q_PHYS_STATE_BALL
	
inherit
	Q_PHYS_STATE
	redefine
		apply_to
	end

create
	make
	
feature -- create

	make is
			-- Creation proc.
		do
			create bounding_object.make_empty
			create velocity.default_create
			create angular_velocity.default_create
		end
		
feature -- interface

	assign (bo: Q_BOUNDING_CIRCLE; v: Q_VECTOR_2D; av: Q_VECTOR_3D) is
			-- Create ball state
		do
--			bounding_object := bo.deep_twin
--			velocity := v.twin
--			angular_velocity := av.twin

			bounding_object.copy (bo)
			velocity.make_from_other (v)
			angular_velocity.make_from (av)

		end
		
	apply_to (o: Q_BALL) is
			-- Assign variable values to object
		do
--			o.set_bounding_object (bounding_object)
--			o.set_velocity (velocity)
--			o.set_angular_velocity (angular_velocity)
			
			o.bounding_object.copy (bounding_object)
--			o.angular_velocity.make_from (angular_velocity)
		end
		
	center: Q_VECTOR_2D is
			-- Center of bounding circle
		do
			result := bounding_object.center
		end
		

feature {Q_BALL} -- implementation

	bounding_object: Q_BOUNDING_CIRCLE
	
	velocity: Q_VECTOR_2D
	
	angular_velocity: Q_VECTOR_3D
	

end -- class Q_PHYS_STATE_BALL
