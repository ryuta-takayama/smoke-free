"""
Deprecated model. The action_plans table has been dropped and this class will be removed.
Mark as abstract to avoid ActiveRecord expecting a backing table if autoloaded.
"""
class ActionPlan < ApplicationRecord
  self.abstract_class = true
end
