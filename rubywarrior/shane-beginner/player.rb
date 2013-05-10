require 'pry'
require 'status'

class Player
  include Status

  attr_accessor :warrior

  def initialize
    @max_health       = 20
    @health_last_turn = 20
    @direction        = :forward
  end

  def play_turn(warrior)
    @warrior = warrior

    take_action

    @health_last_turn = warrior.health
  end

  def take_action
    if retreat?
      @direction = :backward
      warrior.walk!(@direction)
      return
    end

    if ran_into_wall?
      @direction = :forward
      warrior.pivot!
      return
    end

    if safe_to_heal_up?
      warrior.rest!
      return
    end

    if shoot_arrow?
      warrior.shoot!
      return
    end

    if found_captive?
      warrior.rescue!(@direction)
      return
    end

    warrior.walk!(@direction) if next_cell.empty?

    warrior.attack!(@direction) unless next_cell.empty?
  end

  def shoot_arrow?
    look = warrior.look.reject {|cell| cell.to_s == "nothing"}

    return false if look.empty?
    return false unless look.detect {|cell| hostiles.include?(cell.to_s)}
    look.first.to_s != "Captive"
  end

  def next_cell
    warrior.feel(@direction)
  end

  def retreat?
    warrior.health < 6 && ! safe? && alone?
  end

  def ran_into_wall?
    next_cell.wall?
  end

  def found_captive?
    next_cell.captive?
  end

  def hostiles
    ["Wizard", "Sludge", "Thick Sludge", "Golem", "Archer"]
  end
end