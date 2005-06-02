indexing
	description: "The state where the player can aim, where a ball should be shoot at"
	author: "Benjamin Sigg"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	Q_AIM_STATE

inherit
	Q_GAME_STATE

feature
	install( ressource_ : Q_GAME_RESSOURCES ) is
		local
			vector_ : Q_VECTOR_3D
		do
			if line = void then
				create line.make( 
					create {Q_VECTOR_3D}, create {Q_VECTOR_3D}, 20 )
					
				create behaviour.make
				
				behaviour.set_ball( ball )
			end
			
			ressource_.gl_manager.add_object( line )
			ressource_.gl_manager.set_camera_behaviour( behaviour )
			
			vector_ := ressource_.table_model.position_table_to_world( ball.center )
			line.set_a( vector_ )
			line.set_b( create {Q_VECTOR_3D}.make( vector_.x, vector_.y + 20 * ball.radius, vector_.z ) )
		end
		
	uninstall( ressource_ : Q_GAME_RESSOURCES ) is
		do
			ressource_.gl_manager.remove_object( line )
			ressource_.gl_manager.set_camera_behaviour( void )
		end
		
	step( ressource_ : Q_GAME_RESSOURCES ) is
		local
			camera_ : Q_VECTOR_3D
		do
			camera_ := ressource_.gl_manager.camera.view_direction
			direction := ressource_.table_model.direction_world_to_table( camera_ )
		end

feature {Q_AIM_STATE}
	direction : Q_VECTOR_2D
		-- the direction, where the ball should be fired to

	ball : Q_BALL
		-- the ball, witch will be shot

	set_ball( ball_ : Q_BALL ) is
		do
			ball := ball_
		end
		
		
feature{NONE} -- internals
	line : Q_GL_BROKEN_LINE
	
	behaviour : Q_BALL_CAMERA_BEHAVIOUR

end -- class Q_AIM_STATE
