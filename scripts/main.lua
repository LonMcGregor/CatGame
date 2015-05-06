--Cube platformer thing

--import objects
cat = getObject('cat')
floor = getObject('floor')
text = getObject('text0')
thumper = getObject('thumper')
fin = getObject('fins')
cam0 = getObject('Camera0')
fish = {}
can = {}
enemy = {}
enemyT = {}
enemyF = {}
enemyCanRotating = {}
edibleObjects = {fish, can}
score = 0
level = 0
lives = 9
notfinished = true
FISH_SCORE = 3
CAN_SCORE = 6
JUMP_HEIGHT = 5

print '\n\n\nstarting level\n'


--init fish, cans
for i = 0, 5 do
	string = "fish"..i
	if pcall(function() getObject(string) end) then--check if this fish exists before adding
		fish[i] = getObject(string)
	else
	end
end
for i = 0, 5 do
	string = "can"..i
	if pcall(function() getObject(string) end) then
		can[i] = getObject(string)
	else
	end
end
for i = 0, 5 do
	string = "enemy"..i
	if pcall(function() getObject(string) end) then
		enemy[i] = getObject(string)
		enemyCanRotating[i] = 0
	else
	end
end
for i = 0, 5 do
	string = "eT"..i
	if pcall(function() getObject(string) end) then
		enemyT[i] = getObject(string)
	else
	end
end
for i = 0, 5 do
	string = "eF"..i
	if pcall(function() getObject(string) end) then
		enemyF[i] = getObject(string)
	else
	end
end

--reset cursor
centerCursor()
hideCursor()

function onSceneUpdate()
	
	if notfinished then checkMovement() end
	doAnimateItems()
	checkCollisions()
	moveEnemy()
	updateText()
	detectEnd()
	
end

function checkMovement()
	if isKeyPressed("A") then translate(cat, {0,-0.1,0}, 1, "local" ) end
	if isKeyPressed("D") then translate(cat, {0,0.1,0}, 1, "local" ) end
	
	grounded = getNumCollisions(thumper)
	if isKeyPressed("SPACE") then
		if grounded > 1 then addCentralForce(cat, {0,0,JUMP_HEIGHT}) end
	end
end

function doAnimateItems()
	for i = 0, table.getn(fish) do
		rotate(fish[i], {0,0,0.1}, 1, "global")
	end
	for i = 0, table.getn(can) do
		rotate(can[i], {0,0,-0.1}, 1, "local")
	end
end

function checkCollisions()
	for i = 0, table.getn(fish) do
		if isCollisionBetween(fish[i], cat) then
			deactivate(fish[i])
			score = score+FISH_SCORE
		end
	end
	for i = 0, table.getn(can) do
		if isCollisionBetween(can[i], cat) then
			deactivate(can[i])
			score = score+CAN_SCORE
		end
	end
	for i = 0, table.getn(enemyF) do
		if isCollisionBetween(enemyF[i], cat) then
			setScale(enemy[i], {1,1,0.5})
			addCentralForce(cat, {0,0,JUMP_HEIGHT*2})
			deactivate(enemy[i])
			deactivate(enemyF[i])
			deactivate(enemyT[i])
			score = score + 5
		elseif isCollisionBetween(enemy[i], cat) then
			addCentralForce(cat, {-1,-1,JUMP_HEIGHT})
		end
	end
end

function moveEnemy()
	for i = 0, table.getn(enemy) do
		cols = getNumCollisions(enemyT[i])
		if (cols == 0) then
			if (enemyCanRotating[i] == 0) then
				rotate(enemy[i], {0,0,1}, 180, "local")
				enemyCanRotating[i] = 10
			else
				enemyCanRotating[i] = enemyCanRotating[i] - 1
			end
		end
		translate(enemy[i], {0,-0.05,0}, "local")
	end
end

function detectEnd()
	if isCollisionBetween(cat, floor) then resetPlayer() end
	if isCollisionBetween(cat, fin) then
		endSequence()
	end
end

function endSequence()
	notfinished = false
	translate(cam0, {-0.1, 0, -0.03}, 1, "local")
	pos = getPosition(cam0)
	if (pos[1] < 10) then quit() end
end

function updateText()
	newText = 'Level\t' .. level .. '\nScore\t' .. score .. '\nLives\t' .. lives
	setText(text, newText)
end

function resetPlayer()
	setPosition(cat, {0,0,3.16})
	lives = lives - 1
	if (lives == 0) then quit() end
end