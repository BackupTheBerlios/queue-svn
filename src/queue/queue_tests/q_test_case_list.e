indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_TEST_CASE_LIST
	
inherit
	ARRAYED_LIST[ Q_TEST_CASE ]
	rename
		make as list_make
	end
	

creation
	make
	
feature {NONE} -- creation

	make is
		do
			list_make( 10 )
			
			-- add here the test-cases
			extend( create {BAS_TABLE_MODEL_TEST} )
			extend( create {ACE_PHYS_TEST} )
			extend( create {BEN_LIGHT_TEST} )
			extend( create {BEN_HUD_FONT_TEST} )
			extend( create {BEN_COLOR_CUBE_TEST} )
			extend( create {BEN_TEXTFIELD_TEST} )
			extend( create {BEN_LINE} )
			extend( create {BEN_CHECKBOX_TEST} )
			extend( create {BEN_RADIO_BUTTON_TEST} )
			extend( create {BEN_MATRIX_TEST} )
			extend( create {BEN_GAUSS_TEST} )
			extend( create {BEN_CONTAINER_3D_TEST}.make )
			extend( create {BEN_TIME_TEST} )
			extend( create {BEN_ROTATING_CONTAINER_TEST}.make )
		end

end -- class Q_TEST_CASE_LIST
