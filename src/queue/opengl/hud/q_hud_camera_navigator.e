indexing
	description: "A component allowing to change the view and position of a camera"
	author: "Benjamin Sigg"
	revision: "1.0"

class
	Q_HUD_CAMERA_NAVIGATOR

inherit
	Q_HUD_CONTAINER
	rename
		key_down as container_key_down
	redefine
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

			mouse_moved_listener.extend( agent mouse_moved( ?,?,?,?,? ))
			mouse_button_down_listener.extend( agent mouse_button_down( ?,?,?,?,? ))
			mouse_button_up_listener.extend( agent mouse_button_up( ?,?,?,?,? ))
			mouse_enter_listener.extend( agent mouse_enter( ?,?,? ))
			mouse_exit_listener.extend( agent mouse_exit( ?,?,? ))
			key_down_listener.extend( agent key_down( ?,?,? ))
			key_up_listener.extend( agent key_up( ?,?,? ))			
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

	mouse_moved( event_ : ESDL_MOUSEMOTION_EVENT; x_, y_ : DOUBLE; map_ : Q_KEY_MAP; consumed_ : BOOLEAN ) : BOOLEAN is
		do
			if not consumed_ then
				result := behaviour /= void and then behaviour.process_mouse_moved( event_, x_, y_, map_ )
			end
		end
	
	mouse_button_down( event_ : ESDL_MOUSEBUTTON_EVENT; x_, y_ : DOUBLE; map_ : Q_KEY_MAP; consumed_ : BOOLEAN ) : BOOLEAN is
		do
			if not consumed_ then
				result := behaviour /= void and then behaviour.process_mouse_button_down( event_, x_, y_, map_ )
			end
		end
		
	mouse_button_up( event_ : ESDL_MOUSEBUTTON_EVENT; x_, y_ : DOUBLE; map_ : Q_KEY_MAP; consumed_ : BOOLEAN ) : BOOLEAN is
		do
			if not consumed_ then
				result := behaviour /= void and then behaviour.process_mouse_button_up( event_, x_, y_, map_ )
			end
		end
		
	key_down( event_: ESDL_KEYBOARD_EVENT; map_ : Q_KEY_MAP; consumed_ : BOOLEAN ): BOOLEAN is
		do
			if not consumed_ then
				result := behaviour /= void and then behaviour.process_key_down( event_, map_ )
			end
		end

	key_up( event_: ESDL_KEYBOARD_EVENT; map_ : Q_KEY_MAP; consumed_ : BOOLEAN ): BOOLEAN is
		do
			if not consumed_ then
				result := behaviour /= void and then behaviour.process_key_up( event_, map_ )
			end
		end
		
	mouse_enter( x_, y_: DOUBLE; map_ : Q_KEY_MAP) is
		do
			if behaviour /= void then
				behaviour.process_mouse_enter( x_, y_, map_ )
			end
		end
		
	mouse_exit( x_, y_: DOUBLE; map_ : Q_KEY_MAP) is
		do
			if behaviour /= void then
				behaviour.process_mouse_exit( x_, y_, map_ )
			end
		end		

end -- class Q_HUD_CAMERA_NAVIGATOR
