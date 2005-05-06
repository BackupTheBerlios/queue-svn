indexing
	description: "The Live-Manager has a set of livables. If a livable does not tell, that it is alive, the manager will call a death-feature"
	author: "Benjamin Sigg"

class
	Q_GL_LIVE_MANAGER

creation
	make

feature{NONE} -- creation
	make is
		do
			create livables.make( 10 )
		end
		

feature -- managing
	alive( livable_ : Q_GL_LIVABLE ) is
		require
			livable_not_void : livable_ /= void
		do
			livables.force( true, livable_ )	
		end
		
	grow is
			-- Sets the alive-state of all known livables to false.
			-- If they do not call the alive-feature, they will be killed
			-- by the next kill-call
		do
			from
				livables.start
			until
				livables.after
			loop
				livables.replace( false, livables.key_for_iteration )
				livables.forth
			end
		end
		
	
	kill is
			-- kills all livables witch did not call alive, since the last grow-call
		do
			from
				livables.start
			until
				livables.after
			loop
				if livables.item_for_iteration then
					livables.forth
				else
					livables.remove( livables.key_for_iteration )
				end
			end
		end
		

feature {NONE} -- internals
	livables : HASH_TABLE[ BOOLEAN, Q_GL_LIVABLE ]

end -- class Q_GL_LIVE_MANAGER
