indexing
	description: "A button showed on the screen. Can be pressed by the mouse"
	author: "Benjamin Sigg"

class
	Q_HUD_BUTTON

inherit
	Q_HUD_LABEL
	rename
		background as current_background,
		set_background as set_current_background
	redefine
		process_mouse_button_down,
		process_mouse_button_up,
		process_mouse_enter,
		process_mouse_exit,
		process_key_down,
		make
	end
	
creation
	make

feature {NONE} -- creation
	make is
		do
			precursor
			
			create actions	
			set_focusable( true )
			set_enabled( true )
			
			create background_normal.make_orange
			create background_pressed.make_red
			create background_rollover.make_yellow
			
			ensure_background
		end
		

feature -- drawing
	background_normal, background_pressed, background_rollover : Q_GL_COLOR
	

feature{NONE} -- drawing
	ensure_background is
		do
			if pressed then
				set_current_background( background_pressed )	
			elseif mouse_over then
				set_current_background( background_rollover )
			else
				set_current_background( background_normal )
			end
		end
		

feature -- eventhandling
	pressed, mouse_over : BOOLEAN
	
	actions : EVENT_TYPE[ TUPLE[] ] 
	
	do_click is
			-- calls a click on all known agents
		do
			from
				actions.start
			until
				actions.after
			loop
				actions.item.call( [] )
				actions.forth
			end
		end
		
	process_mouse_button_down( event_ : ESDL_MOUSEBUTTON_EVENT; x_, y_ : DOUBLE ) : BOOLEAN is
		do
			pressed := true
			result := true
			ensure_background
		end
		
	process_mouse_button_up( event_ : ESDL_MOUSEBUTTON_EVENT; x_, y_ : DOUBLE ) : BOOLEAN is
		do
			if pressed then
				pressed := false
				
				if inside( x_, y_ ) then
					do_click
				end
			end
			
			ensure_background
		end
		
	process_mouse_enter( x_, y_ : DOUBLE ) is
		do
			mouse_over := true
			ensure_background
		end
		
	process_mouse_exit( x_, y_ : DOUBLE ) is
		do
			mouse_over := false
			ensure_background
		end
		
	process_key_down( event_ : ESDL_KEYBOARD_EVENT ) : BOOLEAN is
		do
			if event_.key = event_.sdlk_return then
				do_click
				result := true
			else
				result := false
			end
		end
		

end -- class Q_HUD_BUTTON
