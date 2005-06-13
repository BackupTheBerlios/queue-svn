indexing
	description: "An info-hud showing 2 labels, and a slider"
	author: "Benjamin Sigg"

class
	Q_TIME_INFO_HUD

inherit
	Q_HUD_CONTAINER
	redefine
		make, enqueue
	end

creation
	make
	
feature{NONE}
	make is
		local
			panel_ : Q_HUD_PANEL
			container_ : Q_HUD_CONTAINER_3D
		do
			precursor
			
			create loop_big_label.make
			create loop_big_slider.make
			create loop_small_label.make
			create loop_small_slider.make
			
			create big_label.make
			create big_slider.make
			create small_label.make
			create small_slider.make
			
			big_slider.set_enabled( false )
			small_slider.set_enabled( false )
			
			loop_big_label.add( big_label )
			loop_big_slider.add( big_slider )
			loop_small_label.add( small_label )
			loop_small_slider.add( small_slider )
			
			add( loop_big_label )
			add( loop_big_slider )
			add( loop_small_label )
			add( loop_small_slider )
			
			big_label.set_size( 0.4, 0.09 )
			small_label.set_size( 0.35, 0.05 )
			small_label.set_font_size( 0.025 )
			big_slider.set_size( 0.4, 0.09 )
			small_slider.set_size( 0.35, 0.05 )
			
			loop_big_label.set_bounds( 0, 0, 0.4, 0.09 )
			loop_small_label.set_bounds( 0.05, 0.1, 0.35, 0.05 )
			loop_big_slider.set_bounds( 0.5, 0, 0.4, 0.09 )
			loop_small_slider.set_bounds( 0.55, 0.1, 0.4, 0.05 )
			
			set_size( 0.9, 0.15 )

			set_time_cuts( 5 )
			set_time_max( 1000 )
			
			create container_.make
			container_.translate( 0, 0, -0.025 )
			add( container_ )
			
			create panel_.make
			panel_.set_size( 0.4, 0.15 )
			container_.add( panel_ )
			
			create panel_.make
			panel_.set_size( 0.4, 0.15 )
			panel_.set_x( 0.5 )
			container_.add( panel_ )
		end
		
feature{NONE}
	big_label, small_label : Q_HUD_LABEL	
	big_slider, small_slider : Q_HUD_SLIDER
	
	loop_big_label, loop_small_label, loop_big_slider, loop_small_slider : Q_HUD_LOOPING
	
feature -- text
	set_big_text( text_ : STRING ) is
		require
			text_ /= void
		do
			big_label.set_text( text_ )
			loop_big_label.looping
		end
		
	set_small_text( text_ : STRING ) is
		require
			text_ /= void
		do
			small_label.set_text( text_ )
			loop_small_label.looping
		end

feature -- time
	time_max : INTEGER
		-- whats the maximum time
		
	time_cuts : INTEGER
		-- in how many intervalls should the time be divided

	time : INTEGER
		-- current time

	set_time_max( time_ : INTEGER ) is
		require
			time_ > 0
		do
			time_max := time_

			small_slider.set_maximum( time_max // time_cuts )
			big_slider.set_maximum( time_max )
		end
		
	set_time_cuts( cuts_ : INTEGER ) is
		require
			cuts_ > 0
		do
			small_slider.set_maximum( time_max // cuts_ )
			
			time_cuts := cuts_
		end
		
	set_time( time_ : INTEGER ) is
		-- sets the current time.
		-- if the time is equal to the maximum-time, all elements will make a looping
		require
			time_ >= 0 and time_ <= time_max
		local
			small_old_, small_, big_ : INTEGER
		do
			if time_ /= time then
				if time_ = time_max then
					loop_big_label.force_looping
					loop_big_slider.force_looping
					loop_small_label.force_looping
					loop_small_slider.force_looping
				end
				
				small_ := time_ \\ (time_max // time_cuts)
				big_ := time_ - small_
				
				if time_ > time then
					-- perhaps a loop is needed
					small_old_ := time \\ (time_max // time_cuts)
					if small_old_ > small_ then
						loop_small_slider.looping
					end
				end
				
				small_slider.set_value( small_ )
				big_slider.set_value( big_ )
				
				time := time_
			end
		end
		
	
feature -- draw
	enqueue( queue_: Q_HUD_QUEUE ) is
		do
			queue_.push_matrix
			queue_.scale( 2, 2, 2 )
			queue_.translate( -0.25, 0, -0.5 )
			precursor( queue_ )
			queue_.pop_matrix
		end
		

end -- class Q_TIME_INFO_HUD
