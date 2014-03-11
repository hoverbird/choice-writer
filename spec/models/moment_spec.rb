require 'spec_helper'

describe Moment do
  fixtures :moments

  describe "an individual moment" do
    it "should each point to the previous moment" do
      expect(moments(:too_quiet).previous_moment).to eq(moments(:quiet))
    end

    describe "which has constraints" do
      it "should be wired up correctly" do
        expect(moments(:).constraints).to include(constraints(:henry_did_see_a_mouse))
        expect(moments(:).facts).to include(constraints(:henry_saw_a_mouse))
      end
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

    it "should expand to a chain with multiple responses if they exist for a given chain" do
    end
  end

  describe "JSON output" do

  end

end
