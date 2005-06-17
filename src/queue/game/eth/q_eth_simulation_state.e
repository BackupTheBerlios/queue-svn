indexing
	description: "Objects that call the physics engine and deal with the rules"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_ETH_SIMULATION_STATE

inherit
	Q_SIMULATION_STATE
	redefine
		install, uninstall
	end
	
creation
	make_mode
	
feature{NONE}
	make_mode( mode_ : Q_ETH ) is
		do
			make
			mode := mode_
		end
		
feature
	
	identifier : STRING is
		do
			Result := "eth simulation"
		end
		
	install( ressources_ : Q_GAME_RESSOURCES ) is
		do
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
		
	simulation_step (ressources_: Q_GAME_RESSOURCES): BOOLEAN is
			-- Makes one step of the physics. If the physics has done its job, false is
			-- returns. If the physics is still working, true is returned.
		do
			if not ressources_.simulation.has_finished then
				ressources_.simulation.step (ressources_.mode.table, ressources_.time)
--				mode.time_info_hud.set_time (mode.time_info_hud.time+ressources_.time.delta_time_millis)
				delete_fallen_balls(ressources_)
				Result := true
			else
				Result := false
			end
		end
		
	prepare_next_state (ressources_: Q_GAME_RESSOURCES): Q_GAME_STATE is
		-- what do to after physics has finished
		do
			-- ask the mode what to do according to result set
			Result := ressources_.mode.next_state (ressources_)
		end
		
feature{NONE}
	mode : Q_ETH
	
	delete_fallen_balls(ressources_: Q_GAME_RESSOURCES) is
		 -- delete the fallen balls
		 local
			fb_ : LINKED_LIST[INTEGER]
		 do
		 	-- don't draw them and set them away from other balls
			fb_ := mode.fallen_balls (ressources_.simulation.collision_list.deep_twin)
			from
				fb_.start
			until
				fb_.after
			loop
				mode.ball_to_ball_model (mode.table.balls.item(fb_.item)).set_visible (false)
				mode.table.balls.item (fb_.item).set_center (create {Q_VECTOR_2D}.make (0,0))
				fb_.forth
			end
		end
		
	
end -- class Q_8BALL_SIMULATION
