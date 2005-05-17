indexing
	description: ""
	author: "Andreas Kaegi"
	
class
	ACE_PHYS_TEST_OBJECT
	
inherit
	Q_GL_OBJECT

create
	make
	
feature {NONE} -- create

	make is
		do
			create collision_detector.make
			create collision_handler.make
			create ball.make (create {Q_VECTOR_2D}.make (0, 0), 10)
			create bank.make (create {Q_VECTOR_2D}.make (500, -300), create {Q_VECTOR_2D}.make (500, 300))
			
			ball.set_velocity (create {Q_VECTOR_2D}.make (0.1, 0))
			
			collision_detector.set_response_handler (collision_handler)
			collision_detector.add_object (ball)
			collision_detector.add_object (bank)
			
			oldticks := timer_funcs.sdl_get_ticks_external
		end
		

feature -- visualisation

	step is
			-- do a computational step
		local
			newticks, stepsize: INTEGER
			
		do
			newticks := timer_funcs.sdl_get_ticks_external
			stepsize := newticks - oldticks
			oldticks := newticks
			
			-- collision detection
			collision_detector.collision_test
			
			-- update objects
			ball.update_position (stepsize)
			bank.update_position (stepsize)
			
		end
		
	draw (ogl: Q_GL_DRAWABLE) is
			-- draws this visualisation
		local
			glf: GL_FUNCTIONS

		do
			step
			
			draw_ball (ogl, ball)
			draw_bank (ogl, bank)

		end
		
feature {NONE} -- implementation

	draw_ball(ogl: Q_GL_DRAWABLE; b: Q_BALL) is
			--- draw ball on screen
		local
			glf: GL_FUNCTIONS
			ball_model: Q_GL_CIRCLE_FILLED
		do
			glf := ogl.gl
			glf.gl_color3f(0,0,1)
			glf.gl_line_width (10)
			
			create ball_model.make (b.center.x, b.center.y, b.radius, 20)
			ball_model.draw (ogl)
			
		end
		
	draw_bank(ogl: Q_GL_DRAWABLE; b: Q_BANK) is
			-- draw bank on screen
		local
			glf: GL_FUNCTIONS
		do
			glf := ogl.gl
			
			glf.gl_begin (ogl.gl_constants.esdl_gl_lines)
			
			-- don't use color3b or color3i, that does not work!
			glf.gl_color3f(1,0,0)
			glf.gl_line_width (10)

			glf.gl_vertex2d (b.edge1.x, b.edge1.y)
			glf.gl_vertex2d (b.edge2.x, b.edge2.y)
			
			glf.gl_end
		end
		


	collision_detector: Q_PHYS_COLLISION_DETECTOR
	collision_handler: Q_PHYS_COLLISION_RESPONSE_HANDLER
	ball: Q_BALL
	bank: Q_BANK
	
	oldticks: INTEGER
	
	circle: ESDL_CIRCLE
	
	timer_funcs: SDL_TIMER_FUNCTIONS_EXTERNAL is
			-- sdl timer functions, directly used, sorry Benno :-p
		once
			create Result
		end
		
	sdl_funcs: SDL_GFXPRIMITIVES_FUNCTIONS is
			-- sdl gfxprimitives functions
		once
			create Result
		end

end -- class ACE_PHYS_TEST_OBJECT
