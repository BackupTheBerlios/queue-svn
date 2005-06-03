indexing
	description: "Supreclass for many gamestates witch needs to acces the escape-menu"
	author: "Benjamin Sigg"

deferred class
	Q_ESCAPABLE_STATE

inherit
	Q_GAME_STATE
	
		
feature{Q_DEFAULT_GAME_STATE}

	next_state : Q_GAME_STATE

	goto_escape_menu( ressources_ : Q_GAME_RESSOURCES ) is
		local
			escape_ : Q_ESCAPE_STATE
		do
			escape_ ?= ressources_.request_state( "escape" )
			if escape_ = void then
				create escape_.make
				ressources_.put_state( escape_ )
			end
			
			escape_.call_from( current )
			next_state := escape_
		end
	
	next( ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
		do
			result := next_state
			next_state := void
		end

end -- class Q_ESCAPABLE_STATE
