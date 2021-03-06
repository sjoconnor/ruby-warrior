require 'pry'
require 'status'
require 'movement'
require 'actions'
require 'environment'

class Player
  include Status
  include Movement
  include Actions
  include Environment

  attr_accessor :performing_retreat

  def initialize
    @max_health           = 20
    @health_last_turn     = 20
    @direction            = :forward
    @available_directions = [:forward, :backward, :left, :right]
    @action_sequence      = [:heal_to_full?, :retreat?, :found_captive?, :bind?, :basic_attack?, :walk?]
  end

  def play_turn(warrior)
    @warrior = warrior

    set_direction!
    take_action!

    # @health_last_turn = warrior.health
  end

  def take_action!
    @action_sequence.each do |action|
      if self.send(action)
        handle_action = "handle_" + action.to_s.gsub(/\?/, '') + "!"

        self.send(handle_action.to_sym)
        return
      end
    end
  end

  def hostiles
    ["Wizard", "Archer", "Thick Sludge", "Sludge", "Golem"]
  end

  def ranged_hostiles
    ["Wizard", "Archer"]
  end

  def performing_retreat
    @performing_retreat ||= false
  end
end