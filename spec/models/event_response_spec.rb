require 'spec_helper'

describe EventResponse do
  fixtures :responses, :facts, :requirements, :fact_mutations, :event_responses
  let(:event_responses) { EventResponse.where(folder_id: 1).to_a }

  describe "collection_to_unity_hash" do
    let(:unity_hash) { EventResponse.collection_to_unity_hash(event_responses) }
    let(:parsed) { JSON.parse(unity_hash.to_json) }

    it "should be valid path from Ruby object to JSON Hash" do
      expect(unity_hash).to be_kind_of(Hash)
      expect(parsed).to be_kind_of(Hash)
      expect(parsed["$type"]).to eq("System.Collections.Generic.List`1[[vgEventResponseSpecification, Assembly-CSharp]], mscorlib")
    end

    it "should have speech responses" do
      # pp JSON.pretty_generate(unity_hash)
      # puts "***"
      # first_event = parsed["$values"].first
      # pp first_event
      # pp "&*&*&*&*&*&*"
      # first_speech_response = first_event["Responses"]["$values"].first
      # pp(first_speech_response)
      expect(first_speech_response["$type"]).to eq("vgSpeechResponseSpecification, Assembly-CSharp")
      expect(first_speech_response["SpeechToPlay"]["Caption"]).to eq (responses(:quiet).text)
    end

  end
end
