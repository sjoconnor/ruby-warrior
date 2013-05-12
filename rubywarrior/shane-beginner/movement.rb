module Movement
  def set_direction!
    direction = @available_directions.detect do |direction|
      units = visible_occupied_cells(direction)

      units.first.to_s == "Captive" || ranged_hostiles.include?(units.first.to_s)
    end
    @direction = direction || :forward
  end

  def change_direction!
    if @direction == :forward
      @direction = :backward
    else
      @direction = :forward
    end
  end
end