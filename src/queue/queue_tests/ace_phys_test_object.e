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
			create pos_list.make
			
			new
		end
		

feature -- interface

	new is
			-- Reinitialize scene.
		do
			create balls.make (1, 1)
			create banks.make (1, 4)
			
			create ball.make (create {Q_VECTOR_2D}.make (300, 0), 10)
			create bank1.make (create {Q_VECTOR_2D}.make (500, -300), create {Q_VECTOR_2D}.make (500, 300))
			create bank2.make (create {Q_VECTOR_2D}.make (-50, -300), create {Q_VECTOR_2D}.make (-50, 300))
			create bank3.make (create {Q_VECTOR_2D}.make (-50, 300), create {Q_VECTOR_2D}.make (500, 300))
			create bank4.make (create {Q_VECTOR_2D}.make (-50, -300), create {Q_VECTOR_2D}.make (500, -300))
			
			balls.put (ball, 1)
			banks.put (bank1, 1)
			banks.put (bank2, 2)
			banks.put (bank3, 3)
			banks.put (bank4, 4)
			
			create table.make (balls, banks, void)

			ball.set_velocity (create {Q_VECTOR_2D}.make (500, 125))
			ball.set_angular_velocity (create {Q_VECTOR_3D}.make (0, 1, 0))
			
			simulation.position_list.wipe_out
			simulation.position_list.put_first (create {Q_VECTOR_2D}.make_from_other (ball.center))
		
-- inserted void by Beni, I wan't to compile the programm ;-)=
			simulation.new (table, void)
		end

	draw (ogl: Q_GL_DRAWABLE) is
			-- Draw visualisation.
		local
		do
			simulation.step (table)
			
			draw_ball (ogl, ball)
			draw_bank (ogl, bank1)
			draw_bank (ogl, bank2)
			draw_bank (ogl, bank3)
			draw_bank (ogl, bank4)

			draw_track (ogl)
		end
		
		
feature {NONE} -- implementation

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
			cursor: DS_LINKED_LIST_CURSOR[Q_VECTOR_2D]
		do
			glf := ogl.gl
			
			-- don't use color3b or color3i, that does not work!
			glf.gl_color3f(0,1,0)
			glf.gl_line_width (1)
			
			glf.gl_begin (ogl.gl_constants.esdl_gl_line_strip)

			create cursor.make (simulation.position_list)
			from cursor.start
			until
				cursor.after
			loop
				glf.gl_vertex2d (cursor.item.x, cursor.item.y)				
				cursor.forth
			end
			
			glf.gl_end
			
		end

	simulation: Q_SIMULATION
	
	table: Q_TABLE
	
	balls: ARRAY[Q_BALL]
	banks: ARRAY[Q_BANK]
	
	ball: Q_BALL
	bank1, bank2, bank3, bank4: Q_BANK
	
	pos_list: DS_LINKED_LIST[Q_VECTOR_2D]

end -- class ACE_PHYS_TEST_OBJECT
