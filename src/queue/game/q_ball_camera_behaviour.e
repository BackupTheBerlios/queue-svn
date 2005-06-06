indexing
	description: "A camera that follows a ball"
	author: "Benjamin Sigg"

class
	Q_BALL_CAMERA_BEHAVIOUR

inherit
	Q_CAMERA_BEHAVIOUR
	redefine
		update,
		process_mouse_button_up,
		process_mouse_button_down,
		process_mouse_moved,
		process_key_down
	end

creation
	make

feature{NONE}
	make( ressources_ : Q_GAME_RESSOURCES )is
		do
			ressources := ressources_
			
			zoom_factor := 2.0
			zoom_max := 100
			zoom_min := 50
			
			rotate_factor := 1000.0
			rotate_vertical_min := -80
			rotate_vertical_max := 10
			
			distance := zoom_min
			
			create key_map.make
			
			set_unit_move_duration( 1500 )
			set_rotation_duration( 20000 )
		end
		

feature -- the ball & table
	ball : Q_BALL
	
	ressources : Q_GAME_RESSOURCES
	
	set_ressources( ressources_ : Q_GAME_RESSOURCES ) is
		do
			ressources := ressources_
		end
		
	
	set_ball( ball_ : Q_BALL ) is
		do
			ball := ball_
		end
	
feature -- velocity
	unit_move_duration : INTEGER
	
	rotation_duration : INTEGER
	
	set_unit_move_duration( duration_ : INTEGER ) is
			-- sets, how long the camera would need to move
			-- one unit (= 1 meter), if the user presses the 
			-- assigned key
		require
			duration_ > 0
		do
			unit_move_duration := duration_
		end
		
	set_rotation_duration( duration_ : INTEGER ) is
			-- Sets, how long the camera would need to
			-- move one time around the ball, if the user
			-- presses the assigned key
		require
			duration_ > 0
		do
			rotation_duration := duration_
		end

feature -- keys
	ctrl, shift, alt : BOOLEAN
	
	set_ctrl( ctrl_ : BOOLEAN ) is
			-- If true, the user must press the ctrl-key to
			-- control the camera by keys. If false, the camera
			-- will only react, if the key is not pressed.
		do
			ctrl := ctrl_
		end

	set_alt( alt_ : BOOLEAN ) is
			-- If true, the user must press the alt-key to
			-- control the camera by keys. If false, the camera
			-- will only react, if the key is not pressed.
		do
			alt := alt_
		end
		
	set_shift( shift_ : BOOLEAN ) is
			-- If true, the user must press the shift-key to
			-- control the camera by keys. If false, the camera
			-- will only react, if the key is not pressed.
		do
			shift := shift_
		end
	
feature -- update
	update( time_ : Q_TIME ) is
		local
			vector_ : Q_VECTOR_3D
			
			da_, db_, dz_, dt_ : DOUBLE
		do
			if original_key_map /= void then
				original_key_map.ensure_subset( key_map )
				
				if original_key_map.alt = alt and
					original_key_map.ctrl = ctrl and
					original_key_map.shift = shift then
					
					da_ := 0
					db_ := 0
					dz_ := 0
					
					-- zoom
					if key_map.pressed( key_map.sdlk_q ) then
						dz_ := dz_ + 1
					end
					
					if key_map.pressed( key_map.sdlk_e ) then
						dz_ := dz_ - 1
					end
					
					-- angle, fast
					if key_map.pressed( key_map.sdlk_w ) then
						db_ := db_ + 5
					end
					
					if key_map.pressed( key_map.sdlk_s ) then
						db_ := db_ - 5
					end
					
					if key_map.pressed( key_map.sdlk_a ) then
						da_ := da_ + 5
					end
					
					if key_map.pressed( key_map.sdlk_d ) then
						da_ := da_ - 5
					end
					
					-- angle, slow
					if key_map.pressed( key_map.sdlk_up ) then
						db_ := db_ + 1
					end
					
					if key_map.pressed( key_map.sdlk_down ) then
						db_ := db_ - 1
					end
					
					if key_map.pressed( key_map.sdlk_left ) then
						da_ := da_ + 1
					end
					
					if key_map.pressed( key_map.sdlk_right ) then
						da_ := da_ - 1
					end
					
					if dz_ /= 0 then
						dt_ := time_.delta_time_millis / unit_move_duration
						
						distance := distance - dz_ * dt_ * 100
						distance := zoom_min.max( zoom_max.min( distance ) )
					end
					
					if da_ /= 0 or db_ /= 0 then
						dt_ := time_.delta_time_millis / rotation_duration
						
						alpha := alpha + da_ * dt_ * 360
						beta := beta + db_ * dt_ * 360
						
						if alpha < 0 then alpha := alpha + 360 end
						if alpha > 360 then alpha := alpha - 360 end
						
						beta := rotate_vertical_min.max( rotate_vertical_max.min( beta ))
					end
				end
			end
			
			if camera /= void and ball /= void then
				vector_ := camera.view_direction_by_angles( alpha, beta )
				vector_.normaliced
				vector_.scaled( -distance )
				vector_.add( ressources.mode.position_table_to_world( ball.center ) )
				vector_.add_xyz( 0, ball.radius, 0 )
				
				camera.set_position( vector_.x, vector_.y, vector_.z )
				camera.set_alpha( alpha )
				camera.set_beta( beta )
			end
		end

feature -- event-handling
	mouse_pressed : BOOLEAN
	secondary_mouse : BOOLEAN
	
	key_map, original_key_map : Q_KEY_MAP
	
	last_x, last_y : DOUBLE

	process_key_down( event_: ESDL_KEYBOARD_EVENT; map_: Q_KEY_MAP ) : BOOLEAN is
		do
			original_key_map := map_
			key_map.tell_pressed( event_.key )
		end
		

	process_mouse_button_down (event_: ESDL_MOUSEBUTTON_EVENT; x_, y_: DOUBLE; map_ : Q_KEY_MAP): BOOLEAN is
		do
			if mouse_pressed then
				secondary_mouse := true
			else
				mouse_pressed := true
			end
			
			last_x := x_
			last_y := y_
			
			result := true
		end

	process_mouse_button_up (event_: ESDL_MOUSEBUTTON_EVENT; x_, y_: DOUBLE; map_ : Q_KEY_MAP): BOOLEAN is
		do
			if secondary_mouse then
				secondary_mouse := false
			else
				mouse_pressed := false	
			end
			
			result := true
		end

	process_mouse_moved (event_: ESDL_MOUSEMOTION_EVENT; x_, y_: DOUBLE; map_ : Q_KEY_MAP): BOOLEAN is
		local
			exp_ : DOUBLE
			d_alpha_, d_beta_ : DOUBLE
			dx_, dy_ : DOUBLE
		do	
			
			if secondary_mouse then
				-- zoom
				dy_ := y_ - last_y
				last_x := x_
				last_y := y_
				
				exp_ := math.log( distance )
				exp_ := math.exp( exp_ - zoom_factor * dy_).max( zoom_min ).min( zoom_max )
				set_distance( exp_ )
			elseif mouse_pressed then
				dx_ := -(x_ - last_x)
				dy_ :=  (y_ - last_y)
				
				last_x := x_
				last_y := y_
				
				if dx_ > 0 then
					d_alpha_ := dx_*dx_
				else
					d_alpha_ := -dx_*dx_
				end
				
				if dy_ < 0 then
					d_beta_ := dy_ * dy_
				else
					d_beta_ := -dy_ * dy_
				end
				
				d_alpha_ := d_alpha_ * rotate_factor
				d_beta_ := d_beta_ * rotate_factor
				
				set_alpha( alpha + d_alpha_ )
				set_beta( (beta + d_beta_).min( rotate_vertical_max ).max( rotate_vertical_min ) )
			end
		
			result := mouse_pressed
		end

feature -- boundaris
	zoom_factor, zoom_min, zoom_max : DOUBLE
	rotate_factor, rotate_vertical_min, rotate_vertical_max : DOUBLE

	set_zoom_factor( factor_ : DOUBLE ) is
		do
			zoom_factor := factor_
		end
		
	set_zoom_min( min_ : DOUBLE ) is
		do
			zoom_min := min_
		end
		
	set_zoom_max( max_ : DOUBLE ) is
		do
			zoom_max := max_
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
		

feature{NONE} -- math
	math : Q_MATH is
		once
			create result
		end
		
	
feature -- position
	alpha : DOUBLE
	
	beta : DOUBLE
	
	distance : DOUBLE

	set_alpha( alpha_ : DOUBLE ) is
		do
			alpha := alpha_
		end
		
	set_beta( beta_ : DOUBLE ) is
		do
			beta := beta_
		end
		
	set_distance( distance_ : DOUBLE ) is
		require
			distance > 0
		do
			distance := distance_
		end
		

end -- class Q_BALL_CAMERA_BEHAVIOUR
