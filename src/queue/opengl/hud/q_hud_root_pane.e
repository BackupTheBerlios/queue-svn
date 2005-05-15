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
		end
		
	
feature
	is_toplevel : BOOLEAN is true

	root_pane : Q_HUD_ROOT_PANE is
		do
			result := current
		end
		
feature -- Eventhandling
	focused_component : Q_HUD_COMPONENT
		-- the component witch has currently the focus
		
	selected_component : Q_HUD_COMPONENT
		-- the component witch is selected by the mouse. If it is a focusable component, its the same as focused_component
		
	mouse_button_pressed : BOOLEAN
		-- mouse buttons witch are currently pressed
	
	mouse_direction( x_, y_ : DOUBLE ) : Q_VECTOR_3D is
			-- Gives the direction in witch the mouse points at the location x_/y_
		do
			create result.make( 0, 0, -1 )
		end
		
	
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
		require
			events_ /= void
		do
			from
				
			until
				events_.is_empty
			loop
				events_.move_forward_until( events_.input_event )
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
			eiffel_shit_ : ANY
		do
			if events_.is_key_down_event then
				process_key_down( events_.pop_keyboard_event )
			elseif events_.is_key_up_event then
				process_key_up( events_.pop_keyboard_event )
			elseif events_.is_mouse_button_down_event then
				process_mouse_button_down( 
					events_.pop_mouse_button_event, 
					events_.surface.video_surface_width,
					events_.surface.video_surface_height )
			elseif events_.is_mouse_button_up_event then
				process_mouse_button_up( 
					events_.pop_mouse_button_event, 
					events_.surface.video_surface_width,
					events_.surface.video_surface_height )				
			elseif events_.is_mouse_motion_event then
				process_mouse_motion(
					events_.pop_mouse_motion_event, 
					events_.surface.video_surface_width,
					events_.surface.video_surface_height )								
			else
				eiffel_shit_ := events_.pop_event
			end
		end
		
	process_key_down( event_ : ESDL_KEYBOARD_EVENT ) is
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
		end
		
	process_key_up( event_ : ESDL_KEYBOARD_EVENT ) is
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
		end

	process_mouse_button_down( event_ : ESDL_MOUSEBUTTON_EVENT; screen_width_, screen_height_ : INTEGER ) is
		local
			component_ : Q_HUD_COMPONENT
			
			mouse_positions_ : STACK[ Q_VECTOR_2D ]
			mouse_ : Q_VECTOR_2D
			
			x_, y_ : DOUBLE
		do
			-- relative position of the mouse
			x_ := event_.proportional_position.x / screen_width_
			y_ := event_.proportional_position.y / screen_height_
			
			-- if no button was pressed: find component, and set the focus		
			if not mouse_button_pressed then
				component_select_and_focus( x_, y_ )
			end

			-- ensure selected component is enabled and child of this container
			ensure_selected_component

			-- send the event			
			if selected_component /= void then
				mouse_positions_ := mouse_positions(
					x_, y_,	selected_component )				
				
				mouse_button_pressed := true
				
				from
					component_ := selected_component				
				until
					component_ = void
				loop
					mouse_ := mouse_positions_.item
					mouse_positions_.remove
					
					if component_.enabled then
						if component_.process_mouse_button_down ( event_, mouse_.x, mouse_.y ) 
								or not component_.lightweight then
									
							component_ := void
						else
							component_ := component_.parent
						end
					else
						if component_.lightweight then
							component_ := component_.parent
						else
							component_ := void
						end
					end
				end
			else
				mouse_button_pressed := false
			end
		end
		
		
	process_mouse_button_up( event_ : ESDL_MOUSEBUTTON_EVENT; screen_width_, screen_height_ : INTEGER ) is
		local
			component_ : Q_HUD_COMPONENT
			mouse_ : Q_VECTOR_2D
			mouse_positions_ : STACK[ Q_VECTOR_2D ]
		do
			-- ensure, the selected component is still enabled
			ensure_selected_component			
			mouse_button_pressed := false

			if selected_component /= void then
				mouse_positions_ := mouse_positions ( 
					event_.proportional_position.x / screen_width_,
					event_.proportional_position.y / screen_height_,
					selected_component )
				
				from
					component_ := selected_component
				until
					component_ = void
				loop
					mouse_ := mouse_positions_.item
					mouse_positions_.remove
					
					if component_.enabled then
						if component_.process_mouse_button_up ( event_, mouse_.x, mouse_.y ) or not component_.lightweight then
							component_ := void
						else
							component_ := component_.parent
						end
					else
						if component_.lightweight then
							component_ := component_.parent							
						else
							component_ := void
						end
					end
				end
			end
		end
		
	process_mouse_motion( event_ : ESDL_MOUSEMOTION_EVENT; screen_width_, screen_height_ : INTEGER ) is
		local
			component_ : Q_HUD_COMPONENT
			x_, y_ : DOUBLE
			
			mouse_ : Q_VECTOR_2D
			mouse_positions_ : STACK[ Q_VECTOR_2D ]
		do
			x_ := event_.proportional_position.x / screen_width_
			y_ := event_.proportional_position.y / screen_height_
			
			-- perhaps another component must be selected
			if not mouse_button_pressed then
				component_select( x_, y_ )
			end
			
			-- ensure, the selected component is still enabled
			ensure_selected_component
			
			if selected_component /= void then	
				mouse_positions_ := mouse_positions( x_, y_, selected_component ) 

				from
					component_ := selected_component
				until
					component_ = void
				loop
					mouse_ := mouse_positions_.item
					mouse_positions_.remove
					
					if component_.enabled then
						if component_.process_mouse_moved( event_, mouse_.x, mouse_.y ) or not component_.lightweight then
							component_ := void
						else
							component_ := component_.parent
						end
					else
						if component_.lightweight then
							component_ := component_.parent							
						else
							component_ := void
						end
					end
				end	
			end
		end			
	
	mouse_positions( x_, y_ : DOUBLE; component__ : Q_HUD_COMPONENT ) : STACK[ Q_VECTOR_2D ] is
			-- Calculates the position of the mouse for all components.
			-- the top-component will be "component_", and the base will be "current"
		local
			components_ : STACK[ Q_HUD_COMPONENT ]
			component_ : Q_HUD_COMPONENT

			vector_ : Q_VECTOR_2D
			direction_ : Q_VECTOR_3D
		do
			components_ := create {ARRAYED_STACK[ Q_HUD_COMPONENT ]}.make( 5 )
			
			from
				component_ := component__
			until
				component_ = current
			loop
				components_.put( component_ )
				component_ := component_.parent
			end
			
			result := create {ARRAYED_STACK[ Q_VECTOR_2D ]}.make( components_.count+1 )
			result.put( create {Q_VECTOR_2D}.make( x_, y_ ) )
			
			from
				direction_ := mouse_direction( x_, y_ )
			until
				components_.is_empty
			loop
				component_ := components_.item
				components_.remove
				vector_ := result.item
				
				result.put( component_.convert_point( vector_.x, vector_.y, direction_ ) )
				direction_ := component_.convert_direction( direction_ )
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
		
	
feature{NONE} -- assistants
	absolut_location( x_, y_ : DOUBLE; child__ : Q_HUD_COMPONENT ) : Q_VECTOR_2D is
		local
			stack_ : STACK[ Q_HUD_COMPONENT ]
			child_ : Q_HUD_COMPONENT
			
			direction_ : Q_VECTOR_3D
			location_ : Q_VECTOR_2D
		do
			child_ := child__
			
			stack_ := create {ARRAYED_STACK[ Q_HUD_COMPONENT ]}.make( 10 )
			
			from
				
			until
				child_ = current
			loop
				stack_.put( child_ )
				child_ := child_.parent
			end
			
			-- now the path from this location to the child is saved
			
			from
				create location_.make( x_, y_ )
				direction_ := mouse_direction( x_, y_ )
			until
				stack_.is_empty
			loop
				location_ := stack_.item.convert_point( location_.x, location_.y, direction_ )
				direction_ := stack_.item.convert_direction( direction_ )
				
				stack_.remove
			end
			
			result := location_
		end
		

	component_select( x_, y_ : DOUBLE ) is
		local
			old_selected_component_ : Q_HUD_COMPONENT
			location_ : Q_VECTOR_2D
		do
			from
				old_selected_component_ := selected_component
				selected_component := tree_child_at( x_, y_, mouse_direction( x_, y_ ))	
			until
				selected_component = void or else selected_component.enabled
			loop
				selected_component := selected_component.parent
					
				if selected_component /= void and then 
						(not selected_component.enabled and 
						 not selected_component.lightweight ) then
						 	
					selected_component := void
				end
			end
			
			if old_selected_component_ /= selected_component then
				if old_selected_component_ /= void then
					location_ := absolut_location( x_, y_, old_selected_component_ )
					old_selected_component_.process_mouse_exit( location_.x, location_.y )
				end
				
				if selected_component /= void then
					location_ := absolut_location(x_, y_, selected_component )
					selected_component.process_mouse_enter( location_.x, location_.y )
				end
			end
		end
		

	component_select_and_focus( x_, y_ : DOUBLE ) is
		do
			component_select( x_, y_ )
			
			if selected_component = void then
				focused_component := void
			else
				from
					focused_component := selected_component
				until
					focused_component = void or else focused_component.focusable
				loop
					focused_component := focused_component.parent
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
