indexing
	description: "A font made by a texture"
	author: "Benjamin Sigg"
	revision: "1.0"

class
	Q_HUD_IMAGE_FONT
	
inherit
	Q_HUD_FONT
	
creation
	make,
	make_standard

feature{NONE} -- creation
	make_standard( font_ : STRING; size_ : INTEGER; bold_, italic_ : BOOLEAN ) is
			-- Searches in the data/font folder for a font descriping the given parameters
		local
			id_ : STRING
			txt_, img_ : STRING
		do
			id_ := ""
			id_.append( font_ )
			id_.append( "_" )
			id_.append_integer( size_ )
			id_.append( "_" )
			
			if bold_ then
				id_.append( "b" )
			end
			
			if italic_ then
				id_.append( "i" )
			end
			
			txt_ := "data/font/"
			img_ := "data/font/"
			
			txt_.append( id_ )
			txt_.append( ".txt" )
			
			img_.append( id_ )
			img_.append( ".png" )
			
			make( txt_, img_ )
		end
		

	make( font_file_, image_file_ : STRING ) is
			-- font_file is a file listing all Letters in the format
			-- *c xt yt wt ht w h b
			-- where every letter stands on a new line.
			-- c is a Character
			-- xt, yt, wt, and ht the position and size of the character in the image (pixels)
			-- w, h the real size of the letter.
			-- b the baseline. a value between 0 and height, for most characters, it will be 0
			--
			-- image_file is an image
		local
			orakel_ : PLAIN_TEXT_FILE
			
			c_ : CHARACTER
			x_t_, y_t_, width_t_, height_t_, width_, height_, base_ : INTEGER
		do
--			create texture.make( image_file_ ) 
			create texture.make_with_colorkey ( image_file_, 1, 1, 1 )

			create letters.make( 80 )

			image_width := texture.width 
			image_height := texture.height
			
			from
				create orakel_.make_open_read( font_file_ )
				factor := 0
			until
				orakel_.end_of_file
			loop
				from
				until
					orakel_.end_of_file or c_ = '*'
				loop
					orakel_.read_character
					c_ := orakel_.last_character
				end
				
				if not orakel_.end_of_file then				
					orakel_.read_character
					c_ := orakel_.last_character
				
					orakel_.read_character
					orakel_.read_integer
					x_t_ := orakel_.last_integer

					orakel_.read_integer
					y_t_ := orakel_.last_integer
				
					orakel_.read_integer
					width_t_ := orakel_.last_integer
				
					orakel_.read_integer
					height_t_ := orakel_.last_integer

					orakel_.read_integer
					width_ := orakel_.last_integer
					
					orakel_.read_integer
					height_ := orakel_.last_integer					
				
					orakel_.read_integer
					base_ := orakel_.last_integer
					
					letters.force ( create{Q_HUD_IMAGE_LETTER}.make( 
						x_t_, y_t_, width_t_, height_t_, 
						width_, height_, base_, texture.id ), c_ )
					
					factor := factor.max( height_ )
				end
			end
		end
		
feature{NONE} -- Implementation
	to_factor( size_ : DOUBLE ) : DOUBLE is
		do
			result := size_ / factor
		end
	
	image_width, image_height : INTEGER
	
	factor : INTEGER

feature -- Interface
	letter_list : ARRAY[ CHARACTER ] is
		local
			index_ : INTEGER
		do
			create result.make( 0, letters.count-1 )
			
			from
				letters.start
				index_ := result.lower
			until
				letters.after
			loop
				result.put( letters.key_for_iteration, index_ )
				index_ := index_ + 1
				letters.forth
			end
		end
		

	draw_letter( letter_ : CHARACTER; x_, base_, size_ : DOUBLE; open_gl : Q_GL_DRAWABLE;  ) is
		do
			letters.item( letter_ ).draw ( x_, base_, to_factor( size_ ), open_gl, image_width, image_height )
		end	
		
	width( letter_ : CHARACTER; size_ : DOUBLE ) : DOUBLE is
		do
			result := letters.item( letter_ ).width * to_factor( size_ )
		end
	
	height( letter_ : CHARACTER; size_ : DOUBLE ) : DOUBLE is
		do
			result := letters.item ( letter_ ).height * to_factor( size_ )
		end	
	
	base( letter_ : CHARACTER; size_ : DOUBLE ) : DOUBLE is
		do
			result := letters.item ( letter_ ).base * to_factor( size_ )
		end	
	
	known_letter( letter_ : CHARACTER ) : BOOLEAN is
		do
			result := letters.has( letter_ )
		end

feature{NONE} -- Letters
	letters : HASH_TABLE[ Q_HUD_IMAGE_LETTER, CHARACTER ]

feature -- Texture
	texture : Q_GL_TEXTURE

end -- class Q_HUD_IMAGE_FONT
