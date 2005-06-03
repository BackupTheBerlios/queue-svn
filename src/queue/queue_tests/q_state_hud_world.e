indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_STATE_HUD_WORLD
	
inherit
	Q_GAME_STATE
	Q_HUD_COMPONENT
	redefine
		process_mouse_button_down,
		process_key_down,
		make
	end
		
creation
	make
	
feature
	make is
		do
			precursor
			
			set_enabled( true )
			set_focusable( true )
			set_lightweight( true )
			
			set_bounds( 0, 0, 1, 1 )
			
			set_background( void )
		end
		
		
feature
	identifier : STRING is "test"
	
	ressources : Q_GAME_RESSOURCES

	draw_foreground( open_gl : Q_GL_DRAWABLE ) is
		local
			position_ : Q_VECTOR_2D
		do
			if cube /= void then
				position_ := ressources.gl_manager.position_world_to_hud(
					create {Q_VECTOR_3D}.make( cube.x, cube.y, cube.z ))
					
				open_gl.gl.gl_color3f( 1, 1, 1 )
				open_gl.gl.gl_rectd( position_.x - 0.05, position_.y - 0.05,
					position_.x + 0.05, position_.y + 0.05 )
					
				position_ := ressources.gl_manager.direction_world_to_hud( direction )

				open_gl.gl.gl_color3f( 1, 0, 0 )
				open_gl.gl.gl_rectd( position_.x - 0.01, position_.y - 0.01,
					position_.x + 0.01, position_.y + 0.01 )				
				
			end
		end
		
	visible : BOOLEAN is true

	armed : BOOLEAN

	cube : Q_GL_COLOR_CUBE

	direction : Q_VECTOR_3D

	process_mouse_button_down (event_: ESDL_MOUSEBUTTON_EVENT; x_, y_: DOUBLE): BOOLEAN is
		local
			vector_ : Q_VECTOR_3D
			index_ : INTEGER
		do
			if armed then
				vector_ := ressources.gl_manager.position_hud_to_world( x_, y_ )
				direction := ressources.gl_manager.direction_hud_to_world( x_, y_ )
				
				from index_ := 0 until index_ > 9 loop
					vector_ := vector_ + direction
					create cube.make_positioned_and_sized( vector_.x, vector_.y, vector_.z, 1 )
					ressources.gl_manager.add_object( cube )
					index_ := index_ + 1
				end
				
				result := true
			else
				result := false
			end
		end

	process_key_down( event_: ESDL_KEYBOARD_EVENT ) : BOOLEAN is
		do
			if event_.key = event_.sdlk_space then
				armed := not armed
			end
			result := true
		end

	uninstall( ressources_ : Q_GAME_RESSOURCES ) is
		do
			
		end

	install( ressources_ : Q_GAME_RESSOURCES ) is
		local
			behaviour_ : Q_SIMPLE_CAMERA_BEHAVIOUR
		do
			ressources := ressources_
			ressources.gl_manager.add_hud( current )
			
			create behaviour_
			behaviour_.set_rotation_distance( 40 )
			ressources.gl_manager.set_camera_behaviour( behaviour_ )
			ressources.gl_manager.add_object( create {Q_GL_AXIS} )
			ressources.gl_manager.add_object( create {Q_GL_COLOR_CUBE}.make_sized( 20 ))
		end
		
	step( ressources_ : Q_GAME_RESSOURCES ) is
		do
			
		end

	next( ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
		do
			result := void
		end

end -- class Q_STATE_HUD_WORLD
