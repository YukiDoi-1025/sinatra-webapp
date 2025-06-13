# frozen_string_literal: true

class Memo
  attr_reader :id
  attr_accessor :title, :content

  def initialize(id, detail)
    @id = id
    @title = detail[:title]
    @content = detail[:content]
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
