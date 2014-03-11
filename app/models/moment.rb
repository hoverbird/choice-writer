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
    moment = self
    moment_chain = [moment]
    while moment = Moment.where(previous_moment: moment).first
      logger.info moment.id
      moment_chain.push moment
    end
    moment_chain
  end
end
