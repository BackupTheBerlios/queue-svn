indexing
	description: "This queue collects events from the event-loop, and saves them, until they are executed by another process"
	author: "Benjamin Sigg"
	revision: "1.0"

class
	Q_EVENT_QUEUE

creation
	make, make_empty
	
feature{NONE} -- creation
	make( event_loop_ : ESDL_EVENT_LOOP; surface_ : ESDL_VIDEO_SUBSYSTEM ) is
			-- creates a queue, using a predefined loop
		require
			loop_not_void : event_loop_ /= void
			surface_not_void : surface_ /= void
		do
			event_loop := event_loop_
			surface := surface_
			
			create queue.make	

			event_loop.active_event.force( agent handle_active_event(?) )
			event_loop.key_down_event.force( agent handle_key_down_event(?) )
			event_loop.key_up_event.force( agent handle_key_up_event(?) )
			event_loop.mouse_motion_event.force( agent handle_mouse_motion_event(?) )
			event_loop.mouse_button_down_event.force( agent handle_mouse_button_down_event(?) )
			event_loop.mouse_button_up_event.force( agent handle_mouse_button_up_event(?) )
			event_loop.joystick_axis_event.force( agent handle_joystick_axis_event(?) )
			event_loop.joystick_button_down_event.force( agent handle_joystick_button_down_event(?) )
			event_loop.joystick_button_up_event.force( agent handle_joystick_button_up_event(?) )
			event_loop.joystick_hat_event.force( agent handle_joystick_hat_event(?) )
			event_loop.joystick_ball_event.force( agent handle_joystick_ball_event(?) )
			event_loop.resize_event.force( agent handle_resize_event(?) )
			event_loop.window_manager_event.force( agent handle_window_manager_event(?) )
			event_loop.user_event.force( agent handle_user_event(?) )
			event_loop.expose_event.force( agent handle_expose_event(?) )
			event_loop.quit_event.force( agent handle_quit_event(?) )
		end		

	make_empty( surface_ : ESDL_VIDEO_SUBSYSTEM ) is
			-- creates an eventqueue witch does not listen to the eventloop
		require
			surface_not_void : surface_ /= void
		do
			create queue.make
			surface := surface_
		end
		

feature -- information top
	top_flag : INTEGER is
			-- Returns the type of event currently at the head of the queue. The value is 0, if there are no events
		do
			if is_empty then
				result := 0
			else
				result := queue.first.integer_item(1)
			end
		end
		

	is_empty : BOOLEAN is
			-- true if, and only if, the queue cannot deliver more elements
		do
			result := queue.is_empty
		end

	is_active_event : BOOLEAN is
		require
			not_empty : is_empty = false
		do
			result := is_top( active_event )
		end
		

	is_key_down_event : BOOLEAN is
			-- true if the next available event is a key-down-event
		require
			not_empty : is_empty = false
		do
			result := is_top( key_down_event )
		end
		
	is_key_up_event : BOOLEAN is
		require
			not_empty : is_empty = false
		do
			result := is_top( key_up_event )
		end
		
	is_mouse_motion_event : BOOLEAN is
		require
			not_empty : is_empty = false
		do
			result := is_top( mouse_motion_event )
		end
		
	is_mouse_button_down_event : BOOLEAN is
		require
			not_empty : is_empty = false
		do
			result := is_top( mouse_button_down_event )
		end
	
	is_mouse_button_up_event : BOOLEAN is
		require
			not_empty : is_empty = false
		do
			result := is_top( mouse_button_up_event )
		end
		
	is_joystick_axis_event : BOOLEAN is
		require
			not_empty : is_empty = false
		do
			result := is_top( joystick_axis_event )
		end
		
	is_joystick_button_down_event : BOOLEAN is
		require
			not_empty : is_empty = false
		do
			result := is_top( joystick_button_down_event )
		end

	is_joystick_button_up_event : BOOLEAN is
		require
			not_empty : is_empty = false
		do
			result := is_top( joystick_button_up_event )
		end		

	is_joystick_hat_event : BOOLEAN is
		require
			not_empty : is_empty = false
		do
			result := is_top( joystick_hat_event )
		end
		
	is_joystick_ball_event : BOOLEAN is
		require
			not_empty : is_empty = false
		do
			result := is_top( joystick_ball_event )
		end
		

	is_resize_event : BOOLEAN is
		require
			not_empty : is_empty = false
		do
			result := is_top( resize_event )
		end
		
	is_window_manager_event : BOOLEAN is
		require
			not_empty : is_empty = false
		do
			result := is_top( window_manager_event )
		end
		

	is_user_event : BOOLEAN is
		require
			not_empty : is_empty = false
		do
			result := is_top( user_event )
		end
	
	is_expose_event : BOOLEAN is
		require
			not_empty : is_empty = false
		do
			result := is_top( expose_event )
		end

	is_quit_event : BOOLEAN is
		require
			not_empty : is_empty = false
		do
			result := is_top( quit_event )
		end
		
	is_top( event_type_ : INTEGER ) : BOOLEAN is
			-- true if the element at the top is of the given type
		require
			not_empty : is_empty = false
		do
			result := queue.first.integer_item(1).bit_and( event_type_ ) /= 0
		end
	
feature{Q_EVENT_QUEUE} -- append
	append( type_ : INTEGER; event_ : ANY ) is
			-- Adds an event of a given type to the queue
		do
			queue.force([type_, event_])
		end
	
feature -- access top
	move_forward_until( event_ : INTEGER ) is
			-- pops events until no event is left, or an event with the given signature is found
		local
			any_ : ANY
				-- totally meaningless variable, but forced by the syntax of eiffel
		do
			from
				
			until
				is_empty or else is_top( event_ )
			loop
				any_ := pop_event
			end
		end
	
	move_forward_and_append_until( event_ : INTEGER; queue_ : Q_EVENT_QUEUE ) is
			-- pops events until no event is left, or an event with the given signature is found
			-- if an event is poped, it is appended to "queue"
		require
			queue_ /= void
		local
			any_ : ANY
			flag_ : INTEGER
		do
			from
				
			until
				is_empty or else is_top( event_ )
			loop
				flag_ := top_flag
				any_ := pop_event
				queue_.append( flag_, any_ )
			end
		end
	
	throw_away( queue_ : Q_EVENT_QUEUE ) is
			-- Removes the first event in this queue, and
			-- appends the event to the other queue
		require
			queue_ /= void
			not is_empty
		local
			type_ : INTEGER
			event_ : ANY
		do
			type_ := top_flag
			event_ := pop_event
			
			queue_.append( type_, event_ )
		end
		
	count : INTEGER is
		do
			result := queue.count
		end
		
feature -- pop	
	pop_event : ANY is
			-- removes the event at the head, and returns it
		require
			not_empty : is_empty = false
		do
			queue.start
			result := queue.item.item( 2 )
			queue.remove
		end
		

	pop_active_event : ESDL_ACTIVE_EVENT is
		require
			is_active_event
		do
			result ?= pop_event
		ensure
			result_not_void : result /= void
		end
		

	pop_keyboard_event : ESDL_KEYBOARD_EVENT is
		require
			is_key_event : is_top( key_event )
		do
			result ?= pop_event
		ensure
			result_not_void : result /= void
		end
	
	pop_mouse_motion_event : ESDL_MOUSEMOTION_EVENT is
		require
			is_mouse_motion_event
		do
			result ?= pop_event
		ensure
			result_not_void : result /= void
		end
	
	pop_mouse_button_event : ESDL_MOUSEBUTTON_EVENT is
		require
			is_mouse_button_event : is_top( mouse_button_event )
		do
			result ?= pop_event
		ensure
			result_not_void : result /= void
		end
		
	pop_joystick_axis_event : ESDL_JOYSTICK_AXIS_EVENT is
		require
			is_joystick_axis_event
		do
			result ?= pop_event
		ensure
			result_not_void : result /= void
		end
	
	pop_joystick_button_event : ESDL_JOYSTICK_BUTTON_EVENT is
		require
			is_joystick_button_event : is_top( joystick_button_event )
		do
			result ?= pop_event
		ensure
			result_not_void : result /= void
		end
		
	pop_joystick_hat_event : ESDL_JOYSTICK_HAT_EVENT is
		require
			is_joystick_hat_event
		do
			result ?= pop_event
		ensure
			result_not_void : result /= void
		end
		
	pop_joystick_ball_event : ESDL_JOYSTICK_BALL_EVENT is
		require
			is_joystick_ball_event
		do
			result ?= pop_event
		ensure
			result_not_void : result /= void
		end
		
	pop_resize_event : ESDL_RESIZE_EVENT is
		require
			is_resize_event
		do
			result ?= pop_event
		ensure
			result_not_void : result /= void
		end
		
	pop_winwow_manager_event : ESDL_WINDOWMANAGER_EVENT is
		require
			is_window_manager_event
		do
			result ?= pop_event
		ensure
			result_not_void : result /= void
		end
		
	pop_user_event : ESDL_USER_EVENT is
		require
			is_user_event
		do
			result ?= pop_event
		ensure
			result_not_void : result /= void
		end			
		
	pop_expose_event : ESDL_EXPOSE_EVENT is
		require
			is_expose_event
		do
			result ?= pop_event
		ensure
			result_not_void : result /= void
		end
		
	pop_quit_event : ESDL_QUIT_EVENT is
		require
			is_quit_event
		do
			result ?= pop_event
		ensure
			result_not_void : result /= void
		end

feature -- Peek
	peek_event : ANY is
			-- removes the event at the head, and returns it
		require
			not_empty : is_empty = false
		do
			queue.start
			result := queue.item.item( 2 )
		end

	peek_active_event : ESDL_ACTIVE_EVENT is
		require
			is_active_event
		do
			result ?= peek_event
		ensure
			result_not_void : result /= void
		end
		

	peek_keyboard_event : ESDL_KEYBOARD_EVENT is
		require
			is_key_event : is_top( key_event )
		do
			result ?= peek_event
		ensure
			result_not_void : result /= void
		end
	
	peek_mouse_motion_event : ESDL_MOUSEMOTION_EVENT is
		require
			is_mouse_motion_event
		do
			result ?= peek_event
		ensure
			result_not_void : result /= void
		end
	
	peek_mouse_button_event : ESDL_MOUSEBUTTON_EVENT is
		require
			is_mouse_button_event : is_top( mouse_button_event )
		do
			result ?= peek_event
		ensure
			result_not_void : result /= void
		end
		
	peek_joystick_axis_event : ESDL_JOYSTICK_AXIS_EVENT is
		require
			is_joystick_axis_event
		do
			result ?= peek_event
		ensure
			result_not_void : result /= void
		end
	
	peek_joystick_button_event : ESDL_JOYSTICK_BUTTON_EVENT is
		require
			is_joystick_button_event : is_top( joystick_button_event )
		do
			result ?= peek_event
		ensure
			result_not_void : result /= void
		end
		
	peek_joystick_hat_event : ESDL_JOYSTICK_HAT_EVENT is
		require
			is_joystick_hat_event
		do
			result ?= peek_event
		ensure
			result_not_void : result /= void
		end
		
	peek_joystick_ball_event : ESDL_JOYSTICK_BALL_EVENT is
		require
			is_joystick_ball_event
		do
			result ?= peek_event
		ensure
			result_not_void : result /= void
		end
		
	peek_resize_event : ESDL_RESIZE_EVENT is
		require
			is_resize_event
		do
			result ?= peek_event
		ensure
			result_not_void : result /= void
		end
		
	peek_winwow_manager_event : ESDL_WINDOWMANAGER_EVENT is
		require
			is_window_manager_event
		do
			result ?= peek_event
		ensure
			result_not_void : result /= void
		end
		
	peek_user_event : ESDL_USER_EVENT is
		require
			is_user_event
		do
			result ?= peek_event
		ensure
			result_not_void : result /= void
		end			
		
	peek_expose_event : ESDL_EXPOSE_EVENT is
		require
			is_expose_event
		do
			result ?= peek_event
		ensure
			result_not_void : result /= void
		end
		
	peek_quit_event : ESDL_QUIT_EVENT is
		require
			is_quit_event
		do
			result ?= peek_event
		ensure
			result_not_void : result /= void
		end

feature -- constants
	active_event : INTEGER					is        1
	key_down_event : INTEGER				is        2
	key_up_event : INTEGER					is        4
	mouse_motion_event : INTEGER			is        8
	mouse_button_down_event : INTEGER		is       16
	mouse_button_up_event : INTEGER			is       32
	joystick_axis_event : INTEGER			is       64
	joystick_button_down_event : INTEGER	is      128
	joystick_button_up_event : INTEGER		is      256
	joystick_hat_event : INTEGER			is      512
	joystick_ball_event : INTEGER			is     1024
	resize_event : INTEGER					is     2048
	window_manager_event : INTEGER			is     4096
	user_event : INTEGER					is     8192
	expose_event : INTEGER					is    16384
	quit_event : INTEGER					is    32768

	key_event : INTEGER is
		once
			result := key_down_event.bit_or( key_up_event )
		end
		
	mouse_button_event : INTEGER is
		once
			result := mouse_button_up_event.bit_or( mouse_button_down_event )
		end
	
	joystick_button_event : INTEGER is
		once
			result := joystick_button_down_event.bit_or( joystick_button_up_event )
		end
	
	mouse_event : INTEGER is
		once
			result := mouse_button_down_event.bit_or( mouse_button_up_event ).bit_or( mouse_motion_event )
		end
	
	input_event : INTEGER is
			-- Mouse or Key-Event
		once
			result := key_event.bit_or( mouse_event )
		end
		

feature -- loop
	stop is
			-- stops the eventloop. The queue will no longer grow
		do
			event_loop.stop
		end		

feature -- additional informations
	surface : ESDL_VIDEO_SUBSYSTEM
		-- the surface from witch the events came

feature {NONE} -- fields
	event_loop : ESDL_EVENT_LOOP
		-- the eventloop to get events
		
	queue : LINKED_LIST[ TUPLE[ INTEGER, ANY ]]
		-- the events not yet processed

feature {NONE} -- handlers
	handle_active_event( any_ : ANY ) is
		do
			queue.force( [active_event, any_ ] )
		end
		

	handle_key_down_event( any_ : ANY ) is
		do
			queue.force( [key_down_event, any_] )
		end

	handle_key_up_event( any_ : ANY ) is
		do
			queue.force( [key_up_event, any_] )
		end

	handle_mouse_motion_event( any_ : ANY ) is
		do
			queue.force( [mouse_motion_event, any_ ] )
		end
		
	handle_mouse_button_down_event( any_ : ANY ) is
		do
			queue.force( [mouse_button_down_event, any_] )
		end
		
	handle_mouse_button_up_event( any_ : ANY ) is
		do
			queue.force( [mouse_button_up_event, any_ ] )
		end
		
	handle_joystick_axis_event( any_ : ANY ) is
		do
			queue.force( [joystick_axis_event, any_ ] )
		end
		
	handle_joystick_button_down_event( any_ : ANY ) is
		do
			queue.force( [joystick_button_down_event, any_ ] )
		end
		
	handle_joystick_button_up_event( any_ : ANY ) is
		do
			queue.force( [joystick_button_up_event, any_ ] )
		end

	handle_joystick_hat_event( any_ : ANY ) is
		do
			queue.force( [joystick_hat_event, any_ ] )
		end

	handle_joystick_ball_event( any_ : ANY ) is
		do
			queue.force( [joystick_ball_event, any_ ] )
		end

	handle_resize_event( any_ : ANY ) is
		do
			queue.force( [resize_event, any_ ] )
		end

	handle_window_manager_event( any_ : ANY ) is
		do
			queue.force( [window_manager_event, any_ ] )
		end		

	handle_user_event( any_ : ANY ) is
		do
			queue.force( [user_event, any_ ] )
		end

	handle_expose_event( any_ : ANY ) is
		do
			queue.force( [expose_event, any_ ] )
		end

	handle_quit_event( any_ : ANY ) is
		do
			queue.force( [quit_event, any_ ] )
		end

end -- class Q_EVENT_QUEUE
