indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BEN_CHOICE_TEST_STATE

inherit
	Q_GAME_STATE
	
feature{NONE}

	install (ressources_: Q_GAME_RESSOURCES) is
		do
			
		end
		
	uninstall (ressources_: Q_GAME_RESSOURCES) is
		do
			
		end

	step (ressources_: Q_GAME_RESSOURCES) is
		do
			
		end

	next (ressources_: Q_GAME_RESSOURCES) : Q_GAME_STATE is
		local
			index_, count_ : INTEGER
		do
			count_ := 17
			create choice.make( "bla", count_ )
			
			from
				index_ := 1
			until
				index_ > count_
			loop
				choice.button( index_ ).set_text( index_.out )
				choice.button( index_ ).actions.extend( agent jump(?,?) )
				index_ := index_ + 1
			end
			
			result := choice
		end
		
	choice : Q_CHOICE_STATE
		
	jump( s : STRING; b : Q_HUD_BUTTON ) is
		do	
			choice.set_next_state( create {Q_ESCAPE_STATE}.make ( false ) )
		end	
		
		
	identifier : STRING is "nix los"
		
end -- class BEN_CHOICE_TEST_STATE
