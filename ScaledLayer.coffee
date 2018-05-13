###

Class for scaling layers to specific visual sizes (rather than by percentage). Good for images, especially in Chrome, where sized images are often blurry. Also, scaling is generally more performant than sizing, and layers with text and shapes will scale their text/shapes.

NOTE If you size the layer AFTER creating the layer (i.e., beyond the initial sizing passed to the constructor) the layer's underlying size will change, but its apparent size will be the same (although if it's an image it may make it blurry), as the scaling will automatically adjust to how the layer was defined. (There really isn't a point to sizing here.)

Do NOT use any scaling commands on the layer itself.

Properties:
=======================================
You can get or set the properties below

  .scaleWidth: how wide the layer should appear when scaled
  .scaleHeight: how tall the layer should appear when scaleFrame
  .scaleSize: the apparent size of the scaled layer
  .scaleFrame: the apparent frame of the scaled layer
  
### 

class exports.ScaledLayer extends Layer
	constructor: (@options = {}) ->
		super @options
		@originX = @originY = 0
		@scale = 1
		# check if coder passed in an scaleSizing parameters;
		# if not, store the current width as the scaled width.
		if @scaleX is 1
			@options.scaleWidth = @width
		if @scaleY is 1
			@options.scaleHeight = @height
		@on "change:size", ->
			@scaleSize = 
				width: @options.scaleWidth
				height: @options.scaleHeight
				
	# sets scaleWidth to width while maintain aspect ratio
	scaleByWidth: (width) ->
		@scaleWidth = width
		@scaleHeight = width * @height/@width
	
	# sets scaleHeight to height. while maintaining aspect ratio
	scaleByHeight: (height) ->
		@scaleWidth = height * @width/@height	
		@scaleHeight = height
	
	toInspect: ->
		"<#{@constructor.name} #{@toName()} id:#{@id} (#{@x}, #{@y}) #{@width}x#{@height} scaleSize:#{Utils.round @scaleWidth, 3}x#{Utils.round @scaleHeight, 2} scaleX:#{Utils.round @scaleX, 2}, scaleY:#{Utils.round @scaleY, 2}>"

	
	# if you want to reassert the underlying layer size
	# scaling will be set to 1 when done
	resetLayerSize: (size) ->
		size = Utils.size size
		print @options.scaleWidth = size.width
		print @options.scaleHeight = size.height
		@scaleX = 1
		@scaleY = 1
		print @size
		print @size = size
				
	@define "scaleWidth",
		get: -> 
			@scaledFrame().width
		set: (value ) -> 
			@scaleX = value/@width
			@options.scaleWidth = value
	@define "scaleHeight",
		get: -> 
			@scaledFrame().height
		set: (value) -> 
			@scaleY = value/@height
			@options.scaleHeight = value
	@define "scaleSize",
		get: -> 
			Utils.size @scaledFrame()
		set: (value) ->
			value = Utils.size value
			@scaleWidth = @options.scaleWidth = value.width
			@scaleHeight = @options.scaleHeight = value.height
	@define "scaleFrame",
		get: -> 
			@scaledFrame()
		set : (value) ->
			value = Utils.frame value
			@x = value.x
			@y = value.y
			@scaleWidth @options.scaleWidth = value.width
			@scaleHeight = @options.scaleHeight = value.height
