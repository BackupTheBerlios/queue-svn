indexing
	description: "Physical bank representation"
	author: "Andreas Kaegi"
	
class
	Q_BANK

inherit
	Q_OBJECT

create
	make,
	make_empty
	
feature {NONE} -- create

	make_empty is
			-- Create new empty line.
		do
			create bounding_line.make_empty
			bounding_object := bounding_line
		end
		
	make (edge1_, edge2_: Q_VECTOR_2D) is
			-- Create new line with edges e1 and e2.
		require
			edge1_ /= void
			edge2_ /= void
		do
			create bounding_line.make (edge1_, edge2_)
			bounding_object := bounding_line
			
		end


feature -- interface

	update_position (step: DOUBLE) is
			-- Do not update position since bank does not move.
		do
		end
	
	on_collide (other: like Current) is
			-- Collisionn with other detected!
		do
		end
		
	set_edge1 (e1: Q_VECTOR_2D) is
			-- Set edge1.
		require
			e1 /= void
		do
			bounding_line.set_edge1 (e1)
		end
		
	set_edge2 (e2: Q_VECTOR_2D) is
			-- Set edge2.
		require
			e2 /= void
		do
			bounding_line.set_edge2 (e2)
		end	

	edge1: Q_VECTOR_2D is
			-- Edge1
		do
			result := bounding_line.edge1
		end
		
	edge2: Q_VECTOR_2D is
			-- Edge2
		do
			result := bounding_line.edge2
		end
		
	typeid: INTEGER is 2
			-- Type id for collision response
			
			
feature {Q_PHYS_COLLISION_RESPONSE_HANDLER} -- implementation
		
	bounding_line: Q_BOUNDING_LINE

end -- class Q_BANK
