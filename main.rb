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

  #Items
  args.state.potionQuantity ||= 2

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
      p.currenthp = 100
      p.level = 5
      p.moveset = ''
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
    [:growl, 0, 10, 0, 0, 0, false],
    [:vinewhip, 30, 0, 0, 0, 0, false],
    [:tackle, 20, 0, 10, 0, 0, false],
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
                          args.state.pokemon[1].level.to_s, 15, 0]
  args.outputs.labels << [args.state.pokemon1x + 50, args.state.pokemon1y - 65, 'HP:', 3, 0] 
  args.outputs.sprites << [args.state.pokemon1x + 10, args.state.pokemon1y - 155, 350, 100, 'sprites/arrow.png']
  args.outputs.labels << [args.state.pokemon1x + 50, args.state.pokemon1y - 90, 'EXP:', 3, 0]
  args.outputs.solids << [args.state.pokemon1x + 100, args.state.pokemon1y - 88, 250, 16]
  args.outputs.solids << [args.state.pokemon1x + 100, args.state.pokemon1y - 113, 250, 16]
  args.outputs.solids << [args.state.pokemon1x + 102, args.state.pokemon1y - 85,
                          ((args.state.pokemon[1].currenthp / args.state.pokemon[1].hp) * 246).to_i, 10, 0, 255, 0]
  args.outputs.solids << [args.state.pokemon1x + 102, args.state.pokemon1y - 110, ((1 / 1) * 246).to_i, 10, 0, 191, 255]

  #Adding my pokemon's banner
  args.outputs.labels << [args.state.pokemon2x, args.state.pokemon2y, args.state.pokemon[0].name.capitalize.to_s + " Lv." +
                          args.state.pokemon[0].level.to_s, 15, 0]
  args.outputs.sprites << [args.state.pokemon2x, args.state.pokemon2y - 185, 350, 125, 'sprites/flippedArrow.png']
  #[x, y, text, size, alignment, r, g, b, alpha(transparency), font] Manaspace font
  args.outputs.labels << [args.state.pokemon2x, args.state.pokemon2y - 65, 'HP:', 3, 0]
  args.outputs.labels << [args.state.pokemon2x, args.state.pokemon2y - 90, 'EXP:', 3, 0] 
  args.outputs.solids << [args.state.pokemon2x + 50, args.state.pokemon2y - 88, 250, 16]
  args.outputs.solids << [args.state.pokemon2x + 50, args.state.pokemon2y - 113, 250, 16]
  args.outputs.labels << [args.state.pokemon2x + 75, args.state.pokemon2y - 125,
                          args.state.pokemon[0].currenthp.to_s + ' / ' + args.state.pokemon[0].hp.to_s, 12, 0] 
  args.outputs.solids << [args.state.pokemon2x + 52, args.state.pokemon2y - 85,
                          ((args.state.pokemon[0].currenthp / args.state.pokemon[0].hp) * 246).to_i, 10, 0, 255, 0]
  args.outputs.solids << [args.state.pokemon2x + 52, args.state.pokemon2y - 110, ((1 / 1) * 246).to_i, 10, 0, 191, 255]

  if args.state.moveChosen == -1
    #Rendering bottom menu
    if !args.state.choseFight && !args.state.choseItem
        args.outputs.labels << [900, 200, 'FIGHT', 15, 0]
        args.outputs.labels << [900, 100, 'ITEM', 15, 0]
        args.outputs.sprites << [args.state.pokeballPlacementX, args.state.pokeballPlacementY[args.state.pokeballState],
                                50, 50, 'sprites/pokeball.png']
    end
    if args.state.choseFight == true
        args.outputs.labels << [200, 200, args.state.moveset0[0].name, 15, 0]
        args.outputs.labels << [200, 100, args.state.moveset0[1].name, 15, 0]
        args.outputs.labels << [600, 200, args.state.moveset0[2].name, 15, 0]
        args.outputs.labels << [600, 100, args.state.moveset0[3].name, 15, 0]
        args.outputs.labels << [1000, 200, 'Back', 15, 0]
        args.outputs.sprites << [args.state.pokeballPlacementFightX[args.state.pokeballPlacementFightStatus[0]],
                                args.state.pokeballPlacementFightY[args.state.pokeballPlacementFightStatus[1]],
                                50, 50, 'sprites/pokeball.png']
    end
    if args.state.choseItem == true
        args.outputs.labels << [200, 200, 'Potion x' + args.state.potionQuantity.to_s, 15, 0]
        args.outputs.labels << [200, 100, 'Back', 15, 0]
        args.outputs.sprites << [140, args.state.pokeballPlacementItemY[args.state.pokeballPlacementItemStatus], 50, 50,
                                'sprites/pokeball.png']
    end
  end


end

def calc args

  #Keyboard input on MAIN menu
  if !args.state.choseFight && !args.state.choseItem
    if args.inputs.keyboard.key_up.w
      args.state.pokeballState = 1
    end
    if args.inputs.keyboard.key_up.s
      args.state.pokeballState = 0
    end

    if args.inputs.keyboard.key_up.space && args.state.pokeballState == 1
      args.state.choseFight = true
    end
    if args.inputs.keyboard.key_up.space && args.state.pokeballState == 0
      args.state.choseItem = true
    end
  end

  #Keyboard input for FIGHT menu
  if args.state.choseFight == true
    #Keyboard input (the nested if statements insure that the pokeball is never on [2,0], which is empty
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

  #Keyboard input for ITEM menu
  if args.state.choseItem == true
    if args.inputs.keyboard.key_up.w
      args.state.pokeballPlacementItemStatus = 1
    end
    if args.inputs.keyboard.key_up.s
      args.state.pokeballPlacementItemStatus = 0
    end

    if args.inputs.keyboard.key_up.space && args.state.pokeballPlacementItemStatus == 0
      args.state.pokeballPlacementItemStatus = 1
      args.state.choseItem = false
    end
  end

  if args.state.moveChosen != -1
    if args.state.moveChosenOpponent == -1
      args.state.moveChosenOpponent == rand(4)
    end

    #Determines who attacks frist. 50% chance if both do not use protect
    whoFirst = rand()

    if args.state.moveset0[args.state.moveChosen].protect == true || whoFirst <= 0.5
      args.state.mypokemonfirst = true
    elsif args.state.moveset1[args.state.moveChosenOpponent].protect == true || whoFirst > 0.5
      args.state.mypokemonfirst = false
    else
      args.state.mypokemonfirst = true
    end
  end

end

def tick args
  defaults args
  render args
  calc args
end
