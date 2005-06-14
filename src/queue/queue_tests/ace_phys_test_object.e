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
			create simulation.make
			create ballpos_list.make
			
			new
		end
		

feature -- interface

	new is
			-- Reinitialize scene.
		do
			create balls.make (0, 0)
			create banks.make (0, 19)
			
			create ball1.make (create {Q_VECTOR_2D}.make (50, 60), 2.5)
--			create ball2.make (create {Q_VECTOR_2D}.make (300, 50), 2.5)
--			create ball3.make (create {Q_VECTOR_2D}.make (0, -100), 2.5)
			
			
			banks.put (create {Q_BANK}.make (create {Q_VECTOR_2D}.make (123, 140), create {Q_VECTOR_2D}.make (121.5, 133.5)), 0)
			banks.put (create {Q_BANK}.make (create {Q_VECTOR_2D}.make (121.5, 133.5), create {Q_VECTOR_2D}.make (11.658199999999994, 133.5)), 1)
			banks.put (create {Q_BANK}.make (create {Q_VECTOR_2D}.make (11.658199999999994, 133.5), create {Q_VECTOR_2D}.make (3.4168999999999983, 139.2689)), 2)
			banks.put (create {Q_BANK}.make (create {Q_VECTOR_2D}.make (-4.2689000000000021, 131.5831), create {Q_VECTOR_2D}.make (1.5, 123.34180000000001)), 3)
			banks.put (create {Q_BANK}.make (create {Q_VECTOR_2D}.make (1.5, 123.34180000000001), create {Q_VECTOR_2D}.make (1.5, 70)), 4)
			banks.put (create {Q_BANK}.make (create {Q_VECTOR_2D}.make (1.5, 70), create {Q_VECTOR_2D}.make (1.5, 16.658200000000001)), 5)
			banks.put (create {Q_BANK}.make (create {Q_VECTOR_2D}.make (1.5, 16.658200000000001), create {Q_VECTOR_2D}.make (-4.2689000000000021, 8.4168999999999983)), 6)
			banks.put (create {Q_BANK}.make (create {Q_VECTOR_2D}.make (3.4168999999999983, 0.73109999999999786), create {Q_VECTOR_2D}.make (11.658199999999994, 6.5)), 7)
			banks.put (create {Q_BANK}.make (create {Q_VECTOR_2D}.make (11.658199999999994, 6.5), create {Q_VECTOR_2D}.make (121.5, 6.5)), 8)
			banks.put (create {Q_BANK}.make (create {Q_VECTOR_2D}.make (121.5, 6.5), create {Q_VECTOR_2D}.make (123, 0)), 9)
			banks.put (create {Q_BANK}.make (create {Q_VECTOR_2D}.make (134, 0), create {Q_VECTOR_2D}.make (135.5, 6.5)), 10)
			banks.put (create {Q_BANK}.make (create {Q_VECTOR_2D}.make (135.5, 6.5), create {Q_VECTOR_2D}.make (245.34180000000001, 6.5)), 11)
			banks.put (create {Q_BANK}.make (create {Q_VECTOR_2D}.make (245.34180000000001, 6.5), create {Q_VECTOR_2D}.make (253.5831, 0.73109999999999786)), 12)
			banks.put (create {Q_BANK}.make (create {Q_VECTOR_2D}.make (261.26890000000003, 8.4168999999999983), create {Q_VECTOR_2D}.make (255.5, 16.658200000000001)), 13)
			banks.put (create {Q_BANK}.make (create {Q_VECTOR_2D}.make (255.5, 16.658200000000001), create {Q_VECTOR_2D}.make (255.5, 70)), 14)
			banks.put (create {Q_BANK}.make (create {Q_VECTOR_2D}.make (255.5, 70), create {Q_VECTOR_2D}.make (255.5, 123.34180000000001)), 15)
			banks.put (create {Q_BANK}.make (create {Q_VECTOR_2D}.make (255.5, 123.34180000000001), create {Q_VECTOR_2D}.make (261.26890000000003, 131.5831)), 16)
			banks.put (create {Q_BANK}.make (create {Q_VECTOR_2D}.make (253.5831, 139.2689), create {Q_VECTOR_2D}.make (245.34180000000001, 133.5)), 17)
			banks.put (create {Q_BANK}.make (create {Q_VECTOR_2D}.make (245.34180000000001, 133.5), create {Q_VECTOR_2D}.make (135.5, 133.5)), 18)
			banks.put (create {Q_BANK}.make (create {Q_VECTOR_2D}.make (135.5, 133.5), create {Q_VECTOR_2D}.make (134, 140)), 19)


--			create bank1.make (create {Q_VECTOR_2D}.make (500, -300), create {Q_VECTOR_2D}.make (500, 300))
--			create bank2.make (create {Q_VECTOR_2D}.make (-50, -300), create {Q_VECTOR_2D}.make (-50, 300))
--			create bank3.make (create {Q_VECTOR_2D}.make (-50, 300), create {Q_VECTOR_2D}.make (500, 300))
--			create bank4.make (create {Q_VECTOR_2D}.make (-50, -300), create {Q_VECTOR_2D}.make (500, -300))
			
			balls.put (ball1, 0)
--			balls.put (ball2, 1)
--			balls.put (ball3, 2)
			
--			banks.put (bank1, 1)
--			banks.put (bank2, 2)
--			banks.put (bank3, 3)
--			banks.put (bank4, 4)
			
			create table.make (balls, banks, void)

			-- ball1.set_velocity (create {Q_VECTOR_2D}.make (500, 125))
--			ball2.set_velocity (create {Q_VECTOR_2D}.make (-90, -24))
--			ball1.set_angular_velocity (create {Q_VECTOR_3D}.make (30, 0, 0))
			
			ballpos_list.wipe_out
			
			create shot.make (ball1, create {Q_VECTOR_2D}.make (50, 50))

			simulation.new (table, shot)
		end

	draw (ogl: Q_GL_DRAWABLE) is
			-- Draw visualisation.
		local
		do
			simulation.step (table, Void)
			
			draw_ball (ogl, ball1)
--			draw_ball (ogl, ball2)
--			draw_ball (ogl, ball3)
			
			banks.do_all (agent draw_bank (ogl, ?))
			
--			ballpos_list.force_right (ball1.center)
			ballpos_list.put_right (ball1.center)
			
			draw_track (ogl)
			draw_ballvectors (ogl, ball1)
			
			if simulation.has_finished then
				new
			end
		end
		
		
feature {NONE} -- implementation

	draw_ballvectors (ogl: Q_GL_DRAWABLE; b: Q_BALL) is
			-- Draw ball velocity vectors
		local
			glf: GL_FUNCTIONS
			v: Q_VECTOR_3D
		do
			glf := ogl.gl
			
			glf.gl_color3f(1,1,0)
			glf.gl_line_width (2)
			glf.gl_begin (ogl.gl_constants.esdl_gl_lines)
				glf.gl_vertex2d (b.center.x, b.center.y)
				glf.gl_vertex2d (b.center.x + b.velocity.x, b.center.y + b.velocity.y)
			glf.gl_end
			
			v := b.angular_velocity.scale (10) --.cross (b.radvec)
			
			glf.gl_color3f(0,1,1)
			glf.gl_line_width (2)
			glf.gl_begin (ogl.gl_constants.esdl_gl_lines)
				glf.gl_vertex2d (b.center.x, b.center.y)
				glf.gl_vertex2d (b.center.x + v.x, b.center.y + v.z)
			glf.gl_end
			
			
		end

	draw_ball(ogl: Q_GL_DRAWABLE; b: Q_BALL) is
			--- Draw ball on screen.
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
			-- Draw bank on screen.
		local
			glf: GL_FUNCTIONS
		do
			glf := ogl.gl
			
			-- don't use color3b or color3i, that does not work!
			glf.gl_color3f(1,0,0)
			glf.gl_line_width (4)
			
			glf.gl_begin (ogl.gl_constants.esdl_gl_lines)

			glf.gl_vertex2d (b.edge1.x, b.edge1.y)
			glf.gl_vertex2d (b.edge2.x, b.edge2.y)
			
			glf.gl_end
		end		
		
	draw_track (ogl: Q_GL_DRAWABLE) is
			-- Draw track lines for ball
		local
			glf: GL_FUNCTIONS
--			cursor: DS_LINKED_LIST_CURSOR[Q_VECTOR_2D]
		do
			glf := ogl.gl
			
			-- don't use color3b or color3i, that does not work!
			glf.gl_color3f(0,1,0)
			glf.gl_line_width (1)
			
			glf.gl_begin (ogl.gl_constants.esdl_gl_line_strip)

--			create cursor.make (simulation.position_list)
--			create cursor.make (ballpos_list)
			from ballpos_list.start
			until
				ballpos_list.after
			loop
				glf.gl_vertex2d (ballpos_list.item.x, ballpos_list.item.y)				
				ballpos_list.forth
			end
			
			glf.gl_end
			
		end

	simulation: Q_SIMULATION
	
	table: Q_TABLE
	
	balls: ARRAY[Q_BALL]
	banks: ARRAY[Q_BANK]
	
	ball1: Q_BALL
	ball2: Q_BALL
	ball3: Q_BALL
	
	bank1, bank2, bank3, bank4: Q_BANK
	
	shot: Q_SHOT

	ballpos_list: LINKED_LIST[Q_VECTOR_2D]

end -- class ACE_PHYS_TEST_OBJECT
