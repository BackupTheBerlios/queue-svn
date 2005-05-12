indexing
	--description: "[A HUD-Component is painted at the top of
	--	an OpenGL-Drawable. Always the z-Coordinates are 0 (the
	--	glVertex2d-Methods can directly be used), the 0/0 coordinates
	--	markes the top left of the window, the 1/1 coordinates
	--	the bottom right.]"
	author: "Benjamin Sigg"

deferred class
	Q_HUD_COMPONENT

	inherit 
		Q_GL_OBJECT
		redefine
			default_create
		end

feature -- creation
	default_create is
		do
			precursor()
			set_enabled( true )
			set_lightweight( true )
			set_focusable( false )
			
			set_background( create {Q_GL_COLOR}.make_gray )
			set_foreground( create {Q_GL_COLOR}.make_black )
		end

feature -- drawing
	draw( open_gl : Q_GL_DRAWABLE ) is
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

				open_gl.gl.gl_begin( open_gl.gl_constants.esdl_gl_quads )
				open_gl.gl.gl_vertex2d( 0, 0 )
				open_gl.gl.gl_vertex2d( width, 0 )
				open_gl.gl.gl_vertex2d( width, height )
				open_gl.gl.gl_vertex2d( 0, height )
				open_gl.gl.gl_end		
			end
		end		

feature -- eventhandling
	enabled : BOOLEAN
		-- tells, if this Component will react on Events. A Component with enabled=false will not recieve any events
	
	focusable : BOOLEAN
		-- tells, if this Component can hold the focus. Only focusable Components will recieve Key-Events
		
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
		
		
feature{Q_HUD_ROOT_PANE, Q_HUD_COMPONENT} -- eventhandling
	process_key_down( event_ : ESDL_KEYBOARD_EVENT ) : BOOLEAN is
			-- invoked when a keyevent happens, and this component has the focus and is enabled
			-- returns true if the event is consumed, false if the parent should be invoked with the event
		do
			result := false
		end

	process_key_up( event_ : ESDL_KEYBOARD_EVENT ) : BOOLEAN is
			-- invoked when a keyevent happens, and this component has the focus and is enabled
			-- returns true if the event is consumed, false if the parent should be invoked with the event
		do
			result := false
		end
		
	process_mouse_enter( x_, y_ : DOUBLE ) is
			-- invoked when the Mouse enters this component
		do
		end
		
	process_mouse_exit( x_, y_ : DOUBLE ) is
			-- invoked when the Mouse exites this component.
			-- this method will perhaps not be called, if the enabled-state is set to false,
			-- or the component is removed from its parent
		do	
		end
		
		
	process_mouse_button_down( event_ : ESDL_MOUSEBUTTON_EVENT; x_, y_ : DOUBLE ) : BOOLEAN is
			-- invoked when a Mousebutton is pressed, and the Mouse is over this Component
			-- returns true if the event is consumed, false if the parent should be invoked with the event			
		do
			result := false
		end
		
	process_mouse_button_up( event_ : ESDL_MOUSEBUTTON_EVENT; x_, y_ : DOUBLE ) : BOOLEAN is
			-- invoked when a Mousebutton is released, witch was earlier pressed over this Component
			-- returns true if the event is consumed, false if the parent should be invoked with the event
		do
			result := false
		end
		
	process_mouse_moved( event_ : ESDL_MOUSEMOTION_EVENT; x_, y_ : DOUBLE ) : BOOLEAN is
			-- invoked the mouse is moved over this component, but not if a mousebutton was pressed over another component
			-- returns true if the event is consumed, false if the parent should be invoked with the event
		do
			result := false
		end
			
	process_component_added( parent_ : Q_HUD_CONTAINER ) is
			-- invoked, when this component is set to a new parentcontainer
		do
		end
	
	process_component_removed( parent_ : Q_HUD_CONTAINER ) is
			-- invoked, when this component is removed from a parentcontainer
		do
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
			result := true
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
	
	set_foreground( foreground_ : Q_GL_COLOR ) is
		do
			foreground := foreground_
		end
		
		
feature -- position and size
	x : DOUBLE
	y : DOUBLE
	width : DOUBLE
	height : DOUBLE
	
	inside( x_, y_ : DOUBLE ) : BOOLEAN is
			-- true, if the point is inside this component, false otherwise
		do
			result := x_ >= 0 and y_ >= 0 and x_ <= width and y_ <= height
		end
		
	
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
