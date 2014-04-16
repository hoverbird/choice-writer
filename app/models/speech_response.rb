class SpeechResponse < Response

  def to_unity_hash
    unity_hash = Hashie::Mash.new
    unity_hash["$type"] = "vgSpeechResponseSpecification, Assembly-CSharp"

    speech_hash = Hashie::Mash.new
    speech_hash["$type"] = "vgSpeechInstance, Assembly-CSharp"
    speech_hash["Caption"] = clean_text

    # Always trigger a finish event, even if there is not currently another response
    speech_hash["OnFinishEvent"] = on_finish_event
    speech_hash["OnFinishEventDelay"] = on_finish_event_delay if on_finish_event_delay

    speech_hash["HackAudioDuration"] = hack_audio_duration if hack_audio_duration
    speech_hash["MinimumDuration"] = minimum_duration if minimum_duration
    speech_hash["AllowQueueing"] = allow_queueing unless allow_queueing.nil?
    speech_hash["AudioClipPath"] = audio_clip_path if audio_clip_path

    # Attach the Speech Hash to the main Speech Response Hash
    unity_hash["SpeechToPlay"] = speech_hash
    unity_hash
  end

  def to_web_hash
    unity_hash = { ID: id, Type: self.class.name }

    unity_hash["Character"] = character || "UNKNOWN"
    unity_hash["Caption"] = clean_text

    # Always trigger a finish event, even if there is not currently another response
    unity_hash["OnFinishEvent"] = on_finish_event
    unity_hash["OnFinishEventDelay"] = on_finish_event_delay if on_finish_event_delay

    unity_hash["HackAudioDuration"] = hack_audio_duration if hack_audio_duration
    unity_hash["MinimumDuration"] = minimum_duration if minimum_duration
    unity_hash["AllowQueueing"] = allow_queueing unless allow_queueing.nil?
    unity_hash["AudioClipPath"] = audio_clip_path if audio_clip_path

    unity_hash
  end
end
