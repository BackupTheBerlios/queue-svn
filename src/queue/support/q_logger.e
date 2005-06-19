indexing
	description: "A general purpose logger for debugging in finalized mode"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_LOGGER

create
	make
	
feature -- creation

	make is
			-- create a log file with default filename overwrite old file if necessary
		do
			make_file ("log.txt")
		end
		
	make_file (fn_: STRING) is
			-- log into file fn_
		do
			create file.make_open_write (fn_)
		end
		
feature -- logging
	
	log(classname_: STRING; feature_name_: STRING; message_ : STRING) is
			-- make log entry with time date class and feature name
		local
			time_ : TIME
			date_ : DATE
		do
			create time_.make_now
			create date_.make_now
			file.put_string (date_.out +" "+ time_.out+" "+classname_+"."+feature_name_+": "+ message_)
			file.new_line
			file.flush
		end
		
feature -- closing
	close is
			-- close the logger
		do
			file.flush
			file.close
		end
		

feature {NONE} -- implementation

	file : PLAIN_TEXT_FILE
	
end -- class Q_LOGGER
