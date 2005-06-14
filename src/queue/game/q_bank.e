indexing
	description: "Physical bank representation"
	author: "Andreas Kaegi"
	
class
	Q_BANK

inherit
	Q_OBJECT
	redefine
		bounding_object
	end

create
	make,
	make_empty

feature {NONE} -- create

	make_empty is
			-- Create new empty line.
		do
			bounding_object := create {Q_BOUNDING_LINE}.make_empty
		end
		
	make (edge1_, edge2_: Q_VECTOR_2D) is
			-- Create new line with edges e1 and e2.
		require
			edge1_ /= void
			edge2_ /= void
		do
			bounding_object := create {Q_BOUNDING_LINE}.make (edge1_, edge2_)
		end


feature -- interface
		
	set_edge1 (e1: Q_VECTOR_2D) is
			-- Set edge1.
		require
			e1 /= void
		do
			bounding_object.set_edge1 (e1)
		end
		
	set_edge2 (e2: Q_VECTOR_2D) is
			-- Set edge2.
		require
			e2 /= void
		do
			bounding_object.set_edge2 (e2)
		end	

	length: DOUBLE is
			-- Length of bank
		do
			result := bounding_object.length
		end
		
	edge1: Q_VECTOR_2D is
			-- Edge1
		do
			result := bounding_object.edge1
		end
		
	edge2: Q_VECTOR_2D is
			-- Edge2
		do
			result := bounding_object.edge2
		end
	
	bounding_object: Q_BOUNDING_LINE
	
	typeid: INTEGER is 2
			-- Type id for collision response
			
			
feature {Q_PHYS_COLLISION_RESPONSE_HANDLER} -- implementation

end -- class Q_BANK
