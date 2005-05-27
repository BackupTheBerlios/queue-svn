indexing
	description: "Contains one or many Q_HUD_COMPONENTS. The coordinate-system of this components is translated by the container"
	author: "Benjamin Sigg"

class
	Q_HUD_CONTAINER

inherit
	Q_HUD_COMPONENT
	redefine
		process_key_down,
		draw_foreground,
		make,
		enqueue
	end

creation
	make
	
feature {NONE} -- creation
	make is
		do
			precursor
			create children.make( 20 )
			set_enabled( true )
			set_focusable( false )
			
			set_background( void )
			set_foreground( create {Q_GL_COLOR}.make_black )
		end
		

feature -- visualisation
	visible : BOOLEAN is
		do
			result := false
		end
		

	enqueue( queue_ : Q_HUD_QUEUE ) is
		do
			precursor( queue_ )
			from
				children.start
			until
				children.after
			loop
				queue_.push_matrix
				queue_.translate( children.item.x, children.item.y, 0 )
				children.item.enqueue( queue_ )
				queue_.pop_matrix
				
				children.forth
			end
		end
		

	draw_foreground( open_gl : Q_GL_DRAWABLE ) is
	--	local
	--		component_ : Q_HUD_COMPONENT
		do
	--		from
	--			children.start
	--		until
	--			children.after
	--		loop
	--			component_ := children.item
				
	--			open_gl.gl.gl_translated( component_.x, component_.y, 0 )
	--			component_.draw( open_gl )
	--			open_gl.gl.gl_translated( -component_.x, -component_.y, 0 )

	--			children.forth	
	--		end
		end

feature -- eventhandling
	focus_handler : Q_FOCUS_HANDLER
	
	set_focus_handler( handler_ : Q_FOCUS_HANDLER ) is
		do
			focus_handler := handler_
		end
		
feature{Q_HUD_CONTAINER} -- eventhandling
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

	tell_added( component_ : Q_HUD_COMPONENT; parent_ : Q_HUD_CONTAINER; child_ : Q_HUD_COMPONENT ) is
			-- Tells the component_, that a child was added, and tells the same to all childs of the component
		local
			container_ : Q_HUD_CONTAINER
			index_ : INTEGER
		do
			component_.process_component_added( parent_, child_ )
			container_ ?= component_
			if container_ /= void then
				from index_ := 0 until index_ = container_.child_count loop
					tell_added( container_.get_child( index_ ), parent_, child_ )
					index_ := index_+1
				end
			end
		end
		
	tell_removed( component_ : Q_HUD_COMPONENT; parent_ : Q_HUD_CONTAINER; child_ : Q_HUD_COMPONENT ) is
			-- Tells the component_, that a child was removed, and tells the same to all childs of the component
		local
			container_ : Q_HUD_CONTAINER
			index_ : INTEGER
		do
			component_.process_component_removed( parent_, child_ )
			container_ ?= component_
			if container_ /= void then
				from index_ := 0 until index_ = container_.child_count loop
					tell_removed( container_.get_child( index_ ), parent_, child_ )
					index_ := index_+1
				end
			end
		end

feature -- childs
	add( component__ : Q_HUD_COMPONENT ) is
		require
			component_not_void : component__ /= void
			is_not_a_toplevel_component : component__.is_toplevel = false
		local
			component_ : Q_HUD_COMPONENT
		do
			component_ := component__
			
			if component_.is_toplevel then
				-- don't do this!
				
				component_ := void
			end
		
			if component_.parent /= void then
				component_.parent.remove( component_ )
			end
			
			component_.set_parent( current )
			children.extend( component_ )
			tell_added( component_, current, component_ )
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
				tell_removed( component_, current, component_ )
				
				if root_pane /= void then
					root_pane.removed( component_ )
				end
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
		
feature{NONE} -- implementation
	children : ARRAYED_LIST[ Q_HUD_COMPONENT ]

end -- class Q_HUD_CONTAINER
