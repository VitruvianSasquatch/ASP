require("strong")

function xor(stat1, stat2)
	if not (stat1 and stat2) or stat1 and stat2 then
		return false
	else
		return true
	end
end

function round(float)
	if float - math.floor(float) >= 0.5 then return math.floor(float)+1 else return math.floor(float) end
end

function love.load()
	config = love.filesystem.read("config.txt", all)
	config = config:split("\n")
	dimx = tonumber(config[1] - "dimx = ")
	dimy = tonumber(config[2] - "dimy = ")
	love.graphics.setBackgroundColor(200, 200, 200, 255)
	xinimg = math.floor(dimx/2)
	yinimg = math.floor(dimy/2)
	lefttool = "pencil" --also can have "harderaser", "softeraser", "brush", "picker", "bucket", "line", etc
	righttool = "harderaser"
	ctrltool = "picker"
	drawcolour = {0, 0, 0, 255}
	prevx = nil --first coords for line drawing
	prevy = nil
	state = "draw" --can have "load", "save" and "option" also
	scrollspeed = 1
	zoom = 1
	newfile(dimx,dimy)
end

function newfile(width,height)
	dimx = width
	dimy = height
	image = love.image.newImageData(dimx, dimy)
	zoom = 1
	vx = 0--viewport x
	vy = 0--viewport y
	selectedcolour = {0,0,0,255}
	updateimage()
end

function save(filepath, filename)
	love.filesystem.write(filename, image:encode('png'), all)
end

function open(filepath)
	imagedata = love.filesystem.read(filepath, all)
	image = love.image.newImageData
	dimx = (image):getWidth()
	dimy = (image):getHeight()
	zoom = 1
	state = "draw"
	updateimage()
end

function pencil(x, y, colour)
	image:setPixel(x, y, colour[1], colour[2], colour[3], colour[4])
end

function harderaser(x, y)
	image:setPixel(x, y, 0, 0, 0, 0)
end

function line(x1, y1, x2, y2, colour)
	local m = (y1-y2)/(x1-x2)
	if m <= 1 and m>= -1 then --|deltax| >= |deltay| (iternate x values)
		if x1 <= x2 then --going right (x++)
			for x=0, x2-x1 do
				image:setPixel(x1+x, y1+round(x*m), colour[1], colour[2], colour[3], colour[4])
			end
		else --going left (x--)
			for x=0, x2-x1, -1 do
				image:setPixel(x1+x, y1+round(x*m), colour[1], colour[2], colour[3], colour[4])
			end
		end
	else --ergo, |deltax| <= |deltay| (iternate y values)
		if y1 <= y2 then --going down (y++)
			for y=0, y2-y1 do
				image:setPixel(x1+round(y/m), y1+y,  colour[1], colour[2], colour[3], colour[4])
			end
		else --going up (y--)
			for y=0, y2-y1, -1 do
				image:setPixel(x1+round(y/m), y1+y, colour[1], colour[2], colour[3], colour[4])
			end
		end
	end
end

-- old function
--function editimg(colour)
--	if mx > 64 and mx < dimx*zoom+64 and my > 0 and my < dimy*zoom then
--		data[math.ceil((mx-64)/zoom)][math.ceil(my/zoom)] = colour
--	end
--end

function updateimage()
	imagefile = love.graphics.newImage(image)
	imagefile:setFilter("nearest","nearest")
end

function love.update(dt)
	mx = love.mouse.getX()-64
	my = love.mouse.getY()
	xinimg = math.floor((mx-vx)/zoom)
	yinimg = math.ceil((my-vy)/zoom)
	if love.mouse.isDown("l") then
		if lefttool == "pencil" then pencil(xinimg, yinimg, drawcolour) end
		if lefttool == "harderaser" then harderaser(xinimg, yinimg) end
		if (lefttool == "line" or (love.keyboard.isDown("lshift"))) and prevx ~= nil and prevy ~=nil then line(prevx, prevy, xinimg, yinimg, drawcolour) end
		prevx = xinimg
		prevy = yinimg
		updateimage()
	end
	if love.mouse.isDown("r") then
		if righttool == "pencil" then pencil(xinimg, yinimg, drawcolour) end
		if righttool == "harderaser" then harderaser(xinimg, yinimg) end
		updateimage()
		--edit the image to {0,0,0,0}
	end
	if love.keyboard.isDown("left") then vx = vx - scrollspeed end
	if love.keyboard.isDown("right") then vx = vx + scrollspeed end
	if love.keyboard.isDown("up") then vy = vy - scrollspeed end
	if love.keyboard.isDown("down") then vy = vy + scrollspeed end
	--correctviewport()
end

function correctviewport() --haven't tested this yet, but hopefully it'll work
	if vx < 0 then vx = 0 end
	if vx > dimx*zoom-love.graphics.getWidth()-64 then vx = vx > dimx*zoom-love.graphics.getWidth()-64 end
	if vy < 0 then vy = 0 end
	if vy > dimy*zoom-love.graphics.getHeight()-64 then vy = vy > dimy*zoom-love.graphics.getHeight()-64 end
end

function love.draw()
	love.graphics.rectangle("line",64,0,dimx*zoom,dimy*zoom)
	love.graphics.draw(imagefile, 64+vx, vy, 0, zoom, zoom)
	--draw imagedata at 64,0,0,zoom,zoom
end

function love.mousepressed(x,y,button)
	if button == "wu" and love.keyboard.isDown("lctrl") then
		zoom = zoom * 2
	end
	if button == "wd" and love.keyboard.isDown("lctrl") then
		zoom = zoom / 2
	end
end