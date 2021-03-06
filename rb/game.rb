class Game
  attr_accessor :cue, :players, :pits
  attr_accessor :players, :balls

  def self.width
    500
  end
  def self.height
    500
  end

  def initialize(player)
    self.balls = []
    self.pits = []
    self.players = []
    self.players << player
    
    pits << Pit.new(75,75)
    pits << Pit.new(Game::width-75, 75)
    pits << Pit.new(75, Game::height-75)
    pits << Pit.new(Game::width-75, Game::height-75)
    
    self.cue = Cue.new
    7.times {generate_ball(true)}
    7.times {generate_ball(false)}
  end
  def add_player(player)
    raise unless players.length > 1
  end
  def balls_and_cue
    balls | [cue]
  end

  def parseMove
    begin
      self.cue.move
      balls.each do |ball|
        ball.move

        pits.each do |pit|
          balls.delete ball if pit.munch ball
        end
        balls_and_cue.each do |ball2|
          ball.checkCollision ball2 if (ball2 != ball)
        end
      end
      pits.each do |pit|
        cue.reset if pit.munch cue
      end
    end while balls_moving?
  end

  def balls_moving?
    moving = false
    balls_and_cue.each do |ball|
      moving = true if ball.vx != 0 or ball.vy != 0
    end
    moving
  end
  def ended?
    balls.empty?
  end

  def generate_ball(red)
    ballX = 0
    ballY = 0
    overlap = false
    begin
      overlap = false
      ballX = 50+rand(400)
      ballY = 50+rand(400)

      balls.each do |ball|
        if (dist(ball.x, ball.y, ballX, ballY) < 40)
          overlap = true
        end
      end
      if (dist(cue.x, cue.y, ballX, ballY) < 40)
        overlap = true
      end
      pits.each do |pit|
        if (dist(pit.x, pit.y, ballX, ballY) < 40)
          overlap = true
        end
      end
    end while overlap==true

    balls << Ball.new(ballX, ballY, red)
  end

  def other_players(player)
    players.reject{|p| p==player}
  end

  def to_json(type, *a)
    # cue1 = cue
    # cue1.x = 100
    {
      :balls=>balls,
      :cue=>cue,
      :type=>type
    }.to_json(*a)
  end
end