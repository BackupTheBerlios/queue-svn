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
	description: "A description, how the camera does behave. Instances of this class could be sent to the Q_HUD_NAVIGATION_PANE"
	author: "Benjamin Sigg"

deferred class
	Q_CAMERA_BEHAVIOUR

feature -- camera
	camera : Q_GL_CAMERA
		-- the camera used by this behaviour
	
	set_camera( camera_ : Q_GL_CAMERA ) is
			-- Sets the camera this behaviour should influence.
			-- A void-value means, that no camera should be influenced
		do
			camera := camera_
		end
		
	update( time_ : Q_TIME ) is
			-- Called all few milliseconds. The Behaviour can
			-- change the position of the camera.
		do
			-- nothing
		end
		

feature -- event-handling
	process_key_down (event_: ESDL_KEYBOARD_EVENT; map_ : Q_KEY_MAP ): BOOLEAN is
			-- invoked when a keyevent happens, and this component has the focus and is enabled
			-- returns true if the event is consumed, false if the parent should be invoked with the event
		do
			Result := False
		end

	process_key_up (event_: ESDL_KEYBOARD_EVENT; map_ : Q_KEY_MAP ): BOOLEAN is
			-- invoked when a keyevent happens, and this component has the focus and is enabled
			-- returns true if the event is consumed, false if the parent should be invoked with the event
		do
			Result := False
		end

	process_mouse_enter (x_, y_: DOUBLE; map_ : Q_KEY_MAP ) is
			-- invoked when the Mouse enters this component
		do
		end

	process_mouse_exit (x_, y_: DOUBLE; map_ : Q_KEY_MAP ) is
			-- invoked when the Mouse exites this component.
			-- this method will perhaps not be called, if the enabled-state is set to false,
			-- or the component is removed from its parent
		do
		end

	process_mouse_button_down (event_: ESDL_MOUSEBUTTON_EVENT; x_, y_: DOUBLE; map_ : Q_KEY_MAP ): BOOLEAN is
			-- invoked when a Mousebutton is pressed, and the Mouse is over this Component
			-- returns true if the event is consumed, false if the parent should be invoked with the event
		do
			Result := False
		end

	process_mouse_button_up (event_: ESDL_MOUSEBUTTON_EVENT; x_, y_: DOUBLE; map_ : Q_KEY_MAP ): BOOLEAN is
			-- invoked when a Mousebutton is released, witch was earlier pressed over this Component
			-- returns true if the event is consumed, false if the parent should be invoked with the event
		do
			Result := False
		end

	process_mouse_moved (event_: ESDL_MOUSEMOTION_EVENT; x_, y_: DOUBLE; map_ : Q_KEY_MAP ): BOOLEAN is
			-- invoked the mouse is moved over this component, but not if a mousebutton was pressed over another component
			-- returns true if the event is consumed, false if the parent should be invoked with the event
		do
			Result := False
		end

end -- class Q_CAMERA_BEHAVIOUR
