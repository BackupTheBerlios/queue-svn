--
--  queue
--
--  Copyright (C) 2005  
--  Basil Fierz, Severin Hacker, Andreas Kaegi, Benjamin Sigg
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU Library General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
--

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
	is_write_key( key_ : INTEGER ) : BOOLEAN is
			-- true if the key is a letter, number or another sign witch have
			-- a associated sign in the standard-fonts
		do
			result :=
				-- number
				key_ = sdlk_0 or
				key_ = sdlk_1 or
				key_ = sdlk_2 or
				key_ = sdlk_3 or
				key_ = sdlk_4 or
				key_ = sdlk_5 or
				key_ = sdlk_6 or
				key_ = sdlk_7 or
				key_ = sdlk_8 or
				key_ = sdlk_9 or
				
				-- standard letter
				key_ = sdlk_a or
				key_ = sdlk_b or
				key_ = sdlk_c or
				key_ = sdlk_d or
				key_ = sdlk_e or
				key_ = sdlk_f or
				key_ = sdlk_g or
				key_ = sdlk_h or
				key_ = sdlk_i or
				key_ = sdlk_j or
				key_ = sdlk_k or
				key_ = sdlk_l or
				key_ = sdlk_m or
				key_ = sdlk_n or
				key_ = sdlk_o or
				key_ = sdlk_p or
				key_ = sdlk_q or
				key_ = sdlk_r or
				key_ = sdlk_s or
				key_ = sdlk_t or
				key_ = sdlk_u or
				key_ = sdlk_v or
				key_ = sdlk_w or
				key_ = sdlk_x or
				key_ = sdlk_y or
				key_ = sdlk_z or
				
				-- signs
				key_ = sdlk_ampersand or
				key_ = sdlk_asterisk or
				key_ = sdlk_at or
				key_ = sdlk_colon or
				key_ = sdlk_comma or
				key_ = sdlk_compose or
				key_ = sdlk_dollar or
				key_ = sdlk_euro or
				key_ = sdlk_exclaim or
				key_ = sdlk_kp_divide or
				key_ = sdlk_kp_equals or
				key_ = sdlk_kp_minus or
				key_ = sdlk_kp_multiply or
				key_ = sdlk_kp_period or
				key_ = sdlk_kp_plus or
				key_ = sdlk_leftbracket or
				key_ = sdlk_leftparen or
				key_ = sdlk_less or
				key_ = sdlk_minus or
				key_ = sdlk_period or
				key_ = sdlk_plus or
				key_ = sdlk_power or
				key_ = sdlk_quote or
				key_ = sdlk_quotedbl or
				key_ = sdlk_rightbracket or
				key_ = sdlk_rightparen or
				key_ = sdlk_semicolon or
				key_ = sdlk_slash or
				key_ = sdlk_space or
				key_ = sdlk_tab or
				key_ = sdlk_underscore
		end
		

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
