module Environment
  def next_cell
    @warrior.feel(@direction)
  end

  def next_unit_is_a?(unit_type)
    visible_occupied_cells.first.to_s == unit_type
  end

  def visible_occupied_cells(direction = @direction)
    @warrior.look(direction).reject {|cell| cell.empty?}
  end

  def visible_hostiles(direction = @direction)
    @warrior.look(direction).select {|cell| hostiles.include?(cell.to_s)}
  end

  def visible_ranged_units?(direction = @direction)
    @warrior.look.detect {|cell| ranged_hostiles.include?(cell.to_s)}
  end
end