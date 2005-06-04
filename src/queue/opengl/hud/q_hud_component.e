indexing
	--description: "[A HUD-Component is painted at the top of
	--	an OpenGL-Drawable. Always the z-Coordinates are 0 (the
	--	glVertex2d-Methods can directly be used), the 0/0 coordinates
	--	markes the top left of the window, the 1/1 coordinates
	--	the bottom right.]"
	author: "Benjamin Sigg"

deferred class
	Q_HUD_COMPONENT

feature -- creation
	make is
		do
			set_enabled( true )
			set_lightweight( true )
			set_focusable( false )
			
			set_background( create {Q_GL_COLOR}.make_gray )
			set_foreground( create {Q_GL_COLOR}.make_black )
			
			create mouse_button_up_listener.make
			create mouse_button_down_listener.make
			create mouse_moved_listener.make
			create mouse_enter_listener.make
			create mouse_exit_listener.make
			create component_added_listener.make
			create component_removed_listener.make
			create key_down_listener.make
			create key_up_listener.make
		end
		
feature -- drawing
	enqueue( queue_ : Q_HUD_QUEUE ) is
			-- Inserts this component into the queue.
			-- A Container might call some of the matrix-features, and
			-- a container must call the enqueue-feature of its children
		do
			queue_.insert( current )
		end
		

	draw( open_gl : Q_GL_DRAWABLE ) is
			-- draws this, and only this, component.
		do
			draw_background( open_gl )
			draw_foreground( open_gl )
		end
		

	draw_foreground( open_gl : Q_GL_DRAWABLE ) is
			-- draws the foreground
		deferred
		end
		

	draw_background( open_gl : Q_GL_DRAWABLE ) is
		do			
			if background /= void then
				background.set( open_gl )

				if blend_background then
					open_gl.gl.gl_enable( open_gl.gl_constants.esdl_gl_blend )
					open_gl.gl.gl_blend_func( 
						open_gl.gl_constants.esdl_gl_src_alpha,
						open_gl.gl_constants.esdl_gl_one_minus_src_alpha )
				end

				open_gl.gl.gl_begin( open_gl.gl_constants.esdl_gl_quads )
				open_gl.gl.gl_vertex2d( 0, 0 )
				open_gl.gl.gl_vertex2d( width, 0 )
				open_gl.gl.gl_vertex2d( width, height )
				open_gl.gl.gl_vertex2d( 0, height )
				open_gl.gl.gl_end
				
				if blend_background then
					open_gl.gl.gl_disable( open_gl.gl_constants.esdl_gl_blend )
				end
			end
		end		

feature -- eventhandling
	enabled : BOOLEAN
		-- tells, if this Component will react on Events. A Component with enabled=false will not recieve any events
	
	focusable : BOOLEAN
		-- tells, if this Component can hold the focus. Only focusable Components will recieve Key-Events
		
	visible : BOOLEAN is
		-- true if the user can see this component (ex. true for Buttons or Textfields),
		-- false if the user cannot see this component (container or root_pane)
		-- If a user-visible component is behind a not-visible component, mouse-events will
		-- first be sent to the user-visible component
		deferred
		end
		
	focused : BOOLEAN is
			-- true if this component has the focus
		do
			result := root_pane /= void and then root_pane.focused_component = current	
		end

	lightweight : BOOLEAN
		-- if this component is disabled: if lightweight is true, the parent will get the event, if false,
		-- the event will be thrown away
		
	set_enabled( enabled_ : BOOLEAN ) is
		do
			enabled := enabled_
		end
	
	set_focusable( focusable_ : BOOLEAN ) is
		do
			focusable := focusable_
		end
		
	set_lightweight( lightweight_ : BOOLEAN ) is
		do
			lightweight := lightweight_
		end
		
	request_focus is
			-- requests focus for this component
		require
			focusable
			enabled
		do
			if root_pane /= void then
				root_pane.request_focused_component( current )	
			end
		end
		
feature -- listeners
	mouse_button_up_listener   : LINKED_LIST[ FUNCTION[ ANY, TUPLE[ESDL_MOUSEBUTTON_EVENT, DOUBLE, DOUBLE, Q_KEY_MAP, BOOLEAN], BOOLEAN]]
		-- event, x, y, map, consumed
		
	mouse_button_down_listener : LINKED_LIST[ FUNCTION[ ANY, TUPLE[ESDL_MOUSEBUTTON_EVENT, DOUBLE, DOUBLE, Q_KEY_MAP, BOOLEAN], BOOLEAN]]
		-- event, x, y, map, consumed
	
	mouse_moved_listener       : LINKED_LIST[ FUNCTION[ ANY, TUPLE[ESDL_MOUSEMOTION_EVENT, DOUBLE, DOUBLE, Q_KEY_MAP, BOOLEAN], BOOLEAN]]
		-- event, x, y, map, consumed
	
	mouse_enter_listener : LINKED_LIST[ PROCEDURE[ ANY, TUPLE[ DOUBLE, DOUBLE, Q_KEY_MAP]]]
		-- x, y, map
		
	mouse_exit_listener : LINKED_LIST[ PROCEDURE[ ANY, TUPLE[ DOUBLE, DOUBLE, Q_KEY_MAP]]]	
		-- x, y, map
	
	component_added_listener  : LINKED_LIST[ PROCEDURE[ ANY, TUPLE[ Q_HUD_COMPONENT, Q_HUD_COMPONENT ]]]
		-- parent, child
		
	component_removed_listener : LINKED_LIST[ PROCEDURE[ ANY, TUPLE[ Q_HUD_COMPONENT, Q_HUD_COMPONENT ]]]
		-- parent, child
	
	key_up_listener   : LINKED_LIST[ FUNCTION[ ANY, TUPLE[ESDL_KEYBOARD_EVENT, Q_KEY_MAP, BOOLEAN], BOOLEAN]]
		-- event, map, consumed
		
	key_down_listener : LINKED_LIST[ FUNCTION[ ANY, TUPLE[ESDL_KEYBOARD_EVENT, Q_KEY_MAP, BOOLEAN], BOOLEAN]]
		-- event, map, consumed
		
feature{Q_HUD_ROOT_PANE, Q_HUD_COMPONENT} -- eventhandling
	process_key_down( event_ : ESDL_KEYBOARD_EVENT; map_ : Q_KEY_MAP ) : BOOLEAN is
			-- invoked when a keyevent happens, and this component has the focus and is enabled
			-- returns true if the event is consumed, false if the parent should be invoked with the event
		local
			consumed_ : BOOLEAN
		do
			from key_down_listener.start until key_down_listener.after loop
				consumed_ := key_down_listener.item.item( [ event_, map_, result ])
				result := result or consumed_
				key_down_listener.forth
			end
		end

	process_key_up( event_ : ESDL_KEYBOARD_EVENT; map_ : Q_KEY_MAP ) : BOOLEAN is
			-- invoked when a keyevent happens, and this component has the focus and is enabled
			-- returns true if the event is consumed, false if the parent should be invoked with the event
		local
			consumed_ : BOOLEAN
		do
			from key_up_listener.start until key_up_listener.after loop
				consumed_ := key_up_listener.item.item( [ event_, map_, result ])
				result := result or consumed_
				key_up_listener.forth
			end
		end
		
	process_mouse_enter( x_, y_ : DOUBLE; map_ : Q_KEY_MAP ) is
			-- invoked when the Mouse enters this component
		do
			from mouse_enter_listener.start until mouse_enter_listener.after loop
				mouse_enter_listener.item.call([x_, y_, map_])
				mouse_enter_listener.forth
			end			
		end
		
	process_mouse_exit( x_, y_ : DOUBLE; map_ : Q_KEY_MAP ) is
			-- invoked when the Mouse exites this component.
			-- this method will perhaps not be called, if the enabled-state is set to false,
			-- or the component is removed from its parent
		do
			from mouse_exit_listener.start until mouse_exit_listener.after loop
				mouse_exit_listener.item.call([x_, y_, map_])
				mouse_exit_listener.forth
			end				
		end
		
		
	process_mouse_button_down( event_ : ESDL_MOUSEBUTTON_EVENT; x_, y_ : DOUBLE; map_ : Q_KEY_MAP ) : BOOLEAN is
			-- invoked when a Mousebutton is pressed, and the Mouse is over this Component
			-- returns true if the event is consumed, false if the parent should be invoked with the event			
		local
			consumed_ : BOOLEAN
		do
			from mouse_button_down_listener.start until mouse_button_down_listener.after loop
				consumed_ := mouse_button_down_listener.item.item( [ event_, x_, y_, map_, result ])
				result := result or consumed_
				mouse_button_down_listener.forth
			end
		end
		
	process_mouse_button_up( event_ : ESDL_MOUSEBUTTON_EVENT; x_, y_ : DOUBLE; map_ : Q_KEY_MAP ) : BOOLEAN is
			-- invoked when a Mousebutton is released, witch was earlier pressed over this Component
			-- returns true if the event is consumed, false if the parent should be invoked with the event
		local
			consumed_ : BOOLEAN
		do
			from mouse_button_up_listener.start until mouse_button_up_listener.after loop
				consumed_ := mouse_button_up_listener.item.item( [ event_, x_, y_, map_, result ])
				result := result or consumed_
				mouse_button_up_listener.forth
			end
		end
		
	process_mouse_moved( event_ : ESDL_MOUSEMOTION_EVENT; x_, y_ : DOUBLE; map_ : Q_KEY_MAP ) : BOOLEAN is
			-- invoked the mouse is moved over this component, but not if a mousebutton was pressed over another component
			-- returns true if the event is consumed, false if the parent should be invoked with the event
		local
			consumed_ : BOOLEAN
		do
			from mouse_moved_listener.start until mouse_moved_listener.after loop
				consumed_ := mouse_moved_listener.item.item( [ event_, x_, y_, map_, result ])
				result := result or consumed_
				mouse_moved_listener.forth
			end
		end
			
	process_component_added( parent_ : Q_HUD_CONTAINER; child_ : Q_HUD_COMPONENT ) is
			-- invoked, when this component or one of its parents, is added
		do
			from component_added_listener.start until component_added_listener.after loop
				component_added_listener.item.call( [parent_, child_] )
				component_added_listener.forth
			end
		end
	
	process_component_removed( parent_ : Q_HUD_CONTAINER; child_ : Q_HUD_COMPONENT ) is
			-- invoked, when this component or one of its parents, is removed
		do
			from component_removed_listener.start until component_removed_listener.after loop
				component_removed_listener.item.call( [parent_, child_] )
				component_removed_listener.forth
			end			
		end
			
feature -- Componenttree
	parent : Q_HUD_CONTAINER
		-- the owner of this Component
		
	root_pane : Q_HUD_ROOT_PANE is
		-- gets the root-pane for this component
		do
			if parent /= void then
				result := parent.root_pane
			else
				result := void
			end
		end
		
		
	is_toplevel : BOOLEAN is
		-- a toplevel-Component cannot be added to a standard-container
		do
			result := false
		end
		
		
feature{Q_HUD_CONTAINER} -- Only available for the parent
	set_parent( parent_ : Q_HUD_CONTAINER ) is
		do
			parent := parent_
		end
		
feature -- Color
	background, foreground : Q_GL_COLOR
	
	set_background( background_ : Q_GL_COLOR ) is
			-- sets the background-color. A value of void means, that no
			-- background will be drawn
		do
			background := background_
		end
	
	blend_background : BOOLEAN
		-- if true, the alpha-value of the backgroundcolor will be used to create semitransparent backgrounds
		
	set_blend_background( blend_ : BOOLEAN ) is
		do
			blend_background := blend_
		end
		
	
	set_foreground( foreground_ : Q_GL_COLOR ) is
		do
			foreground := foreground_
		end
		
feature -- 3D
	inside( x_, y_ : DOUBLE ) : BOOLEAN is
			-- true, if the point is in the rectangle in witch
			-- this component is painted.
		do
			result := x_ >= 0 and y_ >= 0 and x_ <= width and y_ <= height
		end
		
feature -- position and size
	x : DOUBLE
	y : DOUBLE
	width : DOUBLE
	height : DOUBLE
	
	set_x( x_ : DOUBLE ) is
		do
			x := x_
		end
		
	set_y( y_ : DOUBLE ) is
		do
			y := y_
		end
		
	set_width( width_ : DOUBLE ) is
		do
			width := width_
		end
		
	set_height( height_ : DOUBLE ) is
		do
			height := height_
		end

	set_location( x_, y_ : DOUBLE ) is
		do
			set_x( x_ )
			set_y( y_ )
		end
	
	set_size( width_, height_ : DOUBLE ) is
		do
			set_width( width_ )
			set_height( height_ )
		end
		
	set_bounds( x_, y_, width_, height_ : DOUBLE ) is
		do
			set_location( x_, y_ )
			set_size( width_, height_ )
		end
		

end -- class Q_HUD_COMPONENT
