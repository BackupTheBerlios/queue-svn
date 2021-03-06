--
--  queue
--
--  Copyright (C) 2005  
--  Basil Fierz, Severin Hacker, Andreas Kaegi, Benjamin Sigg
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU Library General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
--

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
			create balls.make (0, 2)
			create banks.make (0, 19)
			
			create ball1.make (create {Q_VECTOR_2D}.make (50, 60), 2.5)
			ball1.set_mu_sf (0.05)
			ball1.set_mu_rf	(1.0)
			ball1.set_mass (0.2)
--			ball1.set_angular_velocity (create {Q_VECTOR_3D}.make (10, 0, 0))
			
			create ball2.make (create {Q_VECTOR_2D}.make (100, 60), 2.5)
			ball2.set_mu_sf (0.05)
			ball2.set_mu_rf	(1.0)
			ball2.set_mass (0.2)
			ball2.set_number (1)
			
			create ball3.make (create {Q_VECTOR_2D}.make (200, 20), 2.5)
			ball3.set_mu_sf (0.05)
			ball3.set_mu_rf	(1.0)
			ball3.set_mass (0.2)
			ball3.set_number (2)
			
--			banks.put (create {Q_BANK}.make (create {Q_VECTOR_2D}.make (150, -100), create {Q_VECTOR_2D}.make (150, 100)), 0)
			
			
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
			
--			banks.put (bank1, 1)
--			banks.put (bank2, 2)
--			banks.put (bank3, 3)
--			banks.put (bank4, 4)

			balls.put (ball1, 0)
			balls.put (ball2, 1)
			balls.put (ball3, 2)
			
			create table.make (balls, banks, void)

			-- ball1.set_velocity (create {Q_VECTOR_2D}.make (500, 125))
--			ball2.set_velocity (create {Q_VECTOR_2D}.make (-90, -24))
--			ball1.set_angular_velocity (create {Q_VECTOR_3D}.make (30, 0, 0))
			
			ballpos_list.wipe_out
			
			create shot.make (ball1, create {Q_VECTOR_2D}.make (100, 50))

			simulation.new (table, shot)
		end

	draw (ogl: Q_GL_DRAWABLE) is
			-- Draw visualisation.
		local
		do
			simulation.step (table, Void)
			
			draw_ball (ogl, ball1)
			draw_ball (ogl, ball2)
			draw_ball (ogl, ball3)
			
			banks.do_all (agent draw_bank (ogl, ?))
			
--			ballpos_list.force_right (ball1.center)
			ballpos_list.put_right (ball1.center)
			
			draw_track (ogl)
			draw_ballvectors (ogl, ball1)
			
			io.putstring (ball1.angular_velocity.out)
			io.put_new_line
			
			if simulation.has_finished then
				io.putstring ("simulation finished")
				io.put_new_line
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
			glf.gl_disable (ogl.gl_constants.esdl_gl_lighting)
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
			
			glf.gl_enable (ogl.gl_constants.esdl_gl_lighting)
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
--			glf.gl_color3f(0,1,0)
			glf.gl_line_width (2)
			glf.gl_disable (ogl.gl_constants.esdl_gl_lighting)
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
			glf.gl_enable (ogl.gl_constants.esdl_gl_lighting)
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
