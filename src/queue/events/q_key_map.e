indexing
	description: "A map of currently pressed keys."
	author: "Benjamin Sigg"

class
	Q_KEY_MAP

inherit
		SDLKEY_ENUM_EXTERNAL

creation
	make
	
feature{NONE}
	make is
		do
			create keys.make( 20 )
		end
		

feature -- access
	pressed( key_ : INTEGER ) : BOOLEAN is
			-- true if the given key is pressed, false otherwise
		do
			result := keys.has( key_ )
		end
		
	ctrl : BOOLEAN is
		do
			result := pressed( sdlk_lctrl ) or pressed( sdlk_rctrl )
		end
		
	shift : BOOLEAN is
		do
			result := pressed( sdlk_lshift ) or pressed( sdlk_rshift )
		end

	alt : BOOLEAN is
		do
			result := pressed( sdlk_lalt ) or pressed( sdlk_ralt )
		end
		

feature{Q_EVENT_QUEUE} -- set
	tell_pressed( key_ : INTEGER ) is
		do
			if not keys.has( key_ ) then
				keys.extend( key_ )
			end
		end
		
	tell_released( key_ : INTEGER ) is
		do
			keys.prune_all( key_ )
		end
		
feature{NONE}
	keys : ARRAYED_LIST[ INTEGER ]

end -- class Q_KEY_MAP
