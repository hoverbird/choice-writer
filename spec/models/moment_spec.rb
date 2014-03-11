require 'spec_helper'

describe Moment do
  fixtures :moments

  describe "an individual moment" do
    it "should each point to the previous moment" do
      expect(moments(:too_quiet).previous_moment).to eq(moments(:quiet))
    end
  end

  describe "in a single thread" do
    let :expected_thread do
      [ Moment.find(1),
        Moment.find(2),
        Moment.find(3),
        Moment.find(4) ]
    end

    it "should expand to a full chain from a leaf moment" do
      expect(moments(:quiet_end).expand_from_leaf).to eq(expected_thread)
    end

    it "should expand to a full chain from a root moment" do
      expect(moments(:quiet).expand_from_root).to eq(expected_thread)
    end


    # it "should include multiple moments that point to the same upstream moment" do
    #   expected_moments = [
    #     Moment.find(1),
    #     Moment.find(2),
    #     Moment.find(3),
    #     Moment.find(4)
    #   ]
    #
    #   expect(moments(:quiet_end).expand_from_leaf).to eq(expected_moments)
    # end

    it "should expand to a chain with multiple responses if they exist for a given chain" do
    end
  end

  describe "JSON output" do

  end

end
