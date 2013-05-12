module Actions
  def retreat?
    @warrior.health < 6
  end

  def handle_retreat!
    puts "Retreating"

    performing_retreat = full_health? ? false : true

    change_direction! if performing_retreat
    @warrior.walk!(@direction)
  end

  def ran_into_wall?
    next_cell.wall?
  end

  def handle_ran_into_wall!
    change_direction!
    @warrior.pivot!(@direction)
  end

  def heal_to_full?
    return false if visible_hostiles.empty?
    safe? && (low_health? || @warrior.health < @max_health) && ! taking_damage?
  end

  def handle_heal_to_full!
    puts "Healing to full."
    @warrior.rest!
  end

  def found_captive?
    next_cell.captive?
  end

  def handle_found_captive!
    @warrior.rescue!(@direction)
  end

  def shoot_arrow?
    look = visible_occupied_cells

    return false if look.empty?
    return false if look.first.captive?
    return false if visible_hostiles.empty?
    return false if next_unit_is_a?("Sludge")
    true
  end

  def handle_shoot_arrow!
    @warrior.shoot!(@direction)
  end

  def basic_attack?
    next_cell.enemy?
  end

  def handle_basic_attack!
    @warrior.attack!(@direction)
  end

  def walk?
    next_cell.empty?
  end

  def handle_walk!
    @warrior.walk!(@direction)
  end
end