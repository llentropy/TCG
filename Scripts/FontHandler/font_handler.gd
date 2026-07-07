extends RichTextLabel


func _ready() -> void:
	# 1. Get the font resource overriding this label
	var img_font = get_theme_font("font")
	
	if img_font is FontFile:
		var space_code = 32          # Unicode value for the space bar
		var custom_space_width = 3  # Your desired space width in pixels
		
		# 2. Clear any automatic/default spacing for the space character
		img_font.set_glyph_advance(space_code, 0, Vector2(custom_space_width, 0))
		
		# 3. Force the label to update and redraw its text layout
		queue_redraw()
