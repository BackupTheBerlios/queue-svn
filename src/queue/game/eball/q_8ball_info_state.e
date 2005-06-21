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
	description: "Shows a text to the user. When the user presses the ok-button, the next state will be shown"
	author: "Benjamin Sigg"

class
	Q_8BALL_INFO_STATE

inherit
	Q_INFO_STATE
	redefine
		install, uninstall
	end
	
creation
	make_mode
	
feature{NONE}
	make_mode( mode_ : Q_8BALL; right_to_left_ : BOOLEAN; identifier_ : STRING ) is
		do
			make_positioned( right_to_left_, true, identifier_ )
			mode := mode_
		end

	mode : Q_8BALL
	
feature
	install( ressources_ : Q_GAME_RESSOURCES ) is
		do
			precursor( ressources_ )
			ressources_.gl_manager.add_hud( mode.info_hud )
		end
	
	uninstall( ressources_ : Q_GAME_RESSOURCES ) is
		do
			precursor( ressources_ )
			ressources_.gl_manager.remove_hud( mode.info_hud )
		end

end -- class Q_8BALL_INFO_STATE
