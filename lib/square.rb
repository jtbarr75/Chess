class Square
  attr_accessor :current

  WHITE_SQUARE = "\u{25A0}"
  BLACK_SQUARE = "\u{25A1}"

  def initialize(icon)
    @default = icon
    @current = icon
  end

  def set_default
    @current = @default
  end

  def to_s
    @current
  end
end
