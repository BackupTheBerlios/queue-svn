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
	description: "Tells a Q_HUD_CONTAINER witch components gets the focus, when a key is pressed"
	author: "Benjamin Sigg"
	revision: "1.0"

deferred class
	Q_FOCUS_HANDLER
	
feature -- focus handling
	focus_default( parent_ : Q_HUD_CONTAINER ) is
			-- Sets the focus to a default-component of the given container
		require
			parent_not_void : parent_ /= void
		deferred
		end
		

	next( component_ : Q_HUD_COMPONENT; parent_ : Q_HUD_CONTAINER; event_ : ESDL_KEYBOARD_EVENT ) : Q_HUD_COMPONENT is
			-- Searches the next component witch should be focused.
			-- if there was no old component, void is set as component_
			-- the value parent_ is the container this handler belongs to. So parent_
			-- is perhaps not the direct parent of component_
			-- event_ is the event forwarded to this handler
			-- returns the new component witch should have the focus, or
			-- void if the event is not interessting, or no new focus-component can be found
		require
			parent_not_void : parent_ /= void
			event_not_void : event_ /= void
		deferred
		ensure
			result = void or else (result.enabled and result.focusable)
		end
		

end -- class Q_FOCUS_HANDLER
