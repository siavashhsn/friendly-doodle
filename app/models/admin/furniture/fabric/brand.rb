class Admin::Furniture::Fabric::Brand < ApplicationRecord
  validates_presence_of :name
  validates_uniqueness_of :name
end
