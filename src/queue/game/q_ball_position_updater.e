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
	description: "On every call of draw, an object of this class will recalculate the position of the models of all balls"
	author: "Benjamin Sigg"

class
	Q_BALL_POSITION_UPDATER

inherit
	Q_GL_OBJECT
	
creation
	make
	
feature{NONE}
	make( mode_ : Q_MODE ) is
		do
			set_mode( mode_ )
		end
		

feature -- mode
	mode : Q_MODE
	
	set_mode( mode_ : Q_MODE ) is
		do
			mode := mode_
		end
		
feature
	draw( open_gl : Q_GL_DRAWABLE ) is
		local
			balls_ : ARRAY[ Q_BALL_MODEL ]
			ball_ : Q_BALL_MODEL
			index_ : INTEGER
		do
			balls_ := mode.ball_models
			from index_ := balls_.lower	until index_ > balls_.upper loop
				ball_ := balls_.item( index_ )
				ball_.set_position( mode.position_table_to_world( ball_.ball.center ))
				
				index_ := index_ + 1
			end
		end
		

end -- class Q_BALL_POSITION_UPDATER
