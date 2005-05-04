indexing

	description:
		"splits a string into tokens%
		%string consists of tokens and delimiters"
	date: 
		"November, 1996"
	author: 
		"David Clark%
		%University of Canberra"

class STRING_TOKENIZER

creation
	make, make_exclude_delimiters, make_include_delimiters

feature -- creation
	make, make_exclude_delimiters (str_, delimiters_ : STRING) is
	-- extract tokens, excluding delimiters
	require
		string_exists : str_ /= Void
		delimiters_exists : delimiters_ /= Void
	do
		count := 0
		str := str_
		delimiters := delimiters_
		extract_tokens_exclude
		start
	end -- make

	make_include_delimiters (str_, delimiters_ : STRING) is
	-- extract tokens, including delimiters
	require
		string_exists : str_ /= Void
		delimiters_exists : delimiters_ /= Void
	do
		count := 0
		str := str_
		delimiters := delimiters_
		extract_tokens_include
		start
	end -- make

feature -- change
	start is
	do
		idx := 1
	end -- start

	forth is
	do
		idx := idx + 1
	end -- forth

feature -- status
	empty : BOOLEAN is
	-- are there any tokens?
	do
		Result := (count = 0)
	end		

	off : BOOLEAN is
	do
		Result := (idx > count)
	end -- off

	item : STRING is
	require
		active_item: not off and not empty
	do
		Result := tokens @ idx
	end -- next_token

	i_th, infix "@" (ix : INTEGER) : STRING is
	-- the i_th token
	require
		valid_index: (ix >= 1) and (ix <= count)
	do
		Result := tokens @ ix
	end -- i_th


feature {NONE} -- implementation
	str : STRING
	delimiters : STRING
	idx : INTEGER -- index of current token

	next_start (start_ix :  INTEGER) : INTEGER is
	do
		from
			Result := start_ix
		until
			(Result > str.count) or else not (delimiters.has(str @ Result))
		loop
			Result := Result + 1
		end
	end -- next_start

	next_finish (start_ix :  INTEGER) : INTEGER is
	do
		from
			Result := start_ix
		until
			(Result > str.count) or else delimiters.has(str @ Result)
		loop
			Result := Result + 1
		end
		Result := Result - 1
	end -- next_finish 

	extract_tokens_exclude is
	-- extract the tokens excluding delimiters
	local
		ll : LINKED_LIST [STRING]
		start_idx, finish_idx : INTEGER
	do
		create ll.make
		from
			start_idx := next_start (1)
		until
			start_idx > str.count
		loop
			count := count + 1
			finish_idx := next_finish (start_idx)
			ll.extend (str.substring (start_idx, finish_idx))
			start_idx := next_start (finish_idx + 1)
		end
		to_array (ll)
	end -- extract_tokens_exclude

	extract_tokens_include is
	-- extract the tokens including delimiters
	local
		ll : LINKED_LIST [STRING]
		start_idx, finish_idx : INTEGER
	do
		create ll.make
		from
			start_idx := next_start (1)
			if (start_idx > 1) and (str.count > 0) then 
				ll.extend (str.substring (1, start_idx - 1))
				count := count + 1
			end
		until
			start_idx > str.count
		loop
			finish_idx := next_finish (start_idx)
			ll.extend (str.substring (start_idx, finish_idx))
			count := count + 1
			start_idx := next_start (finish_idx + 1)
			if (finish_idx < str.count) then
				ll.extend (str.substring (finish_idx + 1, start_idx - 1))
				count := count + 1
			end
		end
		to_array (ll)
	end -- extract_tokens_include 

	to_array (ll : LINKED_LIST [STRING]) is
	-- convert linked list to array
	local
		ix : INTEGER
	do
		if not empty then
			!!tokens.make (1, count)
			from
				ll.start
				ix := 1
			until
				ll.off
			loop
				tokens.put (ll.item, ix)
				ll.forth
				ix := ix + 1
			end
		end
	end -- to_array

feature

	tokens : ARRAY [STRING] -- the tokens

	count : INTEGER -- how many tokens?

end