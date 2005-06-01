indexing
	description: "The top-level container for all huds. This container cannot be added to another container"
	author: "Benjamin Sigg"

class
	Q_HUD_ROOT_PANE

inherit
	Q_HUD_CONTAINER
	rename
		process_key_down as component_key_down,
		process_key_up as component_key_up,
		process_mouse_button_down as component_mouse_button_down,
		process_mouse_button_up as component_mouse_button_up,
		process_mouse_moved as component_mouse_moved
	redefine
		is_toplevel, root_pane, make
	end

creation
	make

feature{NONE} -- creation
	make is
		do
			precursor
			set_focus_handler( create {Q_FOCUS_DEFAULT_HANDLER} )
			reset_queue
		end
		
	
feature -- root and top
	is_toplevel : BOOLEAN is true

	root_pane : Q_HUD_ROOT_PANE is
		do
			result := current
		end
		
	root : Q_GL_ROOT
	
feature{Q_GL_ROOT} 
	set_root( root_ : Q_GL_ROOT ) is
		do
			root := root_
		end
		
		
feature -- Eventhandling
	focused_component : Q_HUD_COMPONENT
		-- the component witch has currently the focus
		
	selected_component : Q_HUD_COMPONENT
		-- the component witch is selected by the mouse. If it is a focusable component, its the same as focused_component
	
	components_under_mouse : ARRAYED_LIST[ Q_HUD_COMPONENT ]
		-- all components witch were under the mouse, when it was pressed
	
	mouse_button_pressed : BOOLEAN
		-- mouse buttons witch are currently pressed
	
	unused_events : Q_EVENT_QUEUE
	
	request_focused_component( component_ : Q_HUD_COMPONENT ) is
			-- Tries to set the given component as the component with the focus.
			-- This action may be abordet, if currently the mouse is pressed
		require
			component_ /= void
		do
			if focused_component = void or not mouse_button_pressed then
				focused_component := component_
			end
		end
		
	
	process( events_ : Q_EVENT_QUEUE ) is
		-- process all events in the queue.
		-- This will reset the "unused_events"-Queue!
		require
			events_ /= void
		do
			from
				create unused_events.make_empty( events_.surface )
			until
				events_.is_empty
			loop
				events_.move_forward_and_append_until( events_.input_event, unused_events )
				if not events_.is_empty then
					process_head( events_ )
				end
			end
		end
		
	
	process_head( events_ : Q_EVENT_QUEUE ) is
		-- Processes the first event in the queue. This Event must be an input-event (Mouse or Key)
		-- The event will be be poped, even if it is not processed
		require
			events_not_void : events_ /= void
			events_not_empty : not events_.is_empty
			event_is_handable : events_.is_top( events_.input_event )
		local
			any_ : ANY
			consumed_ : BOOLEAN
		do
			if unused_events = void then
				create unused_events.make_empty( events_.surface )
			end
			
			consumed_ := false
			if events_.is_key_down_event then
				consumed_ := process_key_down( events_.peek_keyboard_event )
			elseif events_.is_key_up_event then
				consumed_ := process_key_up( events_.peek_keyboard_event )
			elseif events_.is_mouse_button_down_event then
				consumed_ := process_mouse_button_down( 
					events_.peek_mouse_button_event, 
					events_.surface.video_surface_width,
					events_.surface.video_surface_height )
			elseif events_.is_mouse_button_up_event then
				consumed_ := process_mouse_button_up( 
					events_.peek_mouse_button_event, 
					events_.surface.video_surface_width,
					events_.surface.video_surface_height )				
			elseif events_.is_mouse_motion_event then
				consumed_ := process_mouse_motion(
					events_.peek_mouse_motion_event, 
					events_.surface.video_surface_width,
					events_.surface.video_surface_height )								
			else
				any_ := events_.peek_event
			end
			
			if not consumed_ then
				events_.throw_away( unused_events )
			else
				any_ := events_.pop_event
			end
		end
		
	process_key_down( event_ : ESDL_KEYBOARD_EVENT ) : BOOLEAN is
		local
			component_ : Q_HUD_COMPONENT
			stop_ : BOOLEAN
		do
			from
				ensure_focused_component
				stop_ := false
				component_ := focused_component
			until
				stop_ or component_ = void
			loop
				if component_.enabled then
					stop_ := component_.process_key_down ( event_ ) or not component_.lightweight
				else
					stop_ := not component_.lightweight
				end
				component_ := component_.parent
			end
			
			if not stop_ and component_ = void then
				-- perhaps the root-focus manager is interested in this event
				stop_ := component_key_down( event_ )
			end
			
			result := stop_
		end
		
	process_key_up( event_ : ESDL_KEYBOARD_EVENT ) : BOOLEAN is
		local
			component_ : Q_HUD_COMPONENT
			stop_ : BOOLEAN
		do
			from
				ensure_focused_component
				stop_ := false
				component_ := focused_component
			until
				stop_ or component_ = void
			loop
				if component_.enabled then
					stop_ := component_.process_key_up ( event_ ) or not component_.lightweight
				else
					stop_ := not component_.lightweight
				end
				component_ := component_.parent
			end
			
			result := stop_
		end

	process_mouse_button_down( event_ : ESDL_MOUSEBUTTON_EVENT; screen_width_, screen_height_ : INTEGER ) : BOOLEAN is
		local
			x_, y_ : DOUBLE
			component_ : Q_HUD_COMPONENT
			mouse_ : Q_VECTOR_2D
		do			
			x_ := event_.proportional_position.x / screen_width_
			y_ := event_.proportional_position.y / screen_height_
	
			-- perhaps another component must be selected
			if not mouse_button_pressed then
				component_select_and_focus( x_, y_ )
				create_components_under_mouse_stack( x_, y_, selected_component )
				mouse_button_pressed := true
			end
		
			-- ensure, the selected component is still enabled
			ensure_selected_component
			result := false
		
			if selected_component /= void then
				from
					components_under_mouse.start
				until
					result or components_under_mouse.after
				loop
					component_ := components_under_mouse.item
				
					if component_.enabled then
						mouse_ := absolut_location( x_, y_, component_ )
						result := component_.process_mouse_button_down( event_, mouse_.x, mouse_.y )
						if not result and not component_.lightweight then
							result := true
						end	
					end
				
					components_under_mouse.forth
				end			
			end
		end

	process_mouse_button_up( event_ : ESDL_MOUSEBUTTON_EVENT; screen_width_, screen_height_ : INTEGER ) : BOOLEAN is
		local
			component_ : Q_HUD_COMPONENT
			mouse_ : Q_VECTOR_2D
			
			x_, y_ : DOUBLE
		do
			-- ensure, the selected component is still enabled
			ensure_selected_component			
			mouse_button_pressed := false
			result := false

			if selected_component /= void then
				x_ := event_.proportional_position.x / screen_width_
				y_ := event_.proportional_position.y / screen_height_
				
				from
					components_under_mouse.start
				until
					result or components_under_mouse.after
				loop
					component_ := components_under_mouse.item
					
					if component_.enabled then
						mouse_ := absolut_location( x_, y_, component_ )
						result := component_.process_mouse_button_up( event_, mouse_.x, mouse_.y )
						if not result and not component_.lightweight then
							result := true
						end
					end
					
					components_under_mouse.forth
				end
				
				--components_under_mouse := void
			end
			component_select( x_, y_ )
		end
		
	process_mouse_motion( event_ : ESDL_MOUSEMOTION_EVENT; screen_width_, screen_height_ : INTEGER ) : BOOLEAN is
		local
			mouse_ : Q_VECTOR_2D
			component_ : Q_HUD_COMPONENT
			x_, y_ : DOUBLE
			
			found_ : Q_HUD_QUEUE_SEARCH_RESULT
		do
			x_ := event_.proportional_position.x / screen_width_
			y_ := event_.proportional_position.y / screen_height_
			
			if mouse_button_pressed then
				from
					components_under_mouse.start
				until
					result or components_under_mouse.after
				loop
					component_ := components_under_mouse.item
					
					if component_.enabled then
						mouse_ := absolut_location( x_, y_, component_ )
						result := component_.process_mouse_moved( event_, mouse_.x, mouse_.y )
						if not result and not component_.lightweight then
							result := true
						end
					end
					
					components_under_mouse.forth
				end
			else
				component_select( x_, y_ )
				
				if selected_component /= void then
					from
						found_ := search_component_at( x_, y_, true, false, 
							true, queue.index_of_component( selected_component ), false )
					until
						result or found_ = void
					loop
						component_ := found_.component
						result := component_.process_mouse_moved( event_, found_.position.x, found_.position.y )
						if not result and not component_.lightweight then
							result := true
						else
							found_ := search_component_at( x_, y_, true, false,
								true, found_.index, true )
						end
					end
				end
			end
		end			
	
removed( component_ : Q_HUD_COMPONENT ) is
	-- called from the container, if a component is removed

	local
		child_ : Q_HUD_COMPONENT
	do
		from child_ := component_ until child_ = void loop
			if child_ = selected_component then
				selected_component := void
			end
			
			if child_ = focused_component then
				focused_component := void
			end
			
			child_ := child_.parent
		end
		
		if selected_component /= void then
			from child_ := selected_component until child_ = void loop
				if child_ = component_ then
					selected_component := void
				end
				child_ := child_.parent
			end
		end
		
		if focused_component /= void then
			from child_ := focused_component until child_ = void loop
				if child_ = component_ then
					selected_component := void
				end
				child_ := child_.parent
			end
		end
	end
	

feature -- Drawing
	queue : Q_HUD_QUEUE

	reset_queue is
			-- Recreates the queue of all components
		do
			create queue.make( current )
		end
	

feature{NONE} -- assistants

	search_component_at( x_, y_ : DOUBLE; enabled_, focusable_, lightweight_ : BOOLEAN; index__ : INTEGER; jump_ : BOOLEAN ) : Q_HUD_QUEUE_SEARCH_RESULT is
		-- Searches the first component under the position x/y on the screen.
		-- If enabled_ and/or focusable_ is set to true, the component must be
		-- enabled and/or focusable. Otherwise this value is ignored.
		-- If lightweight_ ist set to true, the search will stop if a non-lightweight component
		-- is found (and has not the given abbilities).
		-- index__ is the component befor the first component in the queue,
		-- witch should be tested (= the last found component)
	local
		found_ : Q_HUD_QUEUE_SEARCH_RESULT
		index_ : INTEGER
		component_ : Q_HUD_COMPONENT
		
		mouse_ : Q_LINE_3D
	do
		create mouse_.make_vectorized( root.position_in_space( x_, y_ ), root.direction_in_space( x_, y_ ))
		
		from
			index_ := index__
			found_ := queue.next_component_on( mouse_, index_, jump_ )
		until
			result /= void or found_ = void
		loop
			index_ := found_.index
			component_ := found_.component
			
			if (enabled_ implies component_.enabled) and
			   (focusable_ implies component_.focusable) then
				result := found_
			elseif lightweight_ and not component_.lightweight then
				found_ := void
			else
				found_ := queue.next_component_on( mouse_, index_, true )
			end
		end
	end
	
create_components_under_mouse_stack( x_, y_ : DOUBLE; component_ : Q_HUD_COMPONENT ) is
		-- creates the stack with all components who are under the mouseposition x/y
		-- and behind component
	local
		found_ : Q_HUD_QUEUE_SEARCH_RESULT
		line_ : Q_LINE_3D
		index_ : INTEGER
	do
		create components_under_mouse.make( 10 )
		create line_.make_vectorized( root.position_in_space( x_, y_ ), root.direction_in_space( x_, y_ ))
		
		from
			index_ := queue.index_of_component( component_ )
			found_ := queue.next_component_on( line_, index_, true )
			components_under_mouse.extend( component_ )
		until
			found_ = void
		loop
			components_under_mouse.extend( found_.component )
			found_ := queue.next_component_on( line_, found_.index, true )
		end
	end
	

absolut_location( x_, y_ : DOUBLE; component_ : Q_HUD_COMPONENT ) : Q_VECTOR_2D is
	do
		result := queue.cut( 
			create {Q_LINE_3D}.make_vectorized( root.position_in_space ( x_, y_ ),
				root.direction_in_space( x_, y_ )), component_ )
	end
	

component_select( x_, y_ : DOUBLE ) is
	local
		found_ : Q_HUD_QUEUE_SEARCH_RESULT
		old_selected_component_ : Q_HUD_COMPONENT
		location_ : Q_VECTOR_2D
	do			
		old_selected_component_ := selected_component
		found_ := search_component_at( x_, y_, true, false, true, 0, false )
		
		if found_ = void then
			selected_component := void
		else
			selected_component := found_.component
		end
		
		if old_selected_component_ /= selected_component then
			if old_selected_component_ /= void then
				location_ := absolut_location( x_, y_, old_selected_component_ )
				if location_ /= void then
					old_selected_component_.process_mouse_exit( location_.x, location_.y )					
				end
			end
			
			if selected_component /= void then
				location_ := found_.position
				selected_component.process_mouse_enter( location_.x, location_.y )
			end
		end
	end

component_select_and_focus( x_, y_ : DOUBLE ) is
	local
		index_ : INTEGER
		found_ : Q_HUD_QUEUE_SEARCH_RESULT
	do
		component_select( x_, y_ )
	
		if selected_component = void then
			focused_component := void
		else
			index_ := queue.index_of_component( selected_component )
			found_ := search_component_at( x_, y_, true, true, true, index_, false )
			
			if found_ /= void then
				focused_component := found_.component
			else
				focused_component := void
			end
		end
	end
	

ensure_focused_component is
	do
		if focused_component /= void then
			if focused_component.root_pane /= current or
					not focused_component.focusable	then
				focused_component := void
			end
		end
	end
	
ensure_selected_component is
	do
		if selected_component /= void then
			if selected_component.root_pane /= current or
					not selected_component.enabled	then
				selected_component := void
			end
		end
	end
	

end -- class Q_HUD_ROOT_PANE
