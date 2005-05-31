indexing
	description: "A component allowing to change the view and position of a camera"
	author: "Benjamin Sigg"
	revision: "1.0"

class
	Q_HUD_CAMERA_NAVIGATOR

inherit
	Q_HUD_CONTAINER
	redefine
		process_mouse_moved,
		process_mouse_button_down,
		process_mouse_button_up,
		process_mouse_enter,
		process_mouse_exit,
		process_key_down,
		process_key_up,
		make,
		draw
	end
	
creation
	make, make_camera
	
feature{NONE} -- creation
	make is 
		do
			precursor
			set_enabled( true )
		end

	make_camera( camera_ : Q_GL_CAMERA ) is
		do
			make
			set_camera( camera_ )
		end
		

feature -- camera
	camera : Q_GL_CAMERA
	
	set_camera( camera_ : Q_GL_CAMERA ) is
		do
			camera := camera_
			if behaviour /= void then
				behaviour.set_camera( camera )
			end
		end
	
	behaviour : Q_CAMERA_BEHAVIOUR
	
	set_behaviour( behaviour_ : Q_CAMERA_BEHAVIOUR ) is
			-- sets the behaviour
		do
			if behaviour /= void then
				behaviour.set_camera( void )
			end
			
			if behaviour_ /= void then
				behaviour_.set_camera( camera )
			end
			
			behaviour := behaviour_
		end
		
	draw( open_gl : Q_GL_DRAWABLE ) is
		do
			precursor( open_gl )
			if behaviour /= void then
				behaviour.update
			end
		end
		
	
feature{NONE} -- event-handling

	process_mouse_moved( event_ : ESDL_MOUSEMOTION_EVENT; x_, y_ : DOUBLE ) : BOOLEAN is
		do
			result := behaviour /= void and then behaviour.process_mouse_moved( event_, x_, y_ )
		end
	
	process_mouse_button_down( event_ : ESDL_MOUSEBUTTON_EVENT; x_, y_ : DOUBLE ) : BOOLEAN is
		do
			result := behaviour /= void and then behaviour.process_mouse_button_down( event_, x_, y_ )
		end
		
	process_mouse_button_up( event_ : ESDL_MOUSEBUTTON_EVENT; x_, y_ : DOUBLE ) : BOOLEAN is
		do
			result := behaviour /= void and then behaviour.process_mouse_button_up( event_, x_, y_ )		
		end
		
	process_key_down (event_: ESDL_KEYBOARD_EVENT): BOOLEAN is
		do
			result := behaviour /= void and then behaviour.process_key_down( event_ )
		end

	process_key_up( event_: ESDL_KEYBOARD_EVENT): BOOLEAN is
		do
			result := behaviour /= void and then behaviour.process_key_up( event_ )
		end
		
	process_mouse_enter( x_, y_: DOUBLE) is
		do
			if behaviour /= void then
				behaviour.process_mouse_enter( x_, y_ )				
			end
		end
		
	process_mouse_exit( x_, y_: DOUBLE) is
		do
			if behaviour /= void then
				behaviour.process_mouse_exit( x_, y_ )				
			end
		end		

end -- class Q_HUD_CAMERA_NAVIGATOR
