class Moment < ActiveRecord::Base
  belongs_to :previous_moment, class_name: "Moment", foreign_key: "previous_moment_id"
  has_many :constraints
  has_many :facts, through: :constraints

  def expand_from_leaf
    this_moment = self
    moment_chain = [this_moment]
    while this_moment = this_moment.previous_moment
      moment_chain.unshift this_moment
    end
    moment_chain
  end

  def expand_from_root
    this_moment = self
    moment_chain = [this_moment]
    while this_moment = Moment.where(previous_moment: this_moment).first
      moment_chain.push this_moment
    end
    moment_chain
  end

  def to_unity_JSON
    Jbuilder.encode do |json|
      json.(self, :id, :created_at, :updated_at)

      json.constraints self.constraints do |constraint|
        json.fact_test constraint.fact_test
        json.fact_name constraint.fact.name
        json.fact_default_value constraint.fact.default_value
      end
    end
  end

end
