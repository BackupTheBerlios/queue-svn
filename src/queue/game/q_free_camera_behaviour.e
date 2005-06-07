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
			zoom_factor := 10.0
			
			rotate_factor := 100.0
			rotate_vertical_min := -80
			rotate_vertical_max := 10
			
			create center.make( 0, 0, 0 )
			max_distance := 1000
			
			unit_move_duration := 1000
			rotation_duration := 3000
			
			create key_map.make
		end
		
feature -- factors
	zoom_factor, rotate_factor : DOUBLE
		-- the factor with witch the mouse-motion is multiplied
		
	rotate_vertical_min, rotate_vertical_max : DOUBLE
		-- minimal and maximal beta-angle
		
	unit_move_duration : INTEGER
		-- how many milliseconds the move of one unit will take
		
	rotation_duration : INTEGER
		-- how many milliseconds the rotation of 360 Degrees needs

	center : Q_VECTOR_3D
		-- The center of the sphere, in witch the camera should remain
		
	max_distance : DOUBLE
		-- the maximal distance of the camera to the center
		
	set_unit_move_duration( duration_ : INTEGER ) is
		require
			duration_ > 0
		do
			unit_move_duration := duration_
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
		
	ensure_valid_position is
		local
			diff_ : Q_VECTOR_3D
			length_ : DOUBLE
		do
			if camera /= void then
				create diff_.make( camera.x, camera.y, camera.z )
				diff_.sub( center )
				length_ := diff_.length
				
				if length_ > max_distance then
					diff_.scaled( max_distance / length_ )
					diff_.add( center )
					camera.set_position( diff_.x, diff_.y, diff_.z )
				end
			end
		end
		
feature -- key requirement
	ctrl, shift, alt : BOOLEAN
	
	set_ctrl( ctrl_ : BOOLEAN ) is
		do
			ctrl := ctrl_
		end
		
	set_shift( shift_ : BOOLEAN ) is
		do
			shift := shift_
		end
		
	set_alt( alt_ : BOOLEAN ) is
		do
			alt := alt_
		end
		
	
feature{NONE} -- event handling
	key_map, original_key_map : Q_KEY_MAP
	first_mouse_down, second_mouse_down : BOOLEAN

	last_x, last_y : DOUBLE

	update( time_ : Q_TIME ) is
		local
			dx_, dy_, dz_, ds_, da_, db_, dt_ : DOUBLE
			alpha_, beta_ : DOUBLE
			change_ : BOOLEAN
		do
			if original_key_map /= void then
				original_key_map.ensure_subset( key_map )
				
				if original_key_map.ctrl = ctrl and 
					original_key_map.alt = alt and 
					original_key_map.shift = shift then
					
					dx_ := 0
					dy_ := 0
					dy_ := 0
					ds_ := 0
					da_ := 0
					db_ := 0
					dt_ := 0
					
					-- move
					if key_map.pressed( key_map.sdlk_i ) then
						dy_ := dy_ + 1
					end
					
					if key_map.pressed( key_map.sdlk_k ) then
						dy_ := dy_ - 1
					end
					
					if key_map.pressed( key_map.sdlk_left ) or
						key_map.pressed( key_map.sdlk_j ) then
						dx_ := dx_ - 1
					end
					
					if key_map.pressed( key_map.sdlk_right ) or
						key_map.pressed( key_map.sdlk_l ) then
						dx_ := dx_ + 1
					end
					
					-- slide
					if key_map.pressed( key_map.sdlk_up ) then
						ds_ := ds_ + 1
					end
						
					if key_map.pressed( key_map.sdlk_down ) then
						ds_ := ds_ - 1
					end
					
					-- zoom
					if key_map.pressed( key_map.sdlk_q ) then
						dz_ := dz_ + 1
					end
					
					if key_map.pressed( key_map.sdlk_e ) then
						dz_ := dz_ - 1
					end
					
					-- angles
					if key_map.pressed( key_map.sdlk_w ) then
						db_ := db_ + 1
					end
					
					if key_map.pressed( key_map.sdlk_s ) then
						db_ := db_ - 1
					end
					
					if key_map.pressed( key_map.sdlk_a ) then
						da_ := da_ + 1
					end
					
					if key_map.pressed( key_map.sdlk_d ) then
						da_ := da_ - 1
					end
					
					if dx_ /= 0 or dy_ /= 0 or dz_ /= 0 then
						dt_ := time_.delta_time_millis / unit_move_duration
						
						camera.move( 100 * dx_ * dt_, 100 * dy_ * dt_ )
						camera.zoom( 100 * dz_ * dt_ )
						
						change_ := true
					end
					
					if ds_ /= 0 then
						dt_ := time_.delta_time_millis / unit_move_duration
						
						camera.slide( 100 * ds_ * dt_ )
						
						change_ := true
					end
					
					if da_ /= 0 or db_ /= 0 then
						dt_ := time_.delta_time_millis / rotation_duration * 360
						
						alpha_ := camera.alpha
						beta_ := camera.beta
						
						alpha_ := alpha_ + da_ * dt_
						beta_ := beta_ + db_ * dt_
				
						alpha_ := valid_alpha( alpha_ )
						beta_ := valid_beta( beta_, db_ )
				
						camera.set_alpha( alpha_ )
						camera.set_beta( beta_ )
						
						change_ := true
					end
					
					if change_ then					
						ensure_valid_position
					end
				end
			end
		end

	process_mouse_moved( event_: ESDL_MOUSEMOTION_EVENT; x_: DOUBLE; y_: DOUBLE; map_ : Q_KEY_MAP ) : BOOLEAN is
		local
			dx_, dy_ : DOUBLE
			beta_, alpha_ : DOUBLE
		do
			original_key_map := map_
			
			dx_ := x_ - last_x
			dy_ := y_ - last_y
			
			last_x := x_
			last_y := y_
			
			if second_mouse_down then
				-- zoom
				camera.zoom( dy_ * zoom_factor )
				ensure_valid_position
				result := true
			elseif first_mouse_down then
				alpha_ := camera.alpha
				beta_ := camera.beta
				
				alpha_ := alpha_ - rotate_factor * dx_
				beta_ := beta_ + rotate_factor * dy_
				
				alpha_ := valid_alpha( alpha_ )
				beta_ := valid_beta( beta_, dy_ )
				
				camera.set_alpha( alpha_ )
				camera.set_beta( beta_ )
				
				ensure_valid_position
				result := true
			else
				result := false
			end
		end
		
	valid_alpha( alpha_ : DOUBLE ) : DOUBLE is
		do
			result := alpha_
			if result < 0 then result := result + 360 end
			if result > 360 then result := result - 360 end
		end
	
	valid_beta( beta_, dy_ : DOUBLE ) : DOUBLE is
		do
			result := beta_
			
			if result < 0 then result := result + 360 end
			if result > 360 then result := result - 360 end
				
			if result > rotate_vertical_max and result < rotate_vertical_min+360 then
				if dy_ > 0 then
					result := rotate_vertical_max
				else
					result := rotate_vertical_min
				end
			end
		end
		

	process_mouse_button_down( event_: ESDL_MOUSEBUTTON_EVENT; x_: DOUBLE; y_: DOUBLE; map_ : Q_KEY_MAP ) : BOOLEAN is
		do
			original_key_map := map_
			
			if original_key_map.ctrl = ctrl and 
				original_key_map.shift = shift and 
				original_key_map.alt = alt then
					
				last_x := x_
				last_y := y_
				
				if not first_mouse_down then
					first_mouse_down := true
				else
					second_mouse_down := true
				end
			
				result := true
			end
		end
		
	process_mouse_button_up( event_: ESDL_MOUSEBUTTON_EVENT; x_: DOUBLE; y_: DOUBLE; map_ : Q_KEY_MAP ) : BOOLEAN is
		do
			original_key_map := map_
			
			if second_mouse_down then
				second_mouse_down := false
			else
				first_mouse_down := false
			end
		end
	
	process_key_down( event_: ESDL_KEYBOARD_EVENT; map_ : Q_KEY_MAP ) : BOOLEAN is
		do
			original_key_map := map_
			key_map.tell_pressed( event_.key )
		end
	
	process_key_up( event_: ESDL_KEYBOARD_EVENT; map_ : Q_KEY_MAP ) : BOOLEAN is
		do
			original_key_map := map_
		end
		
feature -- table and camera
	table : Q_TABLE
	
	set_table( table_ : Q_TABLE ) is
		do
			table := table_
		end

		
end -- class Q_FREE_CAMERA_BEHAVIOUR
