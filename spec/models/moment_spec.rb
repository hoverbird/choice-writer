require 'spec_helper'

describe Moment do
  fixtures :moments

  describe "chaining" do
    it "should point to the previous moment" do
      expect(moments(:too_quiet).previous_moment).to eq(moments(:quiet))
    end

    xit "should expand to a full chain from a root moment" do
      expected_moments = [
        Moment.find(1),
        Moment.find(2),
        Moment.find(3),
        Moment.find(4)
      ]

      expect(moments(:quiet_end).expand_chain).to eq(expected_moments)
    end


    it "should expand to a chain with multiple responses if they exist for a given chain" do
    end
  end

  describe "JSON output" do

  end

end
