--
--  queue
--
--  Copyright (C) 2005  
--  Basil Fierz, Severin Hacker, Andreas Kaegi, Benjamin Sigg
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU Library General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
--

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
			extend( create {BEN_SLIDER_TEST} )
			extend( create {BEN_TIME_HUD_TEST}.make )
			extend( create {BAS_BIG_8BALL_TEST} )
	--		extend( create {BEN_BALL_CAMERA_BEHAVIOUR_TEST} )
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
			extend( create {BEN_MATERIAL_TEST} )
			extend( create {BEN_COMPONENT_QUEUE_TEST}.make )
			extend( create {HAC_8BALL_TEST})
			extend( create {HAC_RANDOM_TEST})
		end

end -- class Q_TEST_CASE_LIST
