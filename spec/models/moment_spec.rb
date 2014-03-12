require 'spec_helper'

describe Moment do
  fixtures :moments, :facts, :constraints

  describe "an individual moment" do
    let(:moment) { moments(:heard_a_noise_mouse) }

    it "should each point to the previous moment" do
      expect(moments(:too_quiet).previous_moment).to eq(moments(:quiet))
    end

    describe "which has constraints" do
      it "should be wired up correctly" do
        expect(moment.constraints).to include(constraints(:delilah_does_know_about_the_mice))
        expect(moment.facts).to include(facts(:delilah_knows_about_the_mice))
      end
    end

    describe "JSON output" do
      let(:parsed_output) { JSON.parse(moment.to_unity_JSON) }

      it "should be valid" do
        expect(parsed_output).to be_kind_of(Hash)
        expect(parsed_output["id"]).to equal(moment.id)
        expect(DateTime.parse(parsed_output["created_at"])).to(be_kind_of(DateTime), "to be a valid date format")
        expect(parsed_output["constraints"]).to be_kind_of(Array)
      end
    end
  end

  describe "in a single thread" do
    let(:expected_thread)do
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

    it "should include all nodes when expanding from leaf" do
      expect(moments(:quiet_end).expand_from_leaf).to eq(expected_thread)
    end

    it "should expand to a chain with multiple responses if they exist for a given chain" do
      expanded_chain = moments(:heard_a_noise_response_mouse).expand_from_leaf
      expect(expanded_chain).to include(moments(:heard_a_noise_what))
      expect(expanded_chain).to include(moments(:heard_a_noise_mouse))
      expect(expanded_chain).to include(moments(:heard_a_noise_cat))
    end
  end


end
