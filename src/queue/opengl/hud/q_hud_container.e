indexing
	description: "Contains one or many Q_HUD_COMPONENTS. The coordinate-system of this components is translated by the container"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_HUD_CONTAINER

inherit
	Q_HUD_COMPONENT

creation
	make
	
feature {NONE} -- creation
	make is
		do
			default_create	
			create children.make( 20 )
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
				
				open_gl.gl.gl_push_matrix
				
				open_gl.gl.gl_translated( component_.x, component_.y, 0 )
				component_.draw( open_gl )
				
				open_gl.gl.gl_pop_matrix

				children.forth	
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
			children.extend( component_ )
		end
		
	remove( component_ : Q_HUD_COMPONENT ) is
			-- removes the given component, if it is child of this container
		require
			component_not_void : component_ /= void
		local
			index_ : INTEGER
		do
			index_ := children.index_of( component_, 0 )
			if index_ > 0 then
				children.go_i_th( index_ )
				children.remove
				
				component_.set_parent( void )
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
