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
	description: "From all Buttons added to this group, only one will be selected."
	author: "Benjamin Sigg"

class
	Q_HUD_SELECTABLE_BUTTON_GROUP

creation
	make

feature{NONE} -- creation and members
	buttons : ARRAYED_LIST[ Q_HUD_SELECTABLE_BUTTON ]

	make is
		do
			create buttons.make( 10 )
		end

feature {Q_HUD_SELECTABLE_BUTTON} -- event-handling
	changing : BOOLEAN

	changed( value_ : BOOLEAN; button_ : Q_HUD_SELECTABLE_BUTTON ) : BOOLEAN is
		do
			if changing then
				result := not value_
			else
				changing := true
				
				if value_ then
					from
						buttons.start
					until
						buttons.after
					loop
						buttons.item.set_selected( false )
						buttons.forth
					end					
					result := true
				else
					result := false	
				end
				
				changing := false
			end
		end
		
feature -- buttons
	add( button_ : Q_HUD_SELECTABLE_BUTTON ) is
		do
			if button_.group /= void then
				button_.group.remove( button_ )
			end
			
			buttons.extend( button_ )
			button_.set_group( current )
		end
		
	remove( button_ : Q_HUD_SELECTABLE_BUTTON ) is
		do
			if button_.group = current then
				buttons.prune( button_ )
				button_.set_group( void )
			end
		end
		

end -- class Q_HUD_SELECTABLE_BUTTON_GROUP
