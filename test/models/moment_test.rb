require 'test_helper'

class MomentTest < ActiveSupport::TestCase
  test "the truth" do
    first_moment = moments(:quiet)
    assert first_moment.text.match(/quiet/)
    assert first_moment.next_moment.kind_of?(Moment)
  end
end
