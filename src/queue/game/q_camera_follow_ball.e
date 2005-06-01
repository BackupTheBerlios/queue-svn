indexing
	description: "A camera that follows a ball"
	author: "Benjamin Sigg"

class
	Q_CAMERA_FOLLOW_BALL
	
inherit
	Q_CAMERA_BEHAVIOUR
	redefine
		process_mouse_button_up,
		process_mouse_button_down,
		process_mouse_moved
	end

creation
	make_empty

feature{NONE} -- creation
	make_empty is
		do
			nearest := 0
			farest := 100
			
			under := 10
			over := 80
		end
	
feature -- values
	nearest : DOUBLE
		-- how near the camera is allowed to go
		
	farest : DOUBLE
		-- how far away the camera is allowed to go
		
	under : DOUBLE
		-- the smallest possible value of beta (the angle descriping the vertical deviation
		
	over : DOUBLE
		-- the greatest possible value of beta

	ball : Q_BALL
		-- the ball witch should be followed

feature -- eventhandling
	mouse_pressed : BOOLEAN
	ctrl_pressed : BOOLEAN
	last_mouse_x, last_mouse_y : DOUBLE

	process_mouse_button_down (event_: ESDL_MOUSEBUTTON_EVENT; x_, y_: DOUBLE): BOOLEAN is
			-- invoked when a Mousebutton is pressed, and the Mouse is over this Component
			-- returns true if the event is consumed, false if the parent should be invoked with the event
		do
			result := true
		end

	process_mouse_button_up (event_: ESDL_MOUSEBUTTON_EVENT; x_, y_: DOUBLE): BOOLEAN is
			-- invoked when a Mousebutton is released, witch was earlier pressed over this Component
			-- returns true if the event is consumed, false if the parent should be invoked with the event
		do
			result := true
		end

	process_mouse_moved (event_: ESDL_MOUSEMOTION_EVENT; x_, y_: DOUBLE): BOOLEAN is
			-- invoked the mouse is moved over this component, but not if a mousebutton was pressed over another component
			-- returns true if the event is consumed, false if the parent should be invoked with the event
		local
			delta_x_, delta_y_ : DOUBLE
		do
			if mouse_pressed then
				delta_x_ := x_ - last_mouse_x
				delta_y_ := y_ - last_mouse_y
				
				last_mouse_x := x_
				last_mouse_y := y_
			
				delta_x_ := delta_x_ * delta_x_ * 360
				delta_y_ := delta_y_ * delta_y_ * 360
				
				if ctrl_pressed then
					-- zoom
				else
					-- rotation
					
				end
				
				result := true
			else
				result := false
			end
		end

end -- class Q_CAMERA_FOLLOW_BALL
