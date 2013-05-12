require 'pry'
require 'status'
require 'movement'
require 'actions'

class Player
  include Status
  include Movement
  include Actions

  ACTION_SEQUENCE = [:retreat?, :ran_into_wall?,
                     :heal_to_full?, :found_captive?,
                     :shoot_arrow?, :attack?, :walk?]

  def initialize
    @max_health           = 20
    @health_last_turn     = 20
    @direction            = :forward
    @available_directions = [:forward, :backward]
  end

  def play_turn(warrior)
    @warrior = warrior

    set_direction!
    take_action!

    @health_last_turn = warrior.health
  end

  def take_action!
    ACTION_SEQUENCE.each do |action|
      if self.send(action)
        self.send("handle_" + action.to_s.gsub(/\?/, '') + "!")
        return
      end
    end
  end

  def next_cell
    @warrior.feel(@direction)
  end

  def visible_units(direction = @direction)
    @warrior.look(direction).reject {|cell| cell.to_s == "nothing" }
  end

  def hostiles
    ["Wizard", "Archer", "Thick Sludge", "Sludge", "Golem"]
  end

  def ranged_hostiles
    ["Wizard", "Archer"]
  end
end