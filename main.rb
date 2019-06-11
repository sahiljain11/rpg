
#Sprites: https://archives.bulbagarden.net/wiki/Category:Yellow_sprites
#BackSprites: https://pkmn.net/?action=content&page=viewpage&id=8561

class Pokemon
  name = ""
  frontSprite = ""
  backSprite = ""

  currenthp, hp, attack, sattack, defense, sdefense, speed, experience, level = 0

  def initialize (n, fs, bs, stats, exp, l)
    @name = n
    @frontSprite = fs
    @backSprite = bs
    @currenthp = hp = stats[0];
    @attack = stats[1]
    @sattack = stats[2]
    @defense = stats[3]
    @sdefense = stats[4]
    @speed = stats[5]
    @experience = exp
    @level = l
  end

  def getBackSprite
    return @backSprite
  end

  def getFrontSprite
    return @frontSprite
  end
  
end

def defaults args

  args.state.mypokemon ||= Pokemon.new('Bulbasaur', 'sprites/bulbasaur.png', 'sprites/bulbasaurback.png',
                                       [10, 10, 10, 10, 10, 10], 0, 5);

  args.state.otherpokemon ||= Pokemon.new('Charmander', 'sprites/charmander.png', 'sprites/charmanderback.png',
                                       [10, 10, 10, 10, 10, 10], 0, 5);
  args.state.pokmeon1x ||= 200
  args.state.pokemon1y ||= 700

  args.state.pokemon2x ||= 750
  args.state.pokemon2y ||= 475
  
end


def render args

  #Setting white background and bottom border
  args.outputs.solids << [0, 0, 1280, 720, 255, 255, 255]
  args.outputs.solids << [0, 0, 1280, 250]
  args.outputs.solids << [15, 15, 1250, 220, 255, 255, 255]

  #Creating the pokemon sprites
  args.outputs.sprites << [200, 250, 250, 250, args.state.otherpokemon.getBackSprite]
  args.outputs.sprites << [825, 475, 300, 300, args.state.mypokemon.getFrontSprite]

  #Adding labels

  args.outputs.labels << [args.state.pokmeon1x, args.state.pokemon1y, 'Bulbasaur Lv. 5', 15, 0]
  args.outputs.labels << [args.state.pokmeon1x + 50, args.state.pokemon1y - 65, 'HP:', 3, 0] 
  args.outputs.sprites << [210, 545, 300, 100, 'sprites/arrow.png']
  args.outputs.labels << [args.state.pokemon1x + 50, args.state.pokemon1y - 90, 'EXP:', 3, 0]
  #args.outputs.solids << [args.state.pokmeon1x + 100, args.state.pokemon1y - 88, 250, 16]
  #args.outputs.solids << [args.state.pokemon1x + 100, args.state.pokemon1y - 113, 250, 16]
  #args.outputs.solids << [args.state.pokemon1x + 102, args.state.pokemon1y - 85, ((1 / 1) * 246).to_i, 10, 0, 255, 0]
  #args.outputs.solids << [args.state.pokemon1x + 102, args.state.pokemon1y - 110, ((1 / 1) * 246).to_i, 10, 0, 191, 255]

  
  args.outputs.labels << [args.state.pokemon2x, args.state.pokemon2y, 'Charmander Lv. 5', 15, 0]
  args.outputs.sprites << [750, 290, 350, 125, 'sprites/flippedArrow.png']
  args.outputs.labels << [args.state.pokemon2x, args.state.pokemon2y - 65, 'HP:', 3, 0]
  args.outputs.labels << [args.state.pokemon2x, args.state.pokemon2y - 90, 'EXP:', 3, 0] 
  args.outputs.solids << [args.state.pokemon2x + 50, args.state.pokemon2y - 88, 250, 16]
  args.outputs.solids << [args.state.pokemon2x + 50, args.state.pokemon2y - 113, 250, 16]
  args.outputs.labels << [args.state.pokemon2x + 75, args.state.pokemon2y - 125, '1 3  /  1 9', 12, 0] 
  args.outputs.solids << [args.state.pokemon2x + 52, args.state.pokemon2y - 85, ((13 / 19) * 246).to_i, 10, 0, 255, 0]
  args.outputs.solids << [args.state.pokemon2x + 52, args.state.pokemon2y - 110, ((1 / 1) * 246).to_i, 10, 0, 191, 255]

end

def calc args

end

def tick args
  defaults args
  render args
  calc args
end
