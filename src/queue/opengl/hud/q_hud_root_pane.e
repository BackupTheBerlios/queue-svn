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
			x_, y_ : DOUBLE
			cx_, cy_ : DOUBLE
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
				mouse_button_pressed := true
				
				from
					component_ := selected_component
				
					cx_ := absolut_x_location( component_ )
					cy_ := absolut_y_location( component_ )					
				until
					component_ = void
				loop
					if component_.enabled then
						if component_.process_mouse_button_down ( event_, x_ - cx_, y_ - cy_ ) 
								or not component_.lightweight then
									
							component_ := void
						else
							cx_ := cx_ - component_.x
							cy_ := cy_ - component_.y
							component_ := component_.parent
						end
					else
						if component_.lightweight then
							cx_ := cx_ - component_.x
							cy_ := cy_ - component_.y
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
			x_, y_, cx_, cy_ : DOUBLE
		do
			-- ensure, the selected component is still enabled
			ensure_selected_component			
			mouse_button_pressed := false

			if selected_component /= void then
				x_ := event_.proportional_position.x / screen_width_
				y_ := event_.proportional_position.y / screen_height_
				
				cx_ := absolut_x_location( selected_component )
				cy_ := absolut_y_location( selected_component )				
				
				from
					component_ := selected_component
				until
					component_ = void
				loop
					if component_.enabled then
						if component_.process_mouse_button_up ( event_, x_ - cx_, y_ - cy_ ) or not component_.lightweight then
							component_ := void
						else
							cx_ := cx_ - component_.x
							cy_ := cy_ - component_.y
							component_ := component_.parent
						end
					else
						if component_.lightweight then
							cx_ := cx_ - component_.x
							cy_ := cy_ - component_.y
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
			x_, y_, cx_, cy_ : DOUBLE
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
				cx_ := absolut_x_location( component_ )
				cy_ := absolut_x_location( component_ )	
				
				from
					component_ := selected_component
				until
					component_ = void
				loop
					if component_.enabled then
						if component_.process_mouse_moved( event_, x_, y_ ) or not component_.lightweight then
							component_ := void
						else
							cx_ := cx_ - component_.x
							cy_ := cy_ - component_.y
							component_ := component_.parent
						end
					else
						if component_.lightweight then
							cx_ := cx_ - component_.x
							cy_ := cy_ - component_.y
							component_ := component_.parent							
						else
							component_ := void
						end
					end
				end	
			end
		end
		
		
feature{NONE} -- assistants
	absolut_x_location( child_ : Q_HUD_COMPONENT ) : DOUBLE is
		local
			parent_ : Q_HUD_COMPONENT
		do
			from
				parent_ := child_
				result := 0
			until
				parent_ = void
			loop
				result := result + parent_.x
				parent_ := parent_.parent
			end
		end
		
	absolut_y_location( child_ : Q_HUD_COMPONENT ) : DOUBLE is
		local
			parent_ : Q_HUD_COMPONENT
		do
			from
				parent_ := child_
				result := 0
			until
				parent_ = void
			loop
				result := result + parent_.y
				parent_ := parent_.parent
			end
		end

	component_select( x_, y_ : DOUBLE ) is
		local
			old_selected_component_ : Q_HUD_COMPONENT
		do
			from
				old_selected_component_ := selected_component
				selected_component := tree_child_at(x_, y_ )	
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
					old_selected_component_.process_mouse_exit( 
						x_ - absolut_x_location ( old_selected_component_),
						y_ - absolut_y_location ( old_selected_component_) )
				end
				
				if selected_component /= void then
						selected_component.process_mouse_enter( 
						x_ - absolut_x_location ( selected_component),
						y_ - absolut_y_location ( selected_component) )				
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
