require 'spec_helper'

describe SpeechResponse do
  fixtures :responses, :facts, :requirements

  describe "an individual response" do
    let(:response) { responses(:heard_a_noise_mouse) }

    it "should each point to the previous response" do
      expect(responses(:too_quiet).previous_response).to eq(responses(:quiet))
    end

    describe "which has constraints" do
      it "should be wired up correctly" do
        expect(response.constraints).to include(requirements(:delilah_does_know_about_the_mice))
        expect(response.facts).to include(facts(:delilah_knows_about_the_mice))
      end
    end

    describe "web JSON output" do
      let(:parsed_output) { JSON.parse(response.as_web_JSON.target!) }

      it "should be valid" do
        expect(parsed_output).to be_kind_of(Hash)
        expect(parsed_output["id"]).to equal(response.id)
        expect(DateTime.parse(parsed_output["created_at"])).to(be_kind_of(DateTime), "to be a valid date format")
        expect(parsed_output["requirements"]).to be_kind_of(Array)
      end
    end

    describe "unity JSON output" do
      let(:parsed) { JSON.parse(response.collection_as_unity_JSON([response])) }
      let(:requirements) { parsed["Requirements"] }

      it "should be valid" do
        expect(parsed).to be_kind_of(Hash)
        expect(parsed["$type"]).to eq("vgEventResponseSpecification, Assembly-CSharp")
        expect(parsed["EventName"]).to eq("approach_rocks_closestToTower")
      end

      it "should be have a valid Requirements sub-object" do
        expect(requirements["$type"]).to eq("System.Collections.Generic.List`1[[vgBlackboardFact, Assembly-CSharp]], mscorlib")
      end

    end
  end

  describe "in a single thread" do
    let(:expected_thread)do
      [ SpeechResponse.find(1),
        SpeechResponse.find(2),
        SpeechResponse.find(3),
        SpeechResponse.find(4) ]
    end

    it "should expand to a full chain from a leaf response" do
      expect(responses(:quiet_end).expand_from_leaf).to eq(expected_thread)
    end

    it "should expand to a full chain from a root response" do
      expect(responses(:quiet).expand_from_root).to eq(expected_thread)
    end

    it "should include all nodes when expanding from leaf" do
      expect(responses(:quiet_end).expand_from_leaf).to eq(expected_thread)
    end

    it "should expand to a chain with multiple responses if they exist for a given chain" do
      expanded_chain = responses(:heard_a_noise_response_mouse).expand_from_leaf
      expect(expanded_chain).to include(responses(:heard_a_noise_what))
      expect(expanded_chain).to include(responses(:heard_a_noise_mouse))
      expect(expanded_chain).to include(responses(:heard_a_noise_cat))
    end
  end

end
