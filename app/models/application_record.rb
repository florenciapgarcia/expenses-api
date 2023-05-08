# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  has_many :expense
  primary_abstract_class
end
