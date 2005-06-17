indexing
	description: "Objects that ..."
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_8BALL_OPENING_BW_FALLEN_RULE

inherit
	Q_8BALL_RULE
	
create
	make_mode
	
feature -- rule
	make_mode( mode_ : Q_8BALL ) is
		do
			mode := mode_
		end
		
	identifier :STRING is "8ball opening black & white have fallen rule"
		
	is_guard_satisfied(colls_: LIST[Q_COLLISION_EVENT]): BOOLEAN is
		local
			fb_: LINKED_LIST[INTEGER]
		do
			fb_ := mode.fallen_balls (colls_)
			Result := mode.first_shot and then is_correct_opening (colls_) and then fb_.has(8) and then fb_.has (white_number)
		end
		
	action is
		do
		end
		
	next_state(ressources_: Q_GAME_RESSOURCES) : Q_GAME_STATE is
			-- rule 4.9 second part
			--(2) Fallen dem Spieler beim Eröffnungsstoß die Weiße und die "8", so kann der Gegner
			--a) neu aufbauen lassen oder
			--b) die "8" wieder einsetzen lassen und aus dem Kopffeld weiterspielen.
		local
			choice_state_ : Q_8BALL_CHOICE_STATE
		do

				choice_state_ ?= ressources_.request_state ("8ball 8 and white fallen")
				if choice_state_ = void then
					create choice_state_.make_mode_titled (mode,"Correct opening but 8 and white have fallen", "8ball 8 and white fallen",2)
					choice_state_.button (1).set_text ("Rebuild the table and start yourself")
					choice_state_.button (1).actions.force (agent handle_restart(ressources_,?,?,choice_state_))
					choice_state_.button (2).set_text ("Set 8, reset white in headfield and continue playing")
					choice_state_.button (2).actions.force (agent handle_set8_and_continue_in_headfield(ressources_,?,?,choice_state_))
				end
				result := choice_state_
		end

end -- class Q_8BALL_OPENING_BW_FALLEN_RULE
