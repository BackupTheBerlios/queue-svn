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
			set_max_key_pressed( 2 )
		end
		
feature -- interaction
	ensure_subset( map_ : Q_KEY_MAP ) is
			-- Ensures only keys that are marked as pressed in this
			-- map are also marked as pressed in map_
		do
			from
				map_.keys.start
			until
				map_.keys.after
			loop
				if pressed( map_.keys.item ) then
					map_.keys.forth
				else
					map_.keys.remove
				end
			end
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
		

feature -- set
	tell_pressed( key_ : INTEGER ) is
			-- tells that a key is pressed. If the number of pressed keys
			-- is greater than the maximum, the oldest pressed key will
			-- be marked as not-pressed
		do
			if not keys.has( key_ ) then
				keys.extend( key_ )
			end
			
			if keys.count > max_key_pressed then
				keys.start
				keys.remove
			end
		end
		
	tell_released( key_ : INTEGER ) is
		do
			keys.prune_all( key_ )
		end
		
	max_key_pressed : INTEGER
		-- how many keys can be pressed maximally.
		
	set_max_key_pressed( max_ : INTEGER ) is
		require
			max_ > 0
		do
			max_key_pressed := max_
			
			from keys.start	until keys.count <= max_key_pressed	loop
				keys.remove
			end
		end
		
feature{Q_KEY_MAP}
	keys : ARRAYED_LIST[ INTEGER ]

end -- class Q_KEY_MAP
