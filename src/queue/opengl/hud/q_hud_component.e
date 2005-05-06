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
		end
		

feature -- eventhandling
	enabled : BOOLEAN
		-- tells, if this Component will react on Events. A Component with enabled=false will not recieve any events
	
	focusable : BOOLEAN
		-- tells, if this Component can hold the focus. Only focusable Components will recieve Key-Events
		
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
		
		
feature{Q_HUD_ROOT_PANE, Q_HUD_COMPONENT} -- eventhandling
	process_key_down( event_ : ESDL_KEYBOARD_EVENT ) : BOOLEAN is
			-- invoked when a keyevent happens, and this component has the focus and is enabled
			-- returns true if the event is consumed, false if the parent should be invoked with the event
		do
			result := true
		end

	process_key_up( event_ : ESDL_KEYBOARD_EVENT ) : BOOLEAN is
			-- invoked when a keyevent happens, and this component has the focus and is enabled
			-- returns true if the event is consumed, false if the parent should be invoked with the event
		do
			result := true
		end
		
	process_mouse_button_down( event_ : ESDL_MOUSEBUTTON_EVENT; x_, y_ : DOUBLE ) : BOOLEAN is
			-- invoked when a Mousebutton is pressed, and the Mouse is over this Component
			-- returns true if the event is consumed, false if the parent should be invoked with the event			
		do
			result := true
		end
		
	process_mouse_button_up( event_ : ESDL_MOUSEBUTTON_EVENT; x_, y_ : DOUBLE ) : BOOLEAN is
			-- invoked when a Mousebutton is released, witch was earlier pressed over this Component
			-- returns true if the event is consumed, false if the parent should be invoked with the event
		do
			result := true
		end
		
	process_mouse_moved( event_ : ESDL_MOUSEMOTION_EVENT; x_, y_ : DOUBLE ) : BOOLEAN is
			-- invoked the mouse is moved over this component, but not if a mousebutton was pressed over another component
			-- returns true if the event is consumed, false if the parent should be invoked with the event
		do
			result := true
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
		
feature -- position and size
	x : DOUBLE
	y : DOUBLE
	width : DOUBLE
	height : DOUBLE
	
	inside( x_, y_ : DOUBLE ) : BOOLEAN is
			-- true, if the point is inside this component, false otherwise
		do
			result := x_ >= x and y_ >= y and x_ <= x + width and y_ <= y + height
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
