module Status
  def low_health?
    @warrior.health < 12
  end

  def alone?
    next_cell.empty?
  end

  def safe?
    ! taking_damage? && alone?
  end

  def taking_damage?
    @warrior.health < @health_last_turn
  end

  def full_health?
    @warrior.health == @max_health
  end
end