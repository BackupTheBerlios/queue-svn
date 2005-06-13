indexing
	description: "This Component allows the user to write text"
	author: "Benjamin Sigg"

class
	Q_HUD_TEXT_FIELD

inherit
	Q_HUD_TEXTED
	redefine
		draw_text,
		set_text,
		make
	end
	
creation
	make
	
feature{NONE} -- creation
	make is
		do
			precursor
			
			set_focusable( true )
			set_enabled( true )

			set_background( color_defaults.color_of( "textfield", "background" ))
			set_foreground( color_defaults.color_of( "textfield", "foreground" ))
			
			set_blend_background( color_defaults.blend( "textfield") )			

			set_cursor( 1 )
			
			set_alignement_x( 0 )
			set_alignement_y( 0.5 )
			
			set_insets( create {Q_HUD_INSETS}.make( 0, 0.1, 0, 0.1 ))
			set_text( "" )
			set_font( font_defaults.font( "textfield" ))
			
			mouse_button_down_listener.extend( agent mouse_button_down( ?,?,?,?,? ))
			key_down_listener.extend( agent key_down( ?,?,? ))
		end
		
	
feature -- drawing
	draw_text (text_: STRING; x_, base_, ascent_, descent_: DOUBLE; open_gl: Q_GL_DRAWABLE) is
		local
			cursor_pos_ : DOUBLE
		do
			precursor( text_, x_, base_, ascent_, descent_, open_gl )
			left_text_start := x_
			
			if focused then
				open_gl.gl.gl_color3f( 0, 0, 0 )
				if cursor = 1 then
					cursor_pos_ := 0
				else
					cursor_pos_ := font.string_width( text.substring( 1, cursor-1), font_size )
				end
				cursor_pos_ := cursor_pos_ + x_
				open_gl.gl.gl_rectd( cursor_pos_ - font_size / 50, base_ - ascent_,
									 cursor_pos_ + font_size/ 50, base_ + descent_ )
			end
		end
	
feature -- text
	cursor : INTEGER
	
	set_cursor( cursor_ : INTEGER ) is
			--
		require
			cursor_valid : cursor >= 1 or cursor <= text.count+1
		do
			cursor := cursor_
		end

	set_text( text_ : STRING ) is
		do
			precursor( text_ )
			
			if cursor > text_.count+1 then
				set_cursor( text_.count+1 )
			end
		end
		

feature {NONE} -- event handling
	left_text_start : DOUBLE
	-- calculated by the Superclass, when it is painted (so its that, what the user
	-- sees, not a bad compromis, i think)
	
	mouse_button_down (event_: ESDL_MOUSEBUTTON_EVENT; x__, y_: DOUBLE; map_ : Q_KEY_MAP; consumed_ : BOOLEAN): BOOLEAN is
		local
			count_ : INTEGER
			stop_ : BOOLEAN
			x_, width_old_, width_new_ : DOUBLE
		do
			if not consumed_ then
				-- search new position for cursor
				x_ := x__ - left_text_start
				
				from
					count_ := 0
					stop_ := false
				until
					stop_ or count_ >= text.count
				loop
					width_old_ := width_new_
					
					if count_ = 0 then
						width_old_ := 0
						width_new_ := 0
					else
						width_new_ := font.string_width( text.substring( 1, count_ ), font_size )
					end
					
					if width_new_ > x_ then
						stop_ := true
						
						if width_new_ - x_ > x_ - width_old_ then
							count_ := count_ - 1	
						end
					else
						count_ := count_ + 1	
					end
				end
				
				if count_ < 0 then
					count_ := 0
				end
				
				set_cursor( count_ + 1 )
				
				request_focus
				result := true
			end
		end

	key_down (event_: ESDL_KEYBOARD_EVENT; map_ : Q_KEY_MAP; consumed_ : BOOLEAN ): BOOLEAN is
		local
			delete_ : BOOLEAN
			character_ : CHARACTER
		do
			if not consumed_ then
				result := false
				
				-- insert or remove some letters
				if event_.key = event_.sdlk_backspace then
					if cursor > 1 then
						delete_ := true
						cursor := cursor - 1	
					end
				end
				
				if delete_ or event_.key = event_.sdlk_delete then
					if cursor <= text.count and text.count > 0 then
						if text.count = 1 then
							set_text( "" )
						elseif cursor = 1 then
							set_text( text.substring( 2, text.count ))
						elseif cursor = text.count then
							set_text( text.substring( 1, cursor-1 ))
						else
							set_text(
								text.substring( 1, cursor-1 ) +
								text.substring( cursor+1, text.count ))
						end
					end	
					result := true
				elseif event_.key = event_.sdlk_right then
					if cursor <= text.count then
						set_cursor( cursor+1 )
					end
					result := true
				elseif event_.key = event_.sdlk_left then
					if cursor > 1 then
						set_cursor( cursor-1 )
					end
					result := true
				elseif event_.key = event_.sdlk_home then
					set_cursor( 1 )
					result := true
				elseif event_.key = event_.sdlk_end then
					set_cursor( text.count + 1 )
					result := true
				else
					if map_.is_write_key( event_.key ) then
						character_ := event_.character
					
						if (event_.is_caps_locked and not event_.is_shift_pressed) or
							(not event_.is_caps_locked and event_.is_shift_pressed) then
							
							character_ := character_.upper
						end
						
						if font.known_letter( character_ ) then
							if text.count = 0 then
								set_text( character_.out )
							elseif cursor = 1 then
								set_text( character_.out + text )
							elseif cursor = text.count+1 then
								set_text( text + character_.out )
							else
								set_text(
									text.substring( 1, cursor-1 ) +
									character_.out + 
									text.substring( cursor, text.count ))
							end
							cursor := cursor + 1
							result := true
						end	
					end
				end
			end
		end

end -- class Q_HUD_TEXT_FIELD
