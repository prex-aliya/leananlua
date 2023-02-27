local QUIT = false


function love.load()
        arenaWidth = 800
        arenaHeight = 600

        y = 20

        player = {}
        player.x = arenaWidth / 2
        player.y = arenaHeight / 2
        player.r = 30   -- player radius
        player.a = 0    -- player angle
        player.turnSpeed = 10
        player.speedX = 10
        player.speedY = 0

        move = true
        debug = true
end



function love.update(dt)
        if love.keyboard.isDown('q') then
                if QUIT == false then
                        QUIT = true
                else
                        QUIT = false
                end
                love.timer.sleep(0.25)
        elseif not QUIT then -- IF QUIT MENU THEN STOP
                if move then
                        if love.keyboard.isDown("up") then
                                local shipSpeed = 100
                                player.speedX = player.speedX + math.cos(player.a) * shipSpeed * dt
                                player.speedY = player.speedY + math.sin(player.a) * shipSpeed * dt
                        elseif love.keyboard.isDown("right") then
                                player.a = player.a + player.turnSpeed * dt
                        elseif love.keyboard.isDown("left") then
                                player.a = player.a - player.turnSpeed * dt
                        end
                end

                -- WRAPPING THE SHIP ANGLE
                player.a = player.a % (2 * 3)

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

        -- DEBUG
        if debug then
                love.graphics.setColor(globalLight)
                love.graphics.print(table.concat({
                        'shipAngle: '..player.a,
                        'shipX: '..player.x,
                        'shipY: '..player.y,
                        'shipSpeedX: '..player.speedX,
                        'shipSpeedY: '..player.speedY,
                }, '\n'))
        end
end

function love.quit()
        if not QUIT then
                return true
        else
                return false
        end
end
