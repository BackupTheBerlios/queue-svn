indexing
	description: "The white ball has fallen in the opening shot, let users decide"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_8BALL_OPENING_WHITE_FALLEN_RULE

inherit
	Q_8BALL_RULE

create
	make_mode
	
feature -- rule

	make_mode( mode_ : Q_8BALL ) is
		do
			mode := mode_
		end
		
	identifier :STRING is "8ball opening white has fallen rule"
	
	is_guard_satisfied(colls_: LIST[Q_COLLISION_EVENT]): BOOLEAN is
		local
			fb_: LINKED_LIST[INTEGER]
		do
			fb_ := mode.fallen_balls (colls_)
			Result := mode.first_shot and then is_correct_opening (colls_) and then fb_.has(white_number) and not fb_.has(8)
		end
		
	next_state(ressources_: Q_GAME_RESSOURCES) : Q_GAME_STATE is
			-- rule 4.7
			-- white has fallen in a correct opening shot
			-- Der dann aufnahmeberechtigte Spieler hat Lageverbesserung im Kopffeld und darf keine Kugel direkt anspielen, 
		local
			reset_state_ : Q_8BALL_RESET_STATE
			aim_state_: Q_8BALL_AIM_STATE
		do
			reset_state_ ?= ressources_.request_state( "8ball reset" )
			if reset_state_ = void then
				reset_state_ := create {Q_8BALL_RESET_STATE}.make_mode( mode )
				ressources_.put_state( reset_state_ )
			end
			reset_state_.set_headfield (true)
			-- player can shot only out of headfield in next turn
			aim_state_ ?= ressources_.request_state ("8ball aim")
			aim_state_.set_out_of_headfield (true)
			mode.switch_players
			Result := reset_state_
		end
		
end -- class Q_8BALL_OPENING_WHITE_FALLEN_RULE
