local QUIT = false


function love.load()
        arenaWidth = 800
        arenaHeight = 600

        -- KEYBOARD KEYS
        keys = {}
        keys.vim = true
        if keys.vim then
                keys.left       = {"h", "left"}
                keys.right      = {"l", "right"}
        else
                keys.left       = "left"
                keys.right      = "right"
        end
        keys.up         = {"w"}
        keys.down       = {"r", "s"}
        keys.exit = "q"

        player = {}
        player.x = arenaWidth / 2
        player.y = arenaHeight / 2
        player.r = 30   -- player radius
        player.a = 0    -- player angle
        player.turnSpeed = 10
        player.speedX = 10
        player.speedY = 0

        back = {}
        back.x = 0
        back.y = 0

        move = true
        debug = {}
        debug.main = true
        debug.vector = true
        debug.numbers = true

        -- FOR QUICKLY TURRNING BACKWARDS
        down = true
end



function love.update(dt)
        if player.speedX > 1000 or player.speedX < -1000
                or player.speedY > 1000 or player.speedY < -1000 then -- DEATH
                player.speedX = 0
                player.speedY = 0
        end

        local shipSpeed = 100
        if love.keyboard.isDown('q') then
                if QUIT == false then
                        QUIT = true
                else
                        QUIT = false
                end
                love.timer.sleep(0.25)
        elseif not QUIT then -- IF QUIT MENU THEN STOP
                if move then
                        if love.keyboard.isDown(keys.down) and down == true then -- TURNS 180 DEGREES
                                player.a = player.a + (math.pi)
                                back.x = player.speedX + math.cos(player.a)
                                back.y = player.speedY + math.sin(player.a)
                                down = false
                        elseif love.keyboard.isDown(keys.down) then -- CONTINUED PRESS ADDS VOLOCITY
                                local shipSpeed2 = shipSpeed*1.2 -- Back wards is faster
                                player.speedX = back.x * shipSpeed2 * dt
                                player.speedY = back.y * shipSpeed2 * dt
                        elseif love.keyboard.isDown(keys.up) then -- ADD VELOCITY
                                down = true
                                player.speedX = player.speedX + math.cos(player.a) * shipSpeed * dt
                                player.speedY = player.speedY + math.sin(player.a) * shipSpeed * dt
                        elseif love.keyboard.isDown(keys.right) then
                                player.a = player.a + player.turnSpeed * dt
                        elseif love.keyboard.isDown(keys.left) then
                                player.a = player.a - player.turnSpeed * dt
                        end
                end

                -- WRAPPING THE SHIP ANGLE
                if down == true then
                        player.a = player.a % (2 * math.pi)
                end

                player.x = player.x + player.speedX * dt
                player.y = player.y + player.speedY * dt

                -- WRAPPING SHIP
                player.x = (player.x + player.speedX * dt) % arenaWidth
                player.y = (player.y + player.speedY * dt) % arenaHeight
        end
end



function love.draw()
        globalDark = {0, 0, 0, 1}
        globalLight = {0, 0, 1, 1}
        globalGreen = {0, 1, 0, 1}

        -- GLOBAL COLOR
        love.graphics.setColor(globalLight)

        -- IF IN PAUSE MENU TURN GLOBAL RED
        if QUIT == true then
                globalLight = {1, 0, 0, 1}
                globalGreen = {1, 1, 1, 1}
                local Rwidth = 250
                love.graphics.setColor(1, 0, 0)
                love.graphics.rectangle("fill", arenaWidth-Rwidth, 0, Rwidth, 25)
        end

        -- PLAYER
        love.graphics.circle( 'fill', player.x, player.y, player.r )

        love.graphics.setColor(globalGreen)
        shipDistance = 20
        love.graphics.circle( 'fill',
                player.x + math.cos(player.a) * shipDistance,
                player.y + math.sin(player.a) * shipDistance,
                5
        )

        -- DEBUG {{{
        if debug.main then
                if debug.vector then
                        -- DIRECTION VECTOR
                        love.graphics.setColor(0, 1, 0, 0.5)
                        love.graphics.circle( 'fill',
                                player.x, player.y,
                                (player.speedY)/4
                        )
                        love.graphics.setColor(1, 0, 0, 0.5)
                        love.graphics.circle( 'fill',
                                player.x, player.y,
                                (player.speedX)/4
                        )
                end 

                if debug.numbers then
                        -- NUMBERS
                        love.graphics.setColor(globalLight)
                        love.graphics.print(table.concat({
                                'shipAngle: '..player.a,
                                'shipX: '..player.x,
                                'shipY: '..player.y,
                                'shipSpeedX: '..player.speedX,
                                'shipSpeedY: '..player.speedY,
                                'randomSeed: '..math.random(os.time())
                        }, '\n'))
                end
        end
        -- }}}
end

function love.quit()
        if not QUIT then
                return true
        else
                return false
        end
end
