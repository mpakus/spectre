module Publishable
  extend ActiveSupport::Concern

  included do
    enum state: { draft: 0, published: 1 }
    attr_accessor :blank_fields

    def publish!
      @blank_fields = []
      [:name, :description, :location, :start_on, :finish_on, :duration].each do |field|
        @blank_fields << field if send(field).blank?
      end
      return false if @blank_fields.any?
      published!
      true
    end
  end
end
