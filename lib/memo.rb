# frozen_string_literal: true

class Memo
  attr_reader :id
  attr_accessor :title, :content

  def initialize(memo)
    @id = memo[:id]
    @title = memo[:title]
    @content = memo[:content]
  end

  def to_h
    {
      @id => {
        title:,
        content:
      }
    }
  end
end
