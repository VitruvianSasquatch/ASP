function love.load()
	config = love.filesystem.read("config.txt", all)
	--img = love.image.newImageData(, )
	state = "draw" --can have "load", "save" and "option" also
	scrollspeed = 1
	newfile(32,32)
end

function newfile(width,height)
	--initialise new image of width width and height height
	dimx = width
	dimy = height
	zoom = 1
	vx = 0 --viewport x
	vy = 0 -- viewport y
	selectedcolour = {0,0,0,255}
end

-- old function
--function editimg(colour)
--	if mx > 64 and mx < dimx*zoom+64 and my > 0 and my < dimy*zoom then
--		data[math.ceil((mx-64)/zoom)][math.ceil(my/zoom)] = colour
--	end
--end

function love.update(dt)
	mx = love.mouse.getX()+64
	my = love.mouse.getY()
	if love.mouse.isDown("l") then
		--edit the image at the mouse location to the selected colour
		--x value = math.ceil((mx-vx)/zoom)
		--y value = math.ceil((my-vy)/zoom)
	end
	if love.mouse.isDown("r") then
		--edit the image to {0,0,0,0}
	end
	if love.keyboard.isDown("left") then vx = vx - scrollspeed end
	if love.keyboard.isDown("right") then vx = vx + scrollspeed end
	if love.keyboard.isDown("up") then vy = vy - scrollspeed end
	if love.keyboard.isDown("down") then vy = vy + scrollspeed end
	correctviewport()
end

function correctviewport() --haven't tested this yet, but hopefully it'll work
	if vx < 0 then vx = 0 end
	if vx > dimx*zoom-love.graphics.getWidth()-64 then vx = vx > dimx*zoom-love.graphics.getWidth()-64 end
	if vy < 0 then vy = 0 end
	if vy > dimy*zoom-love.graphics.getHeight()-64 then vy = vy > dimy*zoom-love.graphics.getHeight()-64 end
end

function love.draw()
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