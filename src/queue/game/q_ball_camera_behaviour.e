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
		process_mouse_moved
	end

creation
	make

feature{NONE}
	make( table_ : Q_TABLE_MODEL )is
		do
			table := table_
			
			zoom_factor := 2.0
			zoom_max := 100
			zoom_min := 50
			
			rotate_factor := 1000.0
			rotate_vertical_min := -80
			rotate_vertical_max := 10
			
			distance := zoom_min
		end
		

feature -- the ball & table
	ball : Q_BALL
	
	table : Q_TABLE_MODEL
	
	set_table( table_ : Q_TABLE_MODEL ) is
		do
			table := table_
		end
		
	
	set_ball( ball_ : Q_BALL ) is
		do
			ball := ball_
		end
	
feature -- update
	update is
		local
			vector_ : Q_VECTOR_3D
		do
			if camera /= void and ball /= void then
				vector_ := camera.view_direction_by_angles( alpha, beta )
				vector_.normaliced
				vector_.scaled( -distance )
				vector_.add( table.position_table_to_world( ball.center ) )
				vector_.add_xyz( 0, ball.radius, 0 )
				
				camera.set_position( vector_.x, vector_.y, vector_.z )
				camera.set_alpha( alpha )
				camera.set_beta( beta )
			end
		end

feature -- event-handling
	mouse_pressed : BOOLEAN
	secondary_mouse : BOOLEAN
	
	last_x, last_y : DOUBLE

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
				dx_ := x_ - last_x
				dy_ := y_ - last_y
				
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
