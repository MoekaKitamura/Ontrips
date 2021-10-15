module ApplicationHelper
  def region
    place.ancestry.nil?
  end

  def country
    place.ancestry&.length == 1
  end

  def city
    place.ancestry&.include?('/')
  end
end