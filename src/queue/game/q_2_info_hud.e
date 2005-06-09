indexing
	description: "A hud menu showing a big and a small label for two informations. One of the label-group can be active."
	author: "Benjamin Sigg"

class
	Q_2_INFO_HUD

inherit
	Q_HUD_CONTAINER
	redefine
		enqueue
	end

creation
	make_ordered
	
feature{NONE}
	make_ordered( big_top_ : BOOLEAN ) is
		local
			panel_ : Q_HUD_PANEL
			container_ : Q_HUD_CONTAINER_3D
		do
			make

			create left.make
			create right.make
			create plane.make
			
			create big_left.make
			create big_right.make
			create small_left.make
			create small_right.make

			create panel_.make
			create container_.make
			
			panel_.set_bounds( 0, 0, 0.4, 0.2 )
			plane.add( panel_ )
			
			if big_top_ then
				big_left.set_bounds( 0, 0, 0.4, 0.09 )
				small_left.set_bounds( 0.05, 0.1, 0.35, 0.1 )
				big_right.set_bounds( 0, 0, 0.4, 0.09 )
				small_right.set_bounds( 0.05, 0.1, 0.35, 0.1 )				
			else
				big_left.set_bounds( 0, 0.1, 0.4, 0.1 )
				small_left.set_bounds( 0.0, 0, 0.35, 0.09 )
				big_right.set_bounds( 0, 0.1, 0.4, 0.1 )
				small_right.set_bounds( 0.0, 0, 0.35, 0.09 )				
			end

			left.add( big_left )
			left.add( small_left )
			right.add( big_right )
			right.add( small_right )
			
			left.set_bounds( 0.0, 0, 0.4, 0.2 )
			right.set_bounds( 0.5, 0, 0.4, 0.2 )
			plane.set_bounds( 0.0, 0, 0.9, 0.2 )
			
			add( left )
			add( right )
			add( plane )
			
			set_size( 0.9, 0.2 )
			
			force_no_active
		end
		
feature{NONE} -- hud
	left, right, plane : Q_HUD_SLIDING_3D
	
	big_left, small_left, big_right, small_right : Q_HUD_LABEL
	
feature -- hud
	set_big_left_text( text_ : STRING ) is
		do
			big_left.set_text( text_ )
		end

	set_small_left_text( text_ : STRING ) is
		do
			small_left.set_text( text_ )
		end
		
	set_big_right_text( text_ : STRING ) is
		do
			big_right.set_text( text_ )
		end
		
	set_small_right_text( text_ : STRING ) is
		do
			small_right.set_text( text_ )
		end

	set_left_active is
		do
			plane.move_to( create {Q_VECTOR_3D}.make( 0, 0, 0.11 ))
			left.move_to( create {Q_VECTOR_3D}.make( 0, 0, 0 ))
			right.move_to( create {Q_VECTOR_3D}.make( 0, 0, 0.1 ))
		end
		
	set_right_active is
		do
			plane.move_to( create {Q_VECTOR_3D}.make( -0.5, 0, 0.11 ))
			left.move_to( create {Q_VECTOR_3D}.make( 0, 0, 0.1 ))
			right.move_to( create {Q_VECTOR_3D}.make( 0, 0, 0 ))			
		end
	
	set_no_active is
		do
			plane.move_to( create {Q_VECTOR_3D}.make( -0.25, 0, 0.3 ))
			left.move_to( create {Q_VECTOR_3D}.make( 0, 0, 0.2 ))
			right.move_to( create {Q_VECTOR_3D}.make( 0, 0, 0.2 ))
		end
		
	force_no_active is
		do
			plane.set_position( create {Q_VECTOR_3D}.make( -0.25, 0, 0.3 ))
			left.set_position( create {Q_VECTOR_3D}.make( 0, 0, 0.2 ))
			right.set_position( create {Q_VECTOR_3D}.make( 0, 0, 0.2 ))			
		end
		
		
feature -- queue
	enqueue( queue_: Q_HUD_QUEUE ) is
		do
			precursor( queue_ )
		end	

end -- class Q_2_INFO_HUD
