indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_8BALL_WON_RULE

inherit
	Q_8BALL_RULE
create
	make_mode
	
feature -- rule

	make_mode( mode_ : Q_8BALL ) is
		do
			mode := mode_
		end
		
	identifier:STRING is "8ball won rule"
		
	is_guard_satisfied(colls_: LIST[Q_COLLISION_EVENT]): BOOLEAN is
		do
			Result := is_game_won (colls_)
		end
		
	next_state(ressources_: Q_GAME_RESSOURCES) : Q_GAME_STATE is
		local
			choice_state_ : Q_8BALL_CHOICE_STATE
		do
			choice_state_ ?= ressources_.request_state("8ball won")
			if choice_state_ = void then
				create choice_state_.make_mode_titled (mode, mode.active_player.name+" wins", "8ball won", 2)
				choice_state_.button (1).set_text ("Play again")
				choice_state_.button (1).actions.force (agent handle_restart(ressources_,?,?,choice_state_))
				choice_state_.button (2).set_text ("Main menu")
				choice_state_.button (2).actions.force (agent handle_main_menu(ressources_,?,?,choice_state_))
			end
			choice_state_.set_title (mode.active_player.name+" wins")
			Result := choice_state_
		end
		
end -- class Q_8BALL_WON_RULE
