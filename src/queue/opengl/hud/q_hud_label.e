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
			
			background.set_alpha( 0.75 )
			set_blend_background( true )
		end
end -- class Q_HUD_LABEL
