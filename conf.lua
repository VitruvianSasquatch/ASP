if not love.filesystem.exists("config.txt") then
	local defaultdata = love.filesystem.read("data/default.txt", all)
	love.filesystem.write("config.txt", defaultdata, all)
end
	