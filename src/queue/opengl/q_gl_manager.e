indexing
	description: "An outside view of the GL-Tree. Used to exchange some parts of the tree"
	author: "Benjamin Sigg"

class
	Q_GL_MANAGER

creation
	make
	
feature{NONE} -- creation
	make is
			-- Creates the manager
		do
			create root.init_lighting( false )
			create group.make
			
			create camera
			create navigator.make_camera( camera )
			
			root.set_transform( camera ) 
			navigator.set_bounds( 0, 0, 1, 1 )
			root.hud.add( navigator )
			root.set_inside( group )
		end
		
feature{NONE} -- internal values
	root : Q_GL_ROOT
	
	navigator : Q_HUD_CAMERA_NAVIGATOR
	
	group : Q_GL_GROUP[ Q_GL_OBJECT ]
	
feature -- manage GL-Tree
	draw is
			-- Draws the GL-part
		do
			root.draw
		end
		
	process( events_ : Q_EVENT_QUEUE ) is
		do
			root.hud.process( events_ )
		end
		
		
	unused_events : Q_EVENT_QUEUE is
			-- A queue of all events, that are not used by the HUD
		do
			result := root.hud.unused_events
		end
	
	hud : Q_HUD_COMPONENT
		-- the component set by a state
		
	set_hud( hud_ : Q_HUD_COMPONENT ) is
			-- 
		do
			if hud /= void then
				navigator.remove( hud )
			end
			
			hud := hud_
			
			if hud /= void then
				navigator.add( hud )
			end
		end
	
	camera : Q_GL_CAMERA
	
	camera_behaviour : Q_CAMERA_BEHAVIOUR is
		do
			result := navigator.behaviour
		end
	
	set_camera_behaviour( behaviour_ : Q_CAMERA_BEHAVIOUR ) is
			-- Sets the camera-behaviour. How the camera reacts on different events.
		do
			navigator.set_behaviour( behaviour_ )
		end
		
	add_object( object_ : Q_GL_OBJECT ) is
		do
			group.extend( object_ ) 
		end
		
	remove_object( object_ : Q_GL_OBJECT ) is
		do
			group.prune( object_ )
		end
		
		
feature -- hud / world interaction
	position_hud_to_world( x_, y_ : DOUBLE ) : Q_VECTOR_3D is
			-- From a position in the hud to a position in the real world
		do
			result := root.position_in_space( x_, y_ )
			result := camera.untransform_position( result )
		end
		
	direction_hud_to_world( x_, y_ : DOUBLE ) : Q_VECTOR_3D is
			-- The direction under witch all points are mapped to x/y in the hud
		do
			result := root.direction_in_space( x_, y_ )
			result := camera.untransform_direction( result )
		end
		
	position_world_to_hud( position_ : Q_VECTOR_3D ) : Q_VECTOR_2D is
			-- Where a position in the real world is showed relative to the hud
		local
			vector_ : Q_VECTOR_3D
		do
			vector_ := camera.transform_position( position_ )
			result := root.position_in_hud( vector_.x, vector_.y, vector_.z )
		end

	direction_world_to_hud( direction_ : Q_VECTOR_3D ) : Q_VECTOR_2D is
			-- The direction under witch all points are mapped to x/y in the hud
		local
			vector_ : Q_VECTOR_3D
		do
			vector_ := camera.transform_direction( direction_ )
			result := root.direction_in_hud( vector_.x, vector_.y, vector_.z )
		end		
	
end -- class Q_GL_MANAGER
