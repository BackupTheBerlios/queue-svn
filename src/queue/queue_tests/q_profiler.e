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

-- how to use:
-- Call the p_begin-feature, when you start a block, and call the
-- p_end-feature, when you finish it.
-- The profiler will then measure the time between a call of begin and end.
-- Its possible the have blocks inside another block. The profiler is
-- organized with a stack, so its not possible to have a thing like "block A
-- start", "block B start", "block A end", "block B end".
-- You can call the "write"-feature, and the profiler will write all
-- measurements into a file called "profiler_<time>.txt", where time is the
-- time in milliseconds since the start of the programm.
-- You can call "clear", if you want to delete all measuremets.

-- Don't forgett:
-- to add for every p_begin a p_end
-- to save the results by calling write
-- to empty the profiler by calling clear
-- that there is only one profiler for the whole program. You can create as
-- many profilers as you want, the measurements will always be saved at the
-- same place.
	
class
	Q_PROFILER

creation
	make
	
feature{NONE}
	make is
		do
		end

feature
	clear is
		do
			count.clear_all
			stack.wipe_out
		end
		

	write is
		local
			file_ : PLAIN_TEXT_FILE
			time_, count_ : INTEGER
		do
			create file_.make_open_write( "profile_" + time.current_time.out + ".txt" )
			
			file_.put_string( "class.feature%Tcount%Ttim sum%Ttime rel" )
			file_.put_new_line
			
			from
				count.start
			until
				count.after
			loop	
				file_.put_new_line
				
				file_.put_string( count.key_for_iteration )
				file_.put_string( "%T" )
				
				count_ := count.item_for_iteration.integer_item( 1 )
				time_ := count.item_for_iteration.integer_item( 2 )
				
				file_.put_string( count_.out )
				file_.put_string( "%T" )

				file_.put_string( time_.out )
				file_.put_string( "%T" )
				
				file_.put_double( time_ / count_ )
				
				count.forth
			end
			
			file_.close
		end
		

	p_begin( class_, feature_ : STRING ) is
		do
			stack.extend( [class_, feature_, time.current_time] )
		end
	
	
	p_end is
		local
			start_, delta_, count_, time_ : INTEGER
			class_, feature_ : STRING
			input_ : TUPLE[ INTEGER, INTEGER] 
		do
			time.restart
			start_ := stack.last.integer_item( 3 )
			delta_ := time.current_time - start_
			
			class_ ?= stack.last.item( 1 )
			feature_ ?= stack.last.item( 2 )
			
			input_ := count.item( class_ + "." + feature_ )
			if input_ = void then
				count.force( [1, delta_], class_ + "." + feature_ )
			else
			
				count_ := input_.integer_item( 1 )
				time_ := input_.integer_item( 2 )
			
				count.force( [count_ + 1, time_ + delta_], class_ + "." + feature_ )
			end
			
			stack.go_i_th( stack.count )
			stack.remove
		end
		
feature{NONE}
	time : Q_TIME is
		once
			create result
		end
	
	count : HASH_TABLE[ TUPLE[INTEGER, INTEGER], STRING ] is
		once
			create result.make( 20 )
		end
		
	
	stack : ARRAYED_LIST[ TUPLE[ STRING, STRING, INTEGER ] ] is
		once
			create result.make( 20 )
		end
		

	

end -- class Q_PROFILER
