indexing
	description: "A light"
	author: "Benjamin Sigg"

class
	Q_GL_LIGHT

inherit
	Q_GL_LIVABLE

creation
	make

feature{NONE}
	make( index_ : INTEGER ) is
		require
			index_valid : index_ >= 0 and index <= 7
		do
			index := index_
			
			create ambient.make(0, 3)
			create diffuse.make(0, 3)
			create specular.make(0, 3)
			create position.make(0, 3)
			create spot_direction.make(0, 3)
			
			spot_direction.put( 0, 3 )
			set_constant_attenuation( 1 )
			set_spot_cut_off ( 180 )
		end

feature -- deferreds
	hash_code : INTEGER
	
	draw( open_gl : Q_GL_DRAWABLE ) is
		local
			index_ : INTEGER
			pointer_ : ANY
		do
			index_ := gl_index( open_gl )
			
			open_gl.gl.gl_enable( index_ )
			open_gl.live_manager.alive( current )

			pointer_ := ambient.to_c
			open_gl.gl.gl_lightfv( index_, open_gl.gl_constants.esdl_gl_ambient, $pointer_ )
			
			pointer_ := diffuse.to_c
			open_gl.gl.gl_lightfv( index_, open_gl.gl_constants.esdl_gl_diffuse, $pointer_  )
			
			pointer_ := specular.to_c
			open_gl.gl.gl_lightfv( index_, open_gl.gl_constants.esdl_gl_specular, $pointer_  )
						
			pointer_ := position.to_c
			open_gl.gl.gl_lightfv( index_, open_gl.gl_constants.esdl_gl_position, $pointer_  )
			
			pointer_ := spot_direction.to_c
			open_gl.gl.gl_lightfv( index_, open_gl.gl_constants.esdl_gl_spot_direction, $pointer_  )
			
			open_gl.gl.gl_lightf ( index_, open_gl.gl_constants.esdl_gl_spot_cutoff, spot_cut_off )
			open_gl.gl.gl_lightf ( index_, open_gl.gl_constants.esdl_gl_spot_exponent, spot_exponent )
			
			open_gl.gl.gl_lightf ( index_, open_gl.gl_constants.esdl_gl_constant_attenuation, constant_attenuation )
			open_gl.gl.gl_lightf ( index_, open_gl.gl_constants.esdl_gl_linear_attenuation, linear_attenuation )
			open_gl.gl.gl_lightf ( index_, open_gl.gl_constants.esdl_gl_quadratic_attenuation, quadratic_attenuation )			
		end
	
	death( open_gl : Q_GL_DRAWABLE ) is
		do
			open_gl.gl.gl_disable( gl_index( open_gl ) )
		end

feature{NONE}
	gl_index( open_gl : Q_GL_DRAWABLE ) : INTEGER is
		do
			if     index = 0 then result := open_gl.gl_constants.esdl_gl_light0
			elseif index = 1 then result := open_gl.gl_constants.esdl_gl_light1
			elseif index = 2 then result := open_gl.gl_constants.esdl_gl_light2
			elseif index = 3 then result := open_gl.gl_constants.esdl_gl_light3
			elseif index = 4 then result := open_gl.gl_constants.esdl_gl_light4
			elseif index = 5 then result := open_gl.gl_constants.esdl_gl_light5
			elseif index = 6 then result := open_gl.gl_constants.esdl_gl_light6
			elseif index = 7 then result := open_gl.gl_constants.esdl_gl_light7
			end
		end
		
			
feature -- values
	index : INTEGER
		-- index of the light, beginning by 0

	constant_attenuation : REAL
	linear_attenuation : REAL
	quadratic_attenuation : REAL
	
	spot_cut_off : REAL
	spot_exponent : REAL
	
	
	set_constant_attenuation( constant_attenuation_ : REAL ) is
		do
			constant_attenuation := constant_attenuation_
		end
		
	set_linear_attenuation( linear_attenuation_ : REAL ) is
		do
			linear_attenuation := linear_attenuation_
		end
		
	set_quadratic_attenuation( quadratic_attenuation_ : REAL ) is
		do
			quadratic_attenuation := quadratic_attenuation_
		end
		
	
	set_attenuation( constant_, linear_, quadratic_ : REAL ) is
		do
			set_constant_attenuation( constant_ )
			set_linear_attenuation( linear_ )
			set_quadratic_attenuation( quadratic_ )
		end
		
	set_spot_cut_off( cut_off_ : REAL ) is
		require
			cut_off_between_0_and_90_or_equal_180 : (cut_off_ >= 0 and cut_off_ <= 90) or (cut_off_ = 180)
		do
			spot_cut_off := cut_off_
		end
	
	set_spot_exponent( exponent_ : REAL ) is
		require
			exponent_between_0_and_128 : exponent_ >= 0 and exponent_ <= 128
		do
			spot_exponent := exponent_
		end
		
		
	set_ambient( red_, green_, blue_, alpha_ : REAL ) is
		require
			red_between_0_and_1 : red_ >= 0 and red_ <= 1
			green_between_0_and_1 : green_ >= 0 and green_ <= 1
			blue_between_0_and_1 : blue_ >= 0 and blue_ <= 1
			alpha_between_0_and_1 : alpha_ >= 0 and alpha_ <= 1
		do
			ambient.put( red_, 0 )
			ambient.put( green_, 1 )
			ambient.put( blue_, 2 )
			ambient.put( alpha_, 3 )
		end

	set_diffuse( red_, green_, blue_, alpha_ : REAL ) is
		require
			red_between_0_and_1 : red_ >= 0 and red_ <= 1
			green_between_0_and_1 : green_ >= 0 and green_ <= 1
			blue_between_0_and_1 : blue_ >= 0 and blue_ <= 1
			alpha_between_0_and_1 : alpha_ >= 0 and alpha_ <= 1
		do
			diffuse.put( red_, 0 )
			diffuse.put( green_, 1 )
			diffuse.put( blue_, 2 )
			diffuse.put( alpha_, 3 )
		end
		
	set_specular( red_, green_, blue_, alpha_ : REAL ) is
		require
			red_between_0_and_1 : red_ >= 0 and red_ <= 1
			green_between_0_and_1 : green_ >= 0 and green_ <= 1
			blue_between_0_and_1 : blue_ >= 0 and blue_ <= 1
			alpha_between_0_and_1 : alpha_ >= 0 and alpha_ <= 1
		do
			specular.put( red_, 0 )
			specular.put( green_, 1 )
			specular.put( blue_, 2 )
			specular.put( alpha_, 3 )
		end
	
	set_position( x_, y_, z_ : REAL ) is
		do
			set_position_or_direction( x_, y_, z_, 1 )
		end
		
	set_direction( x_, y_, z_ : REAL ) is
		do
			set_position_or_direction( x_, y_, z_, 0 )
		end
		
	set_position_or_direction( x_, y_, z_, position_bit_ : REAL) is
		do
			position.put( x_, 0 )
			position.put( y_, 1 )
			position.put( z_, 2 )
			position.put( position_bit_, 3 )
		end
		
	set_spot_direction( x_, y_, z_ : REAL) is
		do
			spot_direction.put( x_, 0 )
			spot_direction.put( y_, 1 )
			spot_direction.put( z_, 2 )
		end
		
		
	
feature{NONE} -- hidden values
	ambient : ARRAY[REAL]
	
	diffuse : ARRAY[REAL]
	
	specular : ARRAY[REAL]
	
	position : ARRAY[REAL]
	
	spot_direction : ARRAY[REAL]
end -- class Q_GL_LIGHT
