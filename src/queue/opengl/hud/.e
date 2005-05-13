indexing
	description: "A component witch reacts on the mouse by a rollover effect, and by a pressed-effect"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	NEW_CLASS

inherit
	Q_HUD_COMPONENT
	
	process_mouse_button_down( event_ : ESDL_MOUSEBUTTON_EVENT; x_, y_ : DOUBLE ) : BOOLEAN is
		do
			pressed := true
			result := true
		end
		
	process_mouse_button_up( event_ : ESDL_MOUSEBUTTON_EVENT; x_, y_ : DOUBLE ) : BOOLEAN is
		do
			if pressed then
				pressed := false
				
				if inside( x_, y_ ) then
					do_click
				end
			end
		end
		
	process_mouse_enter( x_, y_ : DOUBLE ) is
		do
			mouse_over := true
		end
		
	process_mouse_exit( x_, y_ : DOUBLE ) is
		do
			mouse_over := false
		end

end -- class NEW_CLASS
