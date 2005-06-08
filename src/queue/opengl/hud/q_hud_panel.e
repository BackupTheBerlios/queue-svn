indexing
	description: "Object that does only show a rectangle in the space"
	author: "Benjamin Sigg"

class
	Q_HUD_PANEL

inherit
	Q_HUD_COMPONENT
	redefine
		make
	end
	
creation
	make
	
feature{NONE} -- creation
	make is
		do
			precursor
			
			set_enabled( false )
			set_focusable( false )
			set_background( color_defaults.color_of( "panel", "background" ))
			set_blend_background( color_defaults.blend( "panel" ))
		end

feature
	draw_foreground( open_gl : Q_GL_DRAWABLE ) is
		do
			
		end
		
	visible : BOOLEAN is
		do
			result := true
		end
		
	
end -- class Q_HUD_PANEL
