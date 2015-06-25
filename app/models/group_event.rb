class GroupEvent < ActiveRecord::Base
  include Publishable
  acts_as_paranoid

  validates :name, :location, length: { maximum: 255 }
  validates :description,     length: { maximum: 65_535 }
  validate :check_if_finish_early_than_start

  after_validation :calculate_interval
  after_validation :calculate_finish

  private

  def check_if_finish_early_than_start
    return if start_on.blank? || finish_on.blank?
    errors.add(:finish_on, I18n.t('group_events.errors.finish_early_than_start')) if finish_on < start_on
  end

  def calculate_finish
    return if start_on.blank? || duration.blank?
    self.finish_on = start_on + (duration.days - 1)
  end

  def calculate_interval
    return if start_on.blank? || finish_on.blank?
    self.duration = finish_on - start_on + 1
  end
end
