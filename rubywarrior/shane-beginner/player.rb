require 'pry'
require 'status'

class Player
  include Status

  attr_accessor :warrior

  DIRECTIONS = [:forward, :backward]

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
    set_direction

    if retreat?
      @direction = :forward ? :backward : :forward
      warrior.walk!(@direction)
      return
    end

    if ran_into_wall?
      @direction = :forward ? :backward : :forward
      warrior.pivot!(@direction)
      return
    end

    if safe_to_heal_up?
      warrior.rest!
      return
    end

    if found_captive?
      warrior.rescue!(@direction)
      return
    end

    if shoot_arrow?
      warrior.shoot!(@direction)
      return
    end

    warrior.walk!(@direction) if next_cell.empty?

    warrior.attack!(@direction) unless next_cell.empty?
  end

  def set_direction
    direction = DIRECTIONS.detect do |direction|
      cells = warrior.look(direction)
      units = cells.reject {|cell| cell.to_s == 'nothing'}

      units.first.to_s == "Captive" || ranged_hostiles.include?(units.first.to_s)
    end
    @direction = direction || :forward
  end

  def shoot_arrow?
    look = warrior.look(@direction).reject {|cell| cell.to_s == "nothing"}

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
    ["Wizard", "Archer", "Thick Sludge"]
  end

  def ranged_hostiles
    ["Wizard", "Archer"]
  end
end