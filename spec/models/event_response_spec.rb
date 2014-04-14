require 'spec_helper'

describe EventResponse do
  fixtures :responses, :facts, :requirements, :fact_mutations, :event_responses
  let(:all_event_responses) { EventResponse.where(folder_id: 1).to_a }

  describe "collection_to_unity_hash" do
    let(:unity_hash) { EventResponse.collection_to_unity_hash(all_event_responses) }
    let(:parsed) { JSON.parse(unity_hash.to_json) }

    it "should be valid path from Ruby object to JSON Hash" do
      expect(unity_hash).to be_kind_of(Hash)
      expect(parsed).to be_kind_of(Hash)
      expect(parsed["$type"]).to eq("System.Collections.Generic.List`1[[vgEventResponseSpecification, Assembly-CSharp]], mscorlib")
      expect(parsed["$values"]).to be_kind_of(Array)
    end

    it "should have speech responses" do
      first_event = parsed["$values"].first
      first_speech_response = first_event["Responses"]["$values"].first

      expect(first_speech_response["$type"]).to eq("vgSpeechResponseSpecification, Assembly-CSharp")
      expect(first_speech_response["SpeechToPlay"]["Caption"]).to eq (responses(:quiet_start).text)
    end
  end

  describe "collection_to_web_hash" do
    let(:web_hash)    { EventResponse.collection_to_web_hash(all_event_responses) }
    let(:parsed)      { JSON.parse(web_hash.to_json) }
    let(:first_event) { parsed.first }

    it "should be valid path from Ruby object to JSON Hash" do
      pp web_hash
      pp "*****"
      expect(first_event["EventName"]).to eq(event_responses(:quiet_start).name)
      expect(first_event["Responses"]).to be_kind_of(Array)
    end

    it "should have speech responses" do
      first_speech_response = first_event["Responses"].first
      p first_speech_response

      expect(first_speech_response["Type"]).to eq("SpeechResponse")
      expect(first_speech_response["SpeechToPlay"]["Caption"]).to eq (responses(:quiet_start).text)
    end
  end
end
