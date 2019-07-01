#Sprites: https://archives.bulbagarden.net/wiki/Category:Yellow_sprites
#BackSprites: https://pkmn.net/?action=content&page=viewpage&id=8561

def defaults args

    #Base coordinates for the pokemon banners left/right of the pokemon
    args.state.pokemon1x ||= 200
    args.state.pokemon1y ||= 700
    args.state.pokemon2x ||= 750
    args.state.pokemon2y ||= 475

    #Pokeball coordinates located in the menu
    args.state.pokeballPlacementX ||= [840]
    args.state.pokeballPlacementY ||= [50, 153]
    args.state.pokeballState ||= 1                        #1 is on Fight. 0 is on Item

    args.state.pokeballPlacementFightX ||= [140, 540, 940]
    args.state.pokeballPlacementFightY ||= [50, 153]
    args.state.pokeballPlacementFightStatus ||= [0, 1]    #Holds the index values for the placements

    args.state.pokeballPlacementItemY ||= [50, 153]
    args.state.pokeballPlacementItemStatus ||= 1

    #Menu status booleans
    args.state.choseItem  ||= false
    args.state.choseFight ||= false

    #Weird matrix used for conversion because of the implementation I used in lines 17-19
    args.state.movematrix ||= [ [1, 0], [3, 2] ]

    #Battle variables
    args.state.moveChosen ||= -1
    args.state.moveChosenOpponent ||= -1
    args.state.mypokemonfirst ||= false
    args.state.completedCalc ||= false
    args.state.battleOrder ||= false

    #Items
    args.state.potionQuantity ||= 2
    args.state.chosePotion ||= false

    #Battle Order Vals
    args.state.frameDuration ||= 1.5 * 60
    args.state.mypokemonAnimation ||= 0
    args.state.otherpokemonAnimation ||= 0
    args.state.unaffectedAnimation ||= args.state.frameDuration
    args.state.hpIncreaseIter ||= 0
    args.state.statChangeDuration ||= 1.5 * 60
    args.state.myStatIter ||= 0
    args.state.opponentStatIter ||= 0
    args.state.faintedIter ||= 0
    args.state.faintedDuration ||= 1.5 * 60

    #Health Bar Colors
    args.state.greenBar ||= [0, 255, 0]
    args.state.yellowBar ||= [255, 255, 0]
    args.state.redBar ||= [255, 0, 0]

    args.state.scene ||= :game
    args.state.endgameIter ||= 0

    #Generating entities for my pokemon and opponent pokemon. The map function goes through each iteration of the matrix given.
    #In the map, basic parameters are defined.
    args.state.pokemon ||= [
        [:charmander, 250, 250, 250, 250, true],
        [:bulbasaur,  825, 475, 300, 300, false]
    ].map do |name, x, y, width, height, mypokemon|
        args.state.new_entity(name) do |p|
        p.name = name.capitalize
        p.x = x
        p.y = y
        p.width = width
        p.height = height
        p.hp = 100
        p.finalhp = 100           #Supposed to be equal to currenthp. allows for smooth decrease of health bar
        p.currenthp = 100
        p.level = 5
        p.attack = 0
        p.defense = 0
        if mypokemon
            p.sprite = "sprites/" + name.to_s + "back.png"
        else
            p.sprite = "sprites/" + name.to_s + ".png"
        end
        end
    end

    args.state.moveset0 ||= [
        [:ember, 30, 0, 0, 0, 0, false],
        [:scratch, 20, 0, 0, 0, 0, false],
        [:leer, 0, 0, 10, 0, 0, false],
        [:protect, 0, 0, 0, 0, 0, true]
    ].map do |name, attack, aBoost, aLower, dBoost, dLower, pro|
        args.state.new_entity(name) do |m|
        m.name = name.capitalize
        m.attack = attack
        m.aBoost = aBoost
        m.aLower = aLower
        m.dBoost = dBoost
        m.dLower = dLower
        m.protect = pro
        end
    end

    args.state.moveset1 ||= [
        [:growl, 0, 0, 0, 0, 10, false],
        [:vinewhip, 30, 0, 0, 0, 0, false],
        [:tackle, 20, 0, 0, 0, 0, false],
        [:protect, 0, 0, 0, 0, 0, true]
    ].map do |name, attack, aBoost, aLower, dBoost, dLower, pro|
        args.state.new_entity(name) do |m|
        m.name = name.capitalize
        m.attack = attack
        m.aBoost = aBoost
        m.aLower = aLower
        m.dBoost = dBoost
        m.dLower = dLower
        m.protect= pro
        end
    end

end


def render args

    #Setting white background and bottom border
    args.outputs.solids << [0, 0, 1280, 720, 255, 255, 255]
    args.outputs.solids << [0, 0, 1280, 250]
    args.outputs.solids << [15, 15, 1250, 220, 255, 255, 255]

    #Creating the pokemon sprites using entities
    args.outputs.sprites += args.state.pokemon.map {
        |p|
        [p.x, p.y, p.width, p.height, p.sprite]
    }

    #Adding opponent pokemon's banner
    args.outputs.labels << [args.state.pokemon1x, args.state.pokemon1y, args.state.pokemon[1].name.capitalize.to_s + " Lv." +
                            args.state.pokemon[1].level.to_s, 15, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf']
    args.outputs.labels << [args.state.pokemon1x + 30, args.state.pokemon1y - 65, 'HP:', 3, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf'] 
    args.outputs.sprites << [args.state.pokemon1x + 10, args.state.pokemon1y - 155, 350, 100, 'sprites/arrow.png']
    args.outputs.labels << [args.state.pokemon1x + 30, args.state.pokemon1y - 93, 'EXP:', 3, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf']
    args.outputs.solids << [args.state.pokemon1x + 100, args.state.pokemon1y - 88, 250, 16]
    args.outputs.solids << [args.state.pokemon1x + 100, args.state.pokemon1y - 113, 250, 16]
    args.outputs.solids << [args.state.pokemon1x + 102, args.state.pokemon1y - 110, ((1 / 1) * 246).to_i, 10, 0, 191, 255]

    #Creates opponent health bar with smooth decrease & color
    if (args.state.pokemon[1].currenthp / args.state.pokemon[1].hp) > 0.30
        args.outputs.solids << [args.state.pokemon1x + 102, args.state.pokemon1y - 85,
                                ((args.state.pokemon[1].currenthp / args.state.pokemon[1].hp) * 246).to_i, 10,
                                args.state.greenBar[0],
                                args.state.greenBar[1],
                                args.state.greenBar[2]]
    elsif (args.state.pokemon[1].currenthp / args.state.pokemon[1].hp) > 0.15
        args.outputs.solids << [args.state.pokemon1x + 102, args.state.pokemon1y - 85,
                                ((args.state.pokemon[1].currenthp / args.state.pokemon[1].hp) * 246).to_i, 10,
                                args.state.yellowBar[0],
                                args.state.yellowBar[1],
                                args.state.yellowBar[2]]
    else
        args.outputs.solids << [args.state.pokemon1x + 102, args.state.pokemon1y - 85,
                                ((args.state.pokemon[1].currenthp / args.state.pokemon[1].hp) * 246).to_i, 10,
                                args.state.redBar[0],
                                args.state.redBar[1],
                                args.state.redBar[2]]
    end

    #Adding my pokemon's banner
    args.outputs.labels << [args.state.pokemon2x - 50, args.state.pokemon2y, args.state.pokemon[0].name.capitalize.to_s + " Lv." +
                            args.state.pokemon[0].level.to_s, 15, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf']
    args.outputs.sprites << [args.state.pokemon2x, args.state.pokemon2y - 185, 350, 125, 'sprites/flippedArrow.png']
    args.outputs.labels << [args.state.pokemon2x - 20, args.state.pokemon2y - 65, 'HP:', 3, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf']
    args.outputs.labels << [args.state.pokemon2x - 20, args.state.pokemon2y - 93, 'EXP:', 3, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf'] 
    args.outputs.solids << [args.state.pokemon2x + 50, args.state.pokemon2y - 88, 250, 16]
    args.outputs.solids << [args.state.pokemon2x + 50, args.state.pokemon2y - 113, 250, 16]
    args.outputs.labels << [args.state.pokemon2x + 180, args.state.pokemon2y - 125,
                            args.state.pokemon[0].currenthp.to_s + ' / ' + args.state.pokemon[0].hp.to_s,
                            12, 1, 0, 0, 0, 255, 'fonts/manaspc.ttf'] 
    args.outputs.solids << [args.state.pokemon2x + 52, args.state.pokemon2y - 110, ((1 / 1) * 246).to_i, 10, 0, 191, 255]

    #Creates my pokemon's health bars with color & smooth decrease
    if (args.state.pokemon[0].currenthp / args.state.pokemon[0].hp) > 0.30
        args.outputs.solids << [args.state.pokemon2x + 52, args.state.pokemon2y - 85,
                                ((args.state.pokemon[0].currenthp / args.state.pokemon[0].hp) * 246).to_i, 10,
                                args.state.greenBar[0],
                                args.state.greenBar[1],
                                args.state.greenBar[2]]
    elsif (args.state.pokemon[0].currenthp / args.state.pokemon[0].hp) > 0.15
        args.outputs.solids << [args.state.pokemon2x + 52, args.state.pokemon2y - 85,
                                ((args.state.pokemon[0].currenthp / args.state.pokemon[0].hp) * 246).to_i, 10,
                                args.state.yellowBar[0],
                                args.state.yellowBar[1],
                                args.state.yellowBar[2]]
    else
        args.outputs.solids << [args.state.pokemon2x + 52, args.state.pokemon2y - 85,
                                ((args.state.pokemon[0].currenthp / args.state.pokemon[0].hp) * 246).to_i, 10,
                                args.state.redBar[0],
                                args.state.redBar[1],
                                args.state.redBar[2]]
    end

    if args.state.moveChosen == -1 && args.state.chosePotion == false && args.state.moveChosenOpponent == -1
        #Rendering bottom menu if the player has not chosen an action yet
        if !args.state.choseFight && !args.state.choseItem
            args.outputs.labels << [900, 200, 'FIGHT', 15, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf']
            args.outputs.labels << [900, 100, 'ITEM', 15, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf']
            args.outputs.sprites << [args.state.pokeballPlacementX, args.state.pokeballPlacementY[args.state.pokeballState],
                                    50, 50, 'sprites/pokeball.png']
        end
        #Depending on what menu the player is in, the menu will change
        if args.state.choseFight == true
            args.outputs.labels << [200, 200, args.state.moveset0[0].name, 15, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf']
            args.outputs.labels << [200, 100, args.state.moveset0[1].name, 15, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf']
            args.outputs.labels << [600, 200, args.state.moveset0[2].name, 15, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf']
            args.outputs.labels << [600, 100, args.state.moveset0[3].name, 15, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf']
            args.outputs.labels << [1000, 200, 'Back', 15, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf']
            args.outputs.sprites << [args.state.pokeballPlacementFightX[args.state.pokeballPlacementFightStatus[0]],
                                    args.state.pokeballPlacementFightY[args.state.pokeballPlacementFightStatus[1]],
                                    50, 50, 'sprites/pokeball.png']
        end
        if args.state.choseItem == true
            args.outputs.labels << [200, 200, 'Potion x' + args.state.potionQuantity.to_s, 15, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf']
            args.outputs.labels << [200, 100, 'Back', 15, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf']
            args.outputs.sprites << [140, args.state.pokeballPlacementItemY[args.state.pokeballPlacementItemStatus], 50, 50,
                                    'sprites/pokeball.png']
        end
    elsif args.state.chosePotion == true
        #Renders the item sequence. The only item is the potion, and this is render order for item selection
        #Order: display item usage, increase health bar, opponent move label, opponent move effect, check for game over
        if args.state.mypokemonAnimation <= args.state.frameDuration
            args.outputs.labels << [150, 200, 'You used a Potion!', 15, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf']
        elsif args.state.hpIncreaseIter < 20
            args.outputs.labels << [150, 200, 'You used a Potion!', 15, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf']
        elsif args.state.otherpokemonAnimation <= args.state.frameDuration
            renderOpponentMoveLabel(args)
            renderOpponentMove(args)
            renderOpponentProtect(args)
        elsif args.state.pokemon[0].currenthp > args.state.pokemon[0].finalhp
            renderOpponentMoveLabel(args)
            renderOpponentProtect(args)
        elsif gameOver?(args) == true && args.state.faintedIter < args.state.faintedDuration
          args.outputs.labels << [150, 200, args.state.pokemon[0].name.to_s + " fainted!",
                                  15, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf']
        elsif args.state.opponentStatIter < args.state.statChangeDuration
            renderOpponentStatChanges(args)
        end
    else
        if args.state.mypokemonfirst == true
            #This branch is taken when my pokemon will attack first
            #Order: my pokemon animation, decrease health bar, opponent animation, decrease health bar
            renderMyProtect(args)
            if args.state.mypokemonAnimation <= args.state.frameDuration
                renderMyMoveLabel(args)
                renderMyMove(args)
            elsif args.state.pokemon[1].currenthp > args.state.pokemon[1].finalhp
                renderMyMoveLabel(args)
            elsif success?(args) && args.state.faintedIter < args.state.faintedDuration
              args.outputs.labels << [150, 200, args.state.pokemon[1].name.to_s + " fainted!",
                                      15, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf']
            elsif args.state.myStatIter < args.state.statChangeDuration
                renderMyStatChanges(args)
            elsif args.state.otherpokemonAnimation <= args.state.frameDuration
                renderOpponentMoveLabel(args)
                renderOpponentMove(args)
                renderOpponentProtect(args)
            elsif args.state.pokemon[0].currenthp > args.state.pokemon[0].finalhp
                renderOpponentMoveLabel(args)
                renderOpponentProtect(args)
            elsif gameOver?(args) == true && args.state.faintedIter < args.state.faintedDuration
              args.outputs.labels << [150, 200, args.state.pokemon[0].name.to_s + " fainted!",
                                      15, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf']
            elsif args.state.opponentStatIter < args.state.statChangeDuration
                renderOpponentStatChanges(args)
            elsif args.state.moveset0[args.state.moveChosen].protect == true &&
                    args.state.moveset1[args.state.moveChosenOpponent].protect != true &&
                    args.state.unaffectedAnimation < args.state.frameDuration
                args.outputs.labels << [150, 200, args.state.pokemon[0].name.to_s + " was unaffected!",
                                        15, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf']
            end
        else
          #Branch taken when opponent attacks first
          #Order: opponent animation, decrease health, my pokemon animation, decrease health
            renderOpponentProtect(args)
            if args.state.otherpokemonAnimation <= args.state.frameDuration
                renderOpponentMoveLabel(args)
                renderOpponentMove(args)
            elsif args.state.pokemon[0].currenthp > args.state.pokemon[0].finalhp
                renderOpponentMoveLabel(args)
            elsif gameOver?(args) == true && args.state.faintedIter < args.state.faintedDuration
              args.outputs.labels << [150, 200, args.state.pokemon[0].name.to_s + " fainted!",
                                      15, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf']
            elsif args.state.opponentStatIter < args.state.statChangeDuration
                renderOpponentStatChanges(args)
            elsif args.state.mypokemonAnimation <= args.state.frameDuration
                renderMyMoveLabel(args)
                renderMyMove(args)
            elsif args.state.pokemon[1].currenthp > args.state.pokemon[1].finalhp
                renderMyMoveLabel(args)
            elsif success?(args) && args.state.faintedIter < args.state.faintedDuration
              args.outputs.labels << [150, 200, args.state.pokemon[1].name.to_s + " fainted!",
                                      15, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf']
            elsif args.state.myStatIter < args.state.statChangeDuration
                renderMyStatChanges(args)
            elsif args.state.moveset1[args.state.moveChosenOpponent].protect == true &&
                    args.state.moveset0[args.state.moveChosen].protect != true &&
                    args.state.unaffectedAnimation < args.state.frameDuration
                args.outputs.labels << [150, 200, args.state.pokemon[1].name.to_s + " was unaffected!",
                                        15, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf']
            end
        end
    end

    #Determine if game is finished
    renderEndgame(args)

end

def renderMyMoveLabel args
    args.outputs.labels << [150, 200,
                            args.state.pokemon[0].name.to_s + " used " + args.state.moveset0[args.state.moveChosen].name.to_s + "!",
                            15, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf']
end

def renderMyMove args
    #Renders the move selected
    renderEmber(args)   if args.state.moveChosen == 0
    renderScratch(args) if args.state.moveChosen == 1
    renderLeer(args)    if args.state.moveChosen == 2
end

def renderEmber args
    args.outputs.sprites << [470 + (args.state.mypokemonAnimation * ( (330 / args.state.frameDuration) )),
                             350 + (args.state.mypokemonAnimation * ( (150 / args.state.frameDuration) )),
                             90, 90, 'sprites/fire.gif']
end

def renderScratch args
    args.outputs.primitives << [:sprites, 875, 470, 200, 200, 'sprites/scratch.png']
end

def renderLeer args
    if args.state.mypokemonAnimation < args.state.frameDuration / 3
        args.outputs.primitives << [:solids, 875, 650 - (3 * args.state.mypokemonAnimation), 200, 20, 0, 191, 255]
    elsif args.state.mypokemonAnimation < 2 * args.state.frameDuration / 3
        args.outputs.primitives << [:solids, 875, 650 - (3 * args.state.mypokemonAnimation) + 90, 200, 20, 0, 191, 255]
        args.outputs.primitives << [:solids, 875, 650 - (3 * args.state.mypokemonAnimation)     , 200, 20, 0, 191, 255]
    else
        args.outputs.primitives << [:solids, 875, 650 - (3 * args.state.mypokemonAnimation) + 90, 200, 20, 0, 191, 255]
    end
end

def renderMyStatChanges args
    if args.state.moveChosen == 2
        args.outputs.labels << [150, 200, args.state.pokemon[1].name.to_s + "'s attack decreased!",
                                15, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf']
    end
end

def renderOpponentStatChanges args
    if args.state.moveChosenOpponent == 0
        args.outputs.labels << [150, 200, args.state.pokemon[0].name.to_s + "'s defense decreased!",
                                15, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf']
    end
end

def renderOpponentMoveLabel args
    args.outputs.labels << [150, 200,
                        args.state.pokemon[1].name.to_s + " used " + args.state.moveset1[args.state.moveChosenOpponent].name.to_s + "!",
                        15, 0, 0, 0, 0, 255, 'fonts/manaspc.ttf']
end

def renderOpponentMove args
    #Renders opponent's moves
    renderGrowl(args)    if args.state.moveChosenOpponent == 0
    renderVinewhip(args) if args.state.moveChosenOpponent == 1
    renderTackle(args)   if args.state.moveChosenOpponent == 2
end

def renderGrowl args
    if args.state.otherpokemonAnimation < args.state.frameDuration / 3
        args.outputs.primitives << [:solids, 300, 400 - (2.5 * args.state.otherpokemonAnimation), 200, 20, 0, 191, 255]
    elsif args.state.otherpokemonAnimation < 2 * args.state.frameDuration / 3
        args.outputs.primitives << [:solids, 300, 400 - (2.5 * args.state.otherpokemonAnimation) + 75, 200, 20, 0, 191, 255]
        args.outputs.primitives << [:solids, 300, 400 - (2.5 * args.state.otherpokemonAnimation)     , 200, 20, 0, 191, 255]
    else
        args.outputs.primitives << [:solids, 300, 400 - (2.5 * args.state.otherpokemonAnimation) + 75, 200, 20, 0, 191, 255]
    end
end

def renderVinewhip args
    if args.state.otherpokemonAnimation < args.state.frameDuration / 2
        args.outputs.primitives << [:sprites, 275, 250, 200, 200, 'sprites/vinewhip1.png']
    else
        args.outputs.primitives << [:sprites, 275, 250, 200, 200, 'sprites/vinewhip1.png']
        args.outputs.primitives << [:sprites, 275, 250, 200, 200, 'sprites/vinewhip2.png']
    end
end

def renderTackle args
    if args.state.otherpokemonAnimation < args.state.frameDuration / 2
        args.outputs.primitives << [:solids, 825, 475, 300, 300, 255, 255, 255]
        args.outputs.primitives << [:sprites, 825 - (8 * (args.state.otherpokemonAnimation)),
                                    475 - (1.5 * args.state.otherpokemonAnimation),
                                    300, 300, 'sprites/bulbasaur.png']
    else
        args.state.otherpokemonAnimation = args.state.frameDuration
    end
end

def renderMyProtect args
    if args.state.moveset0[args.state.moveChosen].protect == true
        args.outputs.sprites << [250, 250, 250, 250, 'sprites/charmanderbackprotect.png']
    end
end

def renderOpponentProtect args
    if args.state.moveset1[args.state.moveChosenOpponent].protect == true && args.state.moveChosenOpponent > -1
      args.outputs.sprites << [825, 475, 300, 300, 'sprites/bulbasaurprotect.png']
    end
end

def renderEndgame args
    return unless args.state.scene == :end && args.state.faintedIter == args.state.faintedDuration

    #Codes for the black screen at the end of the game
    args.outputs.primitives << [:solids, 0, 720, 1280, -36 * args.state.endgameIter, 0, 0, 0]

    if success?(args) == true
        args.outputs.labels << [640, (720 - (36 * args.state.endgameIter)) + 540,
                                "You won!", 30, 1, 255, 255, 255, 255, 'fonts/manaspc.ttf']
    else
        args.outputs.labels << [640, (720 - (36 * args.state.endgameIter)) + 540,
                                "Game Over", 30, 1, 255, 255, 255, 255, 'fonts/manaspc.ttf']
    end

    args.outputs.labels << [640, (720 - (36 * args.state.endgameIter)) + 455,
                            "Hit spacebar to play again!", 5, 1, 255, 255, 255, 255, 'fonts/manaspc.ttf']
    args.outputs.labels << [950, (720 - (36 * args.state.endgameIter)) + 200,
                            "Code:   Sahil Jain", 3, 0, 255, 255, 255, 255, 'fonts/manaspc.ttf']
    args.outputs.labels << [950, (720 - (36 * args.state.endgameIter)) + 160,
                            "Design: Nintendo",   3, 0, 255, 255, 255, 255, 'fonts/manaspc.ttf']
    args.outputs.labels << [950, (720 - (36 * args.state.endgameIter)) + 120,
                            "Engine: DragonRuby", 3, 0, 255, 255, 255, 255, 'fonts/manaspc.ttf']
    args.state.endgameIter += 1 if args.state.endgameIter < 22
end


def calc args

    if args.state.moveChosen == -1 && args.state.chosePotion == false
        #Keyboard input on MAIN menu
        fightItemNavigation(args) if !args.state.choseFight && !args.state.choseItem

        #Keyboard input for FIGHT menu
        fightNavigation(args) if args.state.choseFight == true

        #Keyboard input for ITEM menu
        itemNavigation(args) if args.state.choseItem == true
    else
        #Chooses opponent's move. A typical pokemon game would have some sort of smart calc here but I simply used a RNG
        if args.state.moveChosenOpponent == -1
            args.state.moveChosenOpponent = rand(4)
        end

        if args.state.completedCalc == false
            if args.state.chosePotion == true
                updatePotionStats args
            else
                updateStats args
            end
        end

        #Determines who attacks frist. 50% chance if both do not use protect
        if args.state.battleOrder == false
            whoFirst = rand()

            if args.state.chosePotion == true || args.state.moveset0[args.state.moveChosen].protect == true
                args.state.mypokemonfirst = true
            elsif args.state.moveset1[args.state.moveChosenOpponent].protect == true || whoFirst < 0.5
                args.state.mypokemonfirst = false
            else
                args.state.mypokemonfirst = true
            end
            args.state.battleOrder = true
        end

        #Same thing as render order, but instead of rendering, the iters increase and checks for success/failure
        #Sets everything to default afterwards
        if args.state.mypokemonfirst == true || args.state.chosePotion == true
            if args.state.chosePotion == true
                #Sequence if potion is used
                if args.state.mypokemonAnimation <= args.state.frameDuration
                    args.state.mypokemonAnimation += 1
                elsif args.state.hpIncreaseIter < 20
                    args.state.pokemon[0].currenthp += 1
                    if args.state.pokemon[0].currenthp > 100
                        args.state.pokemon[0].currenthp = 100
                    end
                    args.state.hpIncreaseIter += 1
                elsif args.state.otherpokemonAnimation <= args.state.frameDuration
                    args.state.otherpokemonAnimation += 1
                elsif args.state.pokemon[0].currenthp > args.state.pokemon[0].finalhp
                    args.state.pokemon[0].currenthp -= 1
                elsif gameOver?(args) == true && args.state.faintedIter < args.state.faintedDuration
                    setAnimationFull(args) if args.state.faintedIter == 0
                    args.state.faintedIter += 1
                elsif args.state.opponentStatIter < args.state.statChangeDuration
                    args.state.opponentStatIter += 1
                else
                    setDefaults(args) if gameOver?(args) == nil && success?(args) == nil
                end
            else
                #Sequence if my pokemon attacks first
                if args.state.mypokemonAnimation <= args.state.frameDuration
                    args.state.mypokemonAnimation += 1
                elsif args.state.pokemon[1].currenthp > args.state.pokemon[1].finalhp
                    args.state.pokemon[1].currenthp -= 1
                    args.state.mypokemonAnimation = 10000
                elsif success?(args) == true && args.state.faintedIter < args.state.faintedDuration
                    setAnimationFull(args) if args.state.faintedIter == 0
                    args.state.faintedIter += 1
                elsif args.state.myStatIter < args.state.statChangeDuration
                    args.state.myStatIter += 1
                elsif args.state.otherpokemonAnimation <= args.state.frameDuration
                    args.state.otherpokemonAnimation += 1
                elsif args.state.pokemon[0].currenthp > args.state.pokemon[0].finalhp
                    args.state.pokemon[0].currenthp -= 1
                    args.state.otherpokemonAnimation = 10000
                elsif gameOver?(args) == true && args.state.faintedIter < args.state.faintedDuration
                    setAnimationFull(args) if args.state.faintedIter == 0
                    args.state.faintedIter += 1
                elsif args.state.opponentStatIter < args.state.statChangeDuration
                    args.state.opponentStatIter += 1
                elsif args.state.moveset0[args.state.moveChosen].protect == true &&
                    args.state.moveset1[args.state.moveChosenOpponent].protect != true &&
                    args.state.unaffectedAnimation < args.state.frameDuration
                    args.state.unaffectedAnimation = args.state.unaffectedAnimation + 1
                else
                    setDefaults(args) if gameOver?(args) == nil && success?(args) == nil
                end
            end
        else
            #Sequence if opponent pokemon attacks first
            if args.state.otherpokemonAnimation <= args.state.frameDuration
                args.state.otherpokemonAnimation += 1
            elsif args.state.pokemon[0].currenthp > args.state.pokemon[0].finalhp
                args.state.otherpokemonAnimation = 10000
                args.state.pokemon[0].currenthp -= 1
            elsif gameOver?(args) == true && args.state.faintedIter < args.state.faintedDuration
                setAnimationFull(args) if args.state.faintedIter == 0
                args.state.faintedIter += 1
            elsif args.state.opponentStatIter < args.state.statChangeDuration
                args.state.opponentStatIter += 1
            elsif args.state.mypokemonAnimation <= args.state.frameDuration
                args.state.mypokemonAnimation += 1
            elsif args.state.pokemon[1].currenthp > args.state.pokemon[1].finalhp
                args.state.mypokemonAnimation = 10000
                args.state.pokemon[1].currenthp -= 1
            elsif success?(args) == true && args.state.faintedIter < args.state.faintedDuration
                setAnimationFull(args) if args.state.faintedIter == 0
                args.state.faintedIter += 1
            elsif args.state.myStatIter < args.state.statChangeDuration
                args.state.myStatIter += 1
            elsif args.state.moveset1[args.state.moveChosenOpponent].protect == true &&
                args.state.moveset0[args.state.moveChosen].protect != true && args.state.unaffectedAnimation < args.state.frameDuration
                args.state.unaffectedAnimation = args.state.unaffectedAnimation + 1
            else
                setDefaults args if gameOver?(args) == nil && success?(args) == nil
            end
        end
    end

end

def fightItemNavigation args

    #Navigation between options in first menu
    args.state.pokeballState = 1 if args.inputs.keyboard.key_up.w
    args.state.pokeballState = 0 if args.inputs.keyboard.key_up.s

    if args.inputs.keyboard.key_up.space && args.state.pokeballState == 1
        args.state.choseFight = true
        args.inputs.keyboard.clear    #VERY IMPORTANT! Ensures that the spacebar input does not stay in the next frame!!!
    end
    if args.inputs.keyboard.key_up.space && args.state.pokeballState == 0
        args.state.choseItem = true
        args.inputs.keyboard.clear
    end
end

def fightNavigation args
    #Keyboard input (the nested if statements insure that the pokeball is never on [2,0], which is empty
    #Very annoying code but essentially moves between options on the menu using a matrix
    if args.inputs.keyboard.key_up.w 
        args.state.pokeballPlacementFightStatus[1] = args.state.pokeballPlacementFightStatus[1] + 1
        if args.state.pokeballPlacementFightStatus[0] == 2 && args.state.pokeballPlacementFightStatus[1] == 2
            args.state.pokeballPlacementFightStatus = [1, 0]
        end
    end
    if args.inputs.keyboard.key_up.s
        args.state.pokeballPlacementFightStatus[1] = args.state.pokeballPlacementFightStatus[1] - 1
        if args.state.pokeballPlacementFightStatus[0] == 2 && args.state.pokeballPlacementFightStatus[1] == 0
            args.state.pokeballPlacementFightStatus = [1, 0]
        end
    end
    if args.inputs.keyboard.key_up.a
        args.state.pokeballPlacementFightStatus[0] = args.state.pokeballPlacementFightStatus[0] - 1
        if args.state.pokeballPlacementFightStatus[0] == -1 && args.state.pokeballPlacementFightStatus[1] == 0
            args.state.pokeballPlacementFightStatus = [1, 0]
        end
    end
    if args.inputs.keyboard.key_up.d
        args.state.pokeballPlacementFightStatus[0] = args.state.pokeballPlacementFightStatus[0] + 1
        if args.state.pokeballPlacementFightStatus[0] == 2 && args.state.pokeballPlacementFightStatus[1] == 0
            args.state.pokeballPlacementFightStatus = [0, 0]
        end
    end

    #Updating arrays
    if args.state.pokeballPlacementFightStatus[1] >= args.state.pokeballPlacementFightY.length
        args.state.pokeballPlacementFightStatus[1] = 0
    end
    if args.state.pokeballPlacementFightStatus[1] < 0
        args.state.pokeballPlacementFightStatus[1] = args.state.pokeballPlacementFightY.length - 1
    end
    if args.state.pokeballPlacementFightStatus[0] >= args.state.pokeballPlacementFightX.length
        args.state.pokeballPlacementFightStatus[0] = 0
    end
    if args.state.pokeballPlacementFightStatus[0] < 0
        args.state.pokeballPlacementFightStatus[0] = args.state.pokeballPlacementFightX.length - 1
    end

    if args.inputs.keyboard.key_up.space && args.state.pokeballPlacementFightStatus[0] == 2 &&
       args.state.pokeballPlacementFightStatus[1] == 1
        args.state.choseFight = false
        args.state.pokeballPlacementFightStatus = [0, 1]
    elsif args.inputs.keyboard.key_up.space
        args.state.moveChosen = args.state.movematrix[args.state.pokeballPlacementFightStatus[0]][args.state.pokeballPlacementFightStatus[1]]
        args.state.pokeballPlacementFightStatus = [0, 1]
    end
end

def itemNavigation args
    if args.inputs.keyboard.key_up.w
        args.state.pokeballPlacementItemStatus = 1
    end
    if args.inputs.keyboard.key_up.s
        args.state.pokeballPlacementItemStatus = 0
    end

    if args.inputs.keyboard.key_up.space && args.state.pokeballPlacementItemStatus == 0
        args.inputs.keyboard.clear
        args.state.pokeballPlacementItemStatus = 1
        args.state.choseItem = false
    end

    if args.inputs.keyboard.key_up.space && args.state.pokeballPlacementItemStatus == 1 && args.state.potionQuantity > 0
        args.inputs.keyboard.clear
        args.state.potionQuantity = args.state.potionQuantity - 1
        args.state.chosePotion = true
        args.state.moveChosen = 10 #ensures everything renders properly but ignores it because movechosen is never used in
                                   #the item sequence
    end

end

def updateStats args
    if args.state.moveset0[args.state.moveChosen].protect != true
        if args.state.moveset1[args.state.moveChosenOpponent].attack != 0
            #calcualtes the new hp for my pokemon
            args.state.pokemon[0].finalhp -= args.state.moveset1[args.state.moveChosenOpponent].attack + args.state.pokemon[1].attack -
                                            args.state.pokemon[0].defense + rand(11)
            args.state.pokemon[0].finalhp = 0 if args.state.pokemon[0].finalhp < 0
            args.state.opponentStatIter = args.state.statChangeDuration
        else
            #updates stats on my pokemon
            args.state.pokemon[0].attack += args.state.moveset0[args.state.moveChosen].aBoost -
                                            args.state.moveset1[args.state.moveChosenOpponent].aLower

            args.state.pokemon[0].defense += args.state.moveset0[args.state.moveChosen].dBoost -
                                            args.state.moveset1[args.state.moveChosenOpponent].dLower
        end
    else
        #If there is no stat change, it shouldn't run. To do this, the iters are modified
        args.state.opponentStatIter = args.state.statChangeDuration
        args.state.myStatIter = args.state.statChangeDuration
    end

    #Same thing but instead of my pokemon being updated, it's the opponent's pokemon
    if args.state.moveset1[args.state.moveChosenOpponent].protect != true 
        if args.state.moveset0[args.state.moveChosen].attack != 0
            args.state.pokemon[1].finalhp -= args.state.moveset0[args.state.moveChosen].attack + args.state.pokemon[0].attack -
                                            args.state.pokemon[1].defense + rand(11)
            if args.state.pokemon[1].finalhp < 0
                args.state.pokemon[1].finalhp = 0
            end
        args.state.myStatIter = args.state.statChangeDuration
        else
            args.state.pokemon[1].attack += args.state.moveset1[args.state.moveChosenOpponent].aBoost -
                                            args.state.moveset0[args.state.moveChosen].aLower

            args.state.pokemon[1].defense += args.state.moveset1[args.state.moveChosenOpponent].dBoost -
                                            args.state.moveset0[args.state.moveChosen].dLower
        end
    else
        args.state.opponentStatIter = args.state.statChangeDuration
        args.state.myStatIter = args.state.statChangeDuration
    end
    args.state.completedCalc = true

end

def updatePotionStats args
    #Adjusts my pokemon's stats. There are no moves that allow for stat boost of oneself, so that was not implemented
    args.state.pokemon[0].attack -= args.state.moveset1[args.state.moveChosenOpponent].aLower
    args.state.pokemon[0].defense -= args.state.moveset1[args.state.moveChosenOpponent].dLower
    args.state.pokemon[1].attack += args.state.moveset1[args.state.moveChosenOpponent].aBoost
    args.state.pokemon[1].defense += args.state.moveset1[args.state.moveChosenOpponent].dBoost

    args.state.pokemon[0].finalhp += 20
    
    args.state.pokemon[0].finalhp = 100 if args.state.pokemon[0].finalhp > 100 #VERY IMPORTANT THAT THIS IS BEFORE THE NEXT IF STATEMENT

    if args.state.moveset1[args.state.moveChosenOpponent].attack != 0
        args.state.pokemon[0].finalhp -= args.state.moveset1[args.state.moveChosenOpponent].attack + args.state.pokemon[1].attack -
                                         args.state.pokemon[0].defense + rand(11)
        args.state.opponentStatIter = args.state.statChangeDuration
        args.state.myStatIter = args.state.statChangeDuration
    end

    if args.state.moveset1[args.state.moveChosenOpponent].attack != 0 ||
       args.state.moveset1[args.state.moveChosenOpponent].protect == true
        args.state.opponentStatIter = args.state.statChangeDuration
        args.state.myStatIter = args.state.statChangeDuration
    end

    args.state.pokemon[0].finalhp = 0 if args.state.pokemon[0].finalhp < 0
    args.state.completedCalc = true
end

def gameOver? args
    return true if args.state.pokemon[0].currenthp == 0
end

def success? args
    return true if args.state.pokemon[1].currenthp == 0
end

def setAnimationFull args
    #sets all of the animation iters to be done after one of the pokemon faint
    args.state.myStatIter = args.state.statChangeDuration
    args.state.opponentStatIter = args.state.statChangeDuration
    args.state.otherpokemonAnimation = 10000
    args.state.mypokemonAnimation = 10000
    args.state.pokemon[0].finalhp = args.state.pokemon[0].currenthp if success?(args)
    args.state.pokemon[1].finalhp = args.state.pokemon[1].currenthp if gameOver?(args)
    args.state.scene = :end
end

def setDefaults args
    args.state.moveChosen = -1
    args.state.moveChosenOpponent = -1
    args.state.mypokemonAnimation = 0
    args.state.otherpokemonAnimation = 0
    args.state.unaffectedAnimation = 0
    args.state.completedCalc = false
    args.state.battleOrder = false
    args.state.choseFight = false
    args.state.choseItem = false
    args.state.chosePotion = false
    args.state.hpIncreaseIter = 0
    args.state.myStatIter = 0
    args.state.opponentStatIter = 0
end

def tick args
    defaults args
    render args
    calc args

    #Resets the game in end screen
    if args.state.scene == :end && args.inputs.keyboard.key_up.space
        args.dragon.reset
    end
end
