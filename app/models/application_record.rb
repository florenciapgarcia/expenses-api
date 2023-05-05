class ApplicationRecord < ActiveRecord::Base
  has_many :expense
  primary_abstract_class
end
