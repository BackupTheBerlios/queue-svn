indexing
	description: "Paints a text on the screen, with a background"
	author: "Benjamin Sigg"
	revision: "1.0"

class
	Q_HUD_LABEL

inherit
	Q_HUD_TEXTED
	redefine
		make
	end

creation
	make
	
feature {NONE} -- creation
	make is
		do
			precursor
			set_alignement_x( 0.0 )
			set_alignement_y( 0.5 )
			
			set_foreground( color_defaults.color_of( "label", "foreground" ))
			set_background( color_defaults.color_of( "label", "background" ))
			set_blend_background( color_defaults.blend( "label" ) )
			
			set_insets( create {Q_HUD_INSETS}.make( 0.01, 0.05, 0.01, 0.01 ))
		end
end -- class Q_HUD_LABEL
