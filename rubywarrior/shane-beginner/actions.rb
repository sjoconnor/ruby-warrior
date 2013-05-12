module Actions
  def retreat?
    @warrior.health < 6 && ! safe?
  end

  def ran_into_wall?
    next_cell.wall?
  end

  def walk?
    next_cell.empty?
  end

  def attack?
    next_cell.enemy?
  end

  def shoot_arrow?
    look = @warrior.look(@direction).reject {|cell| cell.to_s == "nothing"}

    return false if look.empty?
    return false unless look.detect {|cell| hostiles.include?(cell.to_s)}
    look.first.to_s != "Captive"
  end

  def found_captive?
    next_cell.captive?
  end

  def handle_retreat!
    change_direction!
    @warrior.walk!(@direction)
  end

  def handle_ran_into_wall!
    change_direction!
    @warrior.pivot!(@direction)
  end

  def handle_heal_to_full!
    @warrior.rest!
  end

  def handle_found_captive!
    @warrior.rescue!(@direction)
  end

  def handle_walk!
    @warrior.walk!(@direction)
  end

  def handle_shoot_arrow!
    @warrior.shoot!(@direction)
  end

  def handle_attack!
    @warrior.attack!(@direction)
  end
end