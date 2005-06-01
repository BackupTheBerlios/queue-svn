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
			create root.init
			
			create camera
			create navigator.make_camera( camera )
			
			navigator.set_bounds( 0, 0, 1, 1 )
			root.hud.add( navigator )
		end
		
feature{NONE} -- internal values
	root : Q_GL_ROOT
	
	navigator : Q_HUD_CAMERA_NAVIGATOR
	
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
		
end -- class Q_GL_MANAGER
