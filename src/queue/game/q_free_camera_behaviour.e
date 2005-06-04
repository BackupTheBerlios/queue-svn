indexing
	description: "A camerabehaviour allowing to freely move the camera"
	author: "Benjamin Sigg"

class
	Q_FREE_CAMERA_BEHAVIOUR

inherit
	Q_CAMERA_BEHAVIOUR
	redefine
		update,
		process_key_down,
		process_key_up,
		process_mouse_button_down,
		process_mouse_button_up,
		process_mouse_moved
	end

creation
	make

feature{NONE} -- creation
	make is
		do
			
		end
		
feature -- factors
	move_factor, zoom_factor, rotate_factor : DOUBLE
	rotate_vertical_min, rotate_vertical_max : DOUBLE

	center : Q_VECTOR_3D
	max_distance : DOUBLE
		
	set_move_factor( factor_ : DOUBLE ) is
		do
			move_factor := factor_
		end
	
	set_zoom_factor( factor_ : DOUBLE ) is
		do
			zoom_factor := factor_
		end
		
	set_rotate_factor( factor_ : DOUBLE ) is
		do
			rotate_factor := factor_
		end
	
	set_rotate_vertical_min( min_ : DOUBLE ) is
		do
			rotate_vertical_min := min_
		end
		
	set_rotate_vertical_max( max_ : DOUBLE ) is
		do
			rotate_vertical_max := max_
		end
	
	set_center( center_ : Q_VECTOR_3D ) is
		do
			center := center_
		end
		
	set_max_distance( distance_ : DOUBLE ) is
		do
			max_distance := distance_
		end
		
feature{NONE} -- event handling
	key_map : Q_KEY_MAP
	first_mouse_down, second_mouse_down : BOOLEAN

	last_x, last_y : DOUBLE

	update is
		do
			
		end

	process_mouse_moved( event_: ESDL_MOUSEMOTION_EVENT; x_: DOUBLE; y_: DOUBLE; map_ : Q_KEY_MAP ) : BOOLEAN is
		local
			dx_, dy_ : DOUBLE
			beta_, alpha_ : DOUBLE
		do
			key_map := map_
			
			dx_ := x_ - last_x
			dy_ := y_ - last_y
			
			last_x := x_
			last_y := y_
			
			if second_mouse_down then
				-- zoom
				camera.zoom( dy_ * zoom_factor )
				result := true	
			elseif first_mouse_down then
				alpha_ := camera.alpha
				beta_ := camera.beta
				
				alpha_ := alpha_ + rotate_factor * dx_
				beta_ := beta_ + rotate_factor * dy_
				
				if alpha_ < 0 then alpha_ := alpha_ + 360 end
				if alpha_ > 360 then alpha_ := alpha_ - 360 end
				
				if beta_ < 0 then beta_ := beta_ + 360 end
				if beta_ > 360 then beta_ := beta_ - 360 end
				
				if beta_ < rotate_vertical_min then beta_ := rotate_vertical_min end
				if beta_ > rotate_vertical_max then beta_ := rotate_vertical_max end
				
				camera.set_alpha( alpha_ )
				camera.set_beta( beta_ )
				
				result := true
			else
				result := false
			end
		end

	process_mouse_button_down( event_: ESDL_MOUSEBUTTON_EVENT; x_: DOUBLE; y_: DOUBLE; map_ : Q_KEY_MAP ) : BOOLEAN is
		do
			key_map := map_
			
			last_x := x_
			last_y := y_
			
			if not first_mouse_down then
				first_mouse_down := true
			else
				second_mouse_down := true
			end
			
			result := true
		end
		
	process_mouse_button_up( event_: ESDL_MOUSEBUTTON_EVENT; x_: DOUBLE; y_: DOUBLE; map_ : Q_KEY_MAP ) : BOOLEAN is
		do
			key_map := map_
			
			if second_mouse_down then
				second_mouse_down := false
			else
				first_mouse_down := false
			end
		end
	
	process_key_down( event_: ESDL_KEYBOARD_EVENT; map_ : Q_KEY_MAP ) : BOOLEAN is
		do
			key_map := map_
		end
	
	process_key_up( event_: ESDL_KEYBOARD_EVENT; map_ : Q_KEY_MAP ) : BOOLEAN is
		do
			key_map := map_
		end
		
feature -- table and camera
	table : Q_TABLE
	
	set_table( table_ : Q_TABLE ) is
		do
			table := table_
		end
		
		
end -- class Q_FREE_CAMERA_BEHAVIOUR
