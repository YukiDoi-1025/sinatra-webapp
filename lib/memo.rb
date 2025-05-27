# frozen_string_literal: true

class Memo
  attr_reader :id
  attr_accessor :title, :content

  def initialize(id, detail)
    @id = id
    @title = detail[:title]
    @content = detail[:content]
  end

  def output_details
    [@id, { title: @title, content: @content }]
  end
end
