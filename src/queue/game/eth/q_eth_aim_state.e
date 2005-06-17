indexing
	description: "Allows to set, in witch direction the ball is shot"
	author: "Severin Hacker"

class
	Q_ETH_AIM_STATE

inherit
	Q_AIM_STATE
	redefine
		install, uninstall
	end

creation
	make_mode
	
feature{NONE} -- creation
	make_mode( mode_ : Q_ETH ) is
		do
			make
			mode := mode_
		end
	
	mode : Q_ETH
	
feature
	identifier : STRING is
		do
			result := "eth aim"
		end
		
	install( ressources_ : Q_GAME_RESSOURCES ) is
		do
			set_ball( mode.table.balls.item( mode.white_number ))
			
			precursor( ressources_ )			
			ressources_.gl_manager.add_hud( mode.time_info_hud )
			mode.time_info_hud.start
		end
		
	uninstall( ressources_ : Q_GAME_RESSOURCES ) is
		do
			precursor( ressources_ )
			ressources_.gl_manager.remove_hud( mode.time_info_hud )
			mode.time_info_hud.stop
		end	
		
	prepare_next_state( direction_ : Q_VECTOR_2D; ressources_ : Q_GAME_RESSOURCES ): Q_GAME_STATE is
		local
			spin_ : Q_ETH_SPIN_STATE
		do
			spin_ ?= ressources_.request_state( "eth spin" )
			if spin_ = void then
				create spin_.make_mode( mode )
				ressources_.put_state( spin_ )
			end
			spin_.set_ball( ball )
			spin_.set_shot( create {Q_SHOT}.make (ball, direction_) )
			spin_.set_shot_direction( direction_ )
			result := spin_
		end

end -- class Q_8BALL_AIM_STATE
