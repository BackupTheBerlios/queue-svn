indexing
	description: "A button showed on the screen. Can be pressed by the mouse"
	author: "Benjamin Sigg"

class
	Q_HUD_BUTTON

inherit
	Q_HUD_TEXTED
	rename
		background as background_normal,
		set_background as set_background_normal,
		make as texted_make
	undefine
		draw_background,
		process_mouse_button_down,
		process_mouse_button_up,
		process_mouse_enter,
		process_mouse_exit,
		process_component_removed,
		process_component_added
	select
		texted_make
	end
	
	Q_HUD_MOUSE_SENSITIVE_COMPONENT
	undefine
		make
	redefine
		process_key_down
	end
	
creation
	make

feature {NONE} -- creation
	make is
		do
			texted_make
			make_sensitive
			
			create actions	
			set_focusable( true )
			set_enabled( true )
			set_command( "no command" )
			
			set_alignement_x( 0.5 )
			set_alignement_y( 0.5 )

			set_background_normal( create {Q_GL_COLOR}.make_rgba( 1, 0.5, 0, 0.75 )) -- orange
			set_background_pressed( create {Q_GL_COLOR}.make_rgba( 1, 0, 0, 0.75 )) -- red
			set_background_rollover( create {Q_GL_COLOR}.make_rgba( 1, 1, 0, 0.75 )) -- yellow
			set_blend_background( true )
			
			key_down_listener.extend( agent do_click_on_event( ?, ? ))
		end		

feature -- eventhandling
	actions : EVENT_TYPE[ TUPLE[ STRING, Q_HUD_BUTTON ] ] 
	
	command : STRING
	
	set_command( command_ : STRING ) is
			-- Sets the command of this button
		do
			command := command_
		end
		
	
	do_click is
			-- calls a click on all known agents
		do
			from
				actions.start
			until
				actions.after
			loop
				actions.item.call( [command, current] )
				actions.forth
			end
		end

	do_click_on_event( event_ : ESDL_KEYBOARD_EVENT; consumed_ : BOOLEAN ) : BOOLEAN is
		do
			if not consumed_ then
				if event_.key = event_.sdlk_return then
					do_click
					result := true
				else
					result := false
				end
			end
		end
		

end -- class Q_HUD_BUTTON
