indexing
	description: "Contains one or many Q_HUD_COMPONENTS. The coordinate-system of this components is translated by the container"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_HUD_CONTAINER

inherit
	Q_HUD_COMPONENT
	redefine
		process_key_down
	end

creation
	make
	
feature {NONE} -- creation
	make is
		do
			default_create	
			create children.make( 20 )
			set_enabled( true )
			set_focusable( false )
		end
		

feature -- visualisation
	draw( open_gl : Q_GL_DRAWABLE ) is
		local
			component_ : Q_HUD_COMPONENT
		do
			from
				children.start
			until
				children.after
			loop
				component_ := children.item
				
				open_gl.gl.gl_translated( component_.x, component_.y, 0 )
				component_.draw( open_gl )
				open_gl.gl.gl_translated( -component_.x, -component_.y, 0 )

				children.forth	
			end
		end

feature -- eventhandling
	focus_handler : Q_FOCUS_HANDLER
	
	set_focus_handler( handler_ : Q_FOCUS_HANDLER ) is
		do
			focus_handler := handler_
		end
		

	process_key_down( event_ : ESDL_KEYBOARD_EVENT ) : BOOLEAN is
		local
			component_, focused_component_ : Q_HUD_COMPONENT
		do
			result := false
			
			if focus_handler /= void then
				focused_component_ := root_pane.focused_component
				component_ := focus_handler.next( focused_component_, current, event_ )
				if component_ /= void then
					component_.request_focus
					result := true
				end
			end
		end
		

feature -- childs
	add( component_ : Q_HUD_COMPONENT ) is
		require
			component_not_void : component_ /= void
			is_not_a_toplevel_component : component_.is_toplevel = false
		do
			if component_.parent /= void then
				component_.parent.remove( component_ )
			end
			
			component_.set_parent( current )
			component_.process_component_added( current )
			children.extend( component_ )
		end
		
	remove( component_ : Q_HUD_COMPONENT ) is
			-- removes the given component, if it is child of this container
		require
			component_not_void : component_ /= void
		local
			index_ : INTEGER
		do
			index_ := children.index_of( component_, 0 )+1
			if index_ > 0 then
				children.go_i_th( index_ )
				children.remove
				
				component_.set_parent( void )
				component_.process_component_removed( current )
			end
		end
		
	remove_all is
			-- removes all childs from this container
		do
			from
				
			until
				children.count = 0
			loop
				remove( children.first )
			end
		end
		
	
	child_count : INTEGER is
		do
			result := children.count
		end
		
	get_child( index : INTEGER ) : Q_HUD_COMPONENT is
		-- gets the child with the given index.
		-- 0 based, like in every good programming language!
		do
			result := children.i_th ( index + 1 )
		end
		
	index_of_child( child_ : Q_HUD_COMPONENT ) : INTEGER is
		-- returns the index of a child. A value between 0 and count-1
		-- -1, if the child is not found
		do
			if children.has ( child_ ) then
				result := children.index_of ( child_, 1 ) - 1
			else
				result := -1
			end
		end
		
	
	tree_child_at( x_, y_ : DOUBLE ) : Q_HUD_COMPONENT is
			-- searches the whole tree, until the component under the
			-- given point is found.
			-- returns this, a child or void
		local
			child_ : Q_HUD_COMPONENT
			container_ : Q_HUD_CONTAINER
		do
			from
				result := void
				children.start
			until
				children.after or (result /= void)
			loop
				child_ := children.item
				
				if child_.inside( x_ - child_.x, y_ - child_.y ) then
					container_ ?= child_
					if container_ /= void then
						result := container_.tree_child_at( x_ - child_.x, y_ - child_.y )
					else
						result := child_
					end
				end
				children.forth
			end
			
			if result = void and inside( x_, y_ ) then
				result := current
			end
		end

feature{NONE} -- implementation
	children : ARRAYED_LIST[ Q_HUD_COMPONENT ]

end -- class Q_HUD_CONTAINER
