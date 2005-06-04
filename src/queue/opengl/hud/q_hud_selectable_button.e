indexing
	-- description: "Base-class for components with a selected-state. 
	-- This button also has a special rectangle in witch he should draw its state (the box)"
	
	author: "Benjamin Sigg"

deferred class
	Q_HUD_SELECTABLE_BUTTON
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
		process_component_added,
		process_key_down
	redefine
		draw_foreground
	select
		texted_make
	end
	
	Q_HUD_MOUSE_SENSITIVE_COMPONENT
	undefine
		make
	redefine
		draw_foreground
	end

feature {Q_HUD_SELECTABLE_BUTTON} -- Creation
	make is
		do
			texted_make
			make_sensitive
			
			set_background_normal( create {Q_GL_COLOR}.make_rgb( 0.5, 0.5, 1 ) )
			set_background_pressed( create {Q_GL_COLOR}.make_rgb( 0.25, 0.25, 1 ) )
			set_background_rollover( create {Q_GL_COLOR}.make_rgb( 0.75, 0.75, 1 ) )
			
			set_alignement_x( 0.0 )
			set_alignement_y( 0.5 )
			
			set_enabled( true )
			set_focusable( true )
			
			key_down_listener.extend( agent key_down( ?,?,? ))
			
			create actions
		end
		
feature {Q_HUD_CHECK_BOX} -- eventhandling
	do_click is
		do
			set_selected( not selected )
		end
		
	key_down( event_ : ESDL_KEYBOARD_EVENT; map_ : Q_KEY_MAP; consumed_ : BOOLEAN ) : BOOLEAN is
		do
			if not consumed_ then
				if event_.key = event_.sdlk_space or event_.key = event_.sdlk_return then
					do_click
					result := true
				else
					result := false
				end
			end
		end
		
feature {Q_HUD_SELECTABLE_BUTTON_GROUP} -- button group
	group : Q_HUD_SELECTABLE_BUTTON_GROUP
	
	set_group( group_ : Q_HUD_SELECTABLE_BUTTON_GROUP ) is
		do
			group := group_
		end
		
		
feature -- drawing
	draw_foreground( open_gl : Q_GL_DRAWABLE ) is
		local
			insets_, old_insets_ : Q_HUD_INSETS
			box_height_, box_width_ : DOUBLE
		do
			-- maximal width and height of the box
			box_height_ := height
			box_width_ := box_height_.min( width / 2 )
			
			-- draw the text
			old_insets_ := insets
							
			if insets = void then
				create insets_.make( 0, 0, 0, 0 )
			else
				create insets_.make_copy( insets )
			end
			
			insets_.set_left( insets_.left + box_width_ / width  )
			set_insets( insets_ )
			precursor( open_gl )
			set_insets( old_insets_ )
			
			-- draw the box
			draw_box( open_gl, box_width_, box_height_ )
		end
		
	draw_box( open_gl : Q_GL_DRAWABLE; width__, height__ : DOUBLE ) is
			-- draws the box in the rectangle 0, 0, width_, height_
		deferred
		end
		
feature -- event handling
	actions : EVENT_TYPE[ TUPLE[ BOOLEAN, like current ] ] 
		-- agents registered in this list will be invoked if, 
		-- and only if, the select-state of the button changes

feature -- Values
	selected : BOOLEAN
	
	set_selected( selected_ : BOOLEAN ) is
			-- Changes the select-state of this button. If this button is
			-- in a group, the change may be canceld, or other Buttons will
			-- react too
		do
			if selected /= selected_ then
				if group = void or else group.changed( selected_, current ) then
					selected := selected_
			
					from
						actions.start
					until
						actions.after
					loop
						actions.item.call( [selected, current] )
						actions.forth
					end
				end
			end
		end	


end -- class Q_HUD_SELECTABLE_BUTTON
