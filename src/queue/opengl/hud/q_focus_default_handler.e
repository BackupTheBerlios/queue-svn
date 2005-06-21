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
	description: "Default focushandler. Selects next component simply by going over the indices"
	author: "Benjamin Sigg"
	revision: "1.0"

class
	Q_FOCUS_DEFAULT_HANDLER

inherit
	Q_FOCUS_HANDLER
	
feature -- focus
	focus_default( parent_ : Q_HUD_CONTAINER ) is
		local
			component_, start_ : Q_HUD_COMPONENT
		do
			component_ := go_down( parent_ )
			if not component_.focusable or not component_.enabled then
				from
					start_ := component_
					component_ := get_next( component_, component_, parent_ )
				until
					component_ = void or else
					(component_.enabled and component_.focusable)
				loop
					component_ := get_next( component_, start_, parent_ )
				end
			end
			
			if component_ /= void then
				component_.request_focus
			end
		end
		

	next( component__ : Q_HUD_COMPONENT; parent_ : Q_HUD_CONTAINER; event_ : ESDL_KEYBOARD_EVENT ) : Q_HUD_COMPONENT is
		local
			component_ : Q_HUD_COMPONENT
		do
			component_ := component__
			
			if is_next_key( event_ ) then
				if component_ = void then
					component_ := go_down( parent_ )
					
					if component_.enabled and component_.focusable then
						result := component_
					else
						result := next( component_, parent_, event_ )
					end
				else
					from
						result := get_next( component_, component_, parent_ )
					until
						result = void or else
						(result.enabled and result.focusable)
					loop
						result := get_next( result, component_, parent_ )
					end
				end
			elseif is_previous_key( event_ ) then
				if component_ = void then
					component_ := go_down_backward( parent_ )
					
					if component_.enabled and component_.focusable then
						result := component_
					else
						result := next( component_, parent_, event_ )
					end
				else
					from
						result := get_previous( component_, component_, parent_ )
					until
						result = void or else
						(result.enabled and result.focusable)
					loop
						result := get_previous( result, component_, parent_ )
					end
				end
			end
		end
	
	is_next_key( event_ : ESDL_KEYBOARD_EVENT ) : BOOLEAN is
		require
			event_ /= void
		do
			result := event_.key = event_.sdlk_right or 
				event_.key = event_.sdlk_down or
				(event_.key = event_.sdlk_tab and not event_.is_shift_pressed)
				or event_.key = event_.sdlk_return
		end
		
	is_previous_key( event_ : ESDL_KEYBOARD_EVENT ) : BOOLEAN is
		require
			event_ /= void
		do
			result := event_.key = event_.sdlk_left or 
				event_.key = event_.sdlk_up or
				(event_.key = event_.sdlk_tab and event_.is_shift_pressed)			
		end
		
	
	get_next( current_component_, first_component_ : Q_HUD_COMPONENT; root_ : Q_HUD_CONTAINER ) : Q_HUD_COMPONENT is
		local
			index_ : INTEGER
			parent_ : Q_HUD_CONTAINER
			next_ : Q_HUD_COMPONENT
		do
			if current_component_ = root_ then
				-- no next component available, its not allowed to ask the parent
				-- restart traversing the tree
				
				next_ := current_component_
					
				-- traverse the new tree as deep as possible
				next_ := go_down( next_ )
				
				if next_ = current_component_ then
					next_ := void
				end
			else
				parent_ := current_component_.parent
				index_ := parent_.index_of_child( current_component_ )
			
				index_ := index_ + 1
				if index_ < parent_.child_count then
					next_ := parent_.get_child( index_ )
					
					-- traverse the new tree as deep as possible
					next_ := go_down( next_ )
				else
					next_ := parent_				
				end
			end
			
			result := next_
			
			if first_component_ = result then
				-- now all possible components are tested, stop it!
				result := void
			end
		end

	get_previous( current_component_, first_component_ : Q_HUD_COMPONENT; root_ : Q_HUD_CONTAINER ) : Q_HUD_COMPONENT is
		local
			index_ : INTEGER
			parent_ : Q_HUD_CONTAINER
			next_ : Q_HUD_COMPONENT
		do
			if current_component_ = root_ then
				-- no next component available, its not allowed to ask the parent
				-- restart traversing the tree
				
				next_ := current_component_
					
				-- traverse the new tree as deep as possible
				next_ := go_down_backward( next_ )
				
				if next_ = current_component_ then
					next_ := void
				end
			else
				parent_ := current_component_.parent
				index_ := parent_.index_of_child( current_component_ )
			
				index_ := index_ - 1
				if index_ >= 0 then
					next_ := parent_.get_child( index_ )
					
					-- traverse the new tree as deep as possible
					next_ := go_down_backward( next_ )
				else
					next_ := parent_				
				end
			end
			
			result := next_
			
			if first_component_ = result then
				-- now all possible components are tested, stop it!
				result := void
			end
		end		
		
	go_down( parent__ : Q_HUD_COMPONENT ) : Q_HUD_COMPONENT is
		local
			parent_ : Q_HUD_CONTAINER
			child_ : Q_HUD_COMPONENT
		do			
			from
				child_ := parent__
				parent_ ?= parent__
			until
				parent_ = void or else parent_.child_count = 0
			loop
				child_ := parent_.get_child( 0 )
				parent_ ?= child_
			end
			
			result := child_
		end
		
	go_down_backward( parent__ : Q_HUD_COMPONENT ) : Q_HUD_COMPONENT is
		local
			parent_ : Q_HUD_CONTAINER
			child_ : Q_HUD_COMPONENT
		do			
			from
				child_ := parent__
				parent_ ?= parent__
			until
				parent_ = void or else parent_.child_count = 0
			loop
				child_ := parent_.get_child( parent_.child_count - 1 )
				parent_ ?= child_
			end
			
			result := child_
		end
		
end -- class Q_FOCUS_DEFAULT_HANDLER
