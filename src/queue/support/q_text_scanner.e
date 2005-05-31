indexing
	description: "A tokenzier suited for iterated scanning."
	author: "Basil Fierz, bfierz@student.ethz.ch"
	date: "$Date: 2005/05/31 $"
	revision: "$Revision: 1.0 $"

class
	Q_TEXT_SCANNER
	
create
	make_from_string_with_delimiters
	
feature {NONE} -- Creation
	make_from_string_with_delimiters( a_string:STRING; the_delimiters:STRING ) is
			-- Setup a new text scanner
		require
			a_string /= void
			the_delimiters /= void
		do
			source := a_string
			delimiters := the_delimiters
			
			start_idx := next_start (1)
			
			create last_string.make_empty
		end

feature -- Does
	set_source_string( a_string:STRING ) is
			-- set a new source string
		require
			a_string /= void
		do
			source := a_string
			start_idx := next_start (1)
		ensure
			source = a_string
		end
		

	read_token is
			-- Read the next token
		local			
			finish_idx:INTEGER
		do
			finish_idx := next_finish (start_idx)
			
			last_string.set(source, start_idx, finish_idx)
			
			start_idx := next_start (finish_idx + 1)
		end

feature -- Access
	last_string : STRING
		-- last token
		
feature {NONE} --- Imlementation
	next_start (start_ix :  INTEGER) : INTEGER is
		do
			from
				Result := start_ix
			until
				(Result > source.count) or else not (delimiters.has(source @ Result))
			loop
				Result := Result + 1
			end
		end -- next_start

	next_finish (start_ix :  INTEGER) : INTEGER is
		do
			from
				Result := start_ix
			until
				(Result > source.count) or else delimiters.has(source @ Result)
			loop
				Result := Result + 1
			end
			Result := Result - 1
		end -- next_finish 

	find_next_delim (start:INTEGER) : INTEGER is
			-- Find the next delim.
			-- 0 if none is left.
		require
			start > 0
		local
			curr_delim:INTEGER
			curr_index:INTEGER
		do
			from
				curr_delim := 1
				result := source.count
			until
				curr_delim > delimiters.count
			loop
				curr_index := source.index_of (delimiters.item (curr_delim), start)
				if curr_index > 0 and curr_index < result then
					result := curr_index
				end
				
				curr_delim := curr_delim + 1
			end
			
			if result = source.count then
				result := 0
			end
		end
		
	source: STRING
		-- source string
	
	delimiters:STRING
		-- delims
		
	start_idx : INTEGER
	
invariant
	source /= void

end -- class Q_TEXT_SCANNER
