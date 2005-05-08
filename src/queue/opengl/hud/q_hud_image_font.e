indexing
	description: "A font made by a texture"
	author: "Benjamin Sigg"
	revision: "1.0"

class
	Q_HUD_IMAGE_FONT
	
inherit
	Q_HUD_FONT
	
creation
	make

feature{NONE} -- creation
	make( font_file_, image_file_ : STRING ) is
			-- font_file is a file listing all Letters in the format
			-- *c x y w h b
			-- where every letter stands on a new line.
			-- c is a Character
			-- x, y, w, and h the position and size of the character in the image (pixels)
			-- b the baseline. a value between 0 and height, for most characters, it will be equal to height
			--
			-- image_file is an image
		local
			shared_factory_ : ESDL_SHARED_BITMAP_FACTORY
			factory_ : ESDL_BITMAP_FACTORY
			gl_texture_ : INTEGER
			orakel_ : PLAIN_TEXT_FILE
			
			c_ : CHARACTER
			x_, y_, width_, height_, base_ : INTEGER
		do
			create shared_factory_
			create letters.make( 80 )
			factory_ := shared_factory_.bitmap_factory
			factory_.create_bitmap_from_image( image_file_ )
			gl_texture_ := factory_.last_bitmap.gl_texture_mipmap
			image_width := factory_.last_bitmap.width
			image_height := factory_.last_bitmap.height
			
			from
				create orakel_.make_open_read( font_file_ )
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
					x_ := orakel_.last_integer
				
--					orakel_.read_character
					orakel_.read_integer
					y_ := orakel_.last_integer
				
--					orakel_.read_character
					orakel_.read_integer
					width_ := orakel_.last_integer
				
--					orakel_.read_character
					orakel_.read_integer
					height_ := orakel_.last_integer
				
--					orakel_.read_character
					orakel_.read_integer
					base_ := orakel_.last_integer
					
					letters.force ( create{Q_HUD_IMAGE_LETTER}.make( x_, y_, width_, height_, base_, gl_texture_ ), c_ )
				end
			end
		end
		
feature{NONE} -- Implementation
	to_factor( size_ : DOUBLE ) : DOUBLE is
		do
			result := size_ / 64
		end
	
	image_width, image_height : INTEGER

feature -- Interface
	draw_letter( letter_ : CHARACTER; x_, base_, size_ : DOUBLE; open_gl : Q_GL_DRAWABLE;  ) is
		do
			letters.item( letter_ ).draw ( x_, base_, to_factor( size_ ), open_gl, image_width, image_height )
		end	
		
	width_of_letter( letter_ : CHARACTER; size_ : DOUBLE ) : DOUBLE is
		do
			result := letters.item( letter_ ).width * to_factor( size_ )
		end
	
	height_of_letter( letter_ : CHARACTER; size_ : DOUBLE ) : DOUBLE is
		do
			result := letters.item ( letter_ ).height * to_factor( size_ )
		end	
	
	base_of_letter( letter_ : CHARACTER; size_ : DOUBLE ) : DOUBLE is
		do
			result := letters.item ( letter_ ).base * to_factor( size_ )
		end	
	
	known_letter( letter_ : CHARACTER ) : BOOLEAN is
		do
			result := letters.has( letter_ )
		end

feature{NONE} -- letters
	letters : HASH_TABLE[ Q_HUD_IMAGE_LETTER, CHARACTER ]

end -- class Q_HUD_IMAGE_FONT
