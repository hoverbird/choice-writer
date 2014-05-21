class SpeechResponse < Response
  before_save :parse_character_from_text

  CHARACTER_PATTERN = /^([A-Z0-9]*)(:)/
  TEXT_SLUG_PATTERN = /[^a-zA-Z0-9]+/
  COMMON_WORDS_PATTERN = /\b(is|and|are|the|a|they|i|are|am).*?\b/i

  def parse_character_from_text
    if char_name = text.match(CHARACTER_PATTERN)
      self.character = char_name[1]
      text.gsub! char_name[0], ''
      text.strip!
    end
  end

  def on_finish_event_name
    if read_attribute("on_finish_event_name").present?
      read_attribute "on_finish_event_name"
    else
      autogenerate_on_finish_event_name
    end
  end

  def autogenerate_on_finish_event_name
    ["OnSpeech", character_slug.capitalize, text_slug, '-', id].join
  end

  def text_slug
    @text_slug ||= text.gsub(COMMON_WORDS_PATTERN, '')[0..15].titleize.gsub(TEXT_SLUG_PATTERN, '')
  end

  def to_unity_hash
    unity_hash = Hashie::Mash.new
    unity_hash["$type"] = "vgSpeechResponseSpecification, Assembly-CSharp"

    speech_hash = Hashie::Mash.new
    speech_hash["$type"] = "vgSpeechInstance, Assembly-CSharp"
    speech_hash["Caption"] = clean_text

    # Always trigger a finish event, even if there is not currently another response
    speech_hash["OnFinishEvent"] = on_finish_event_name
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
    web_hash = {
      id: id,
      # event_response_id: event_response_id,
      Type: self.class.name,
      character: character || "HENRY",
      text: clean_text
    }

    # Always trigger a finish event, even if there is not currently another response
    web_hash["on_finish_event_name"] = on_finish_event_name
    web_hash["on_finish_event_delay"] = on_finish_event_delay if on_finish_event_delay

    web_hash["hack_audio_duration"] = hack_audio_duration if hack_audio_duration
    web_hash["minimum_duration"] = minimum_duration if minimum_duration
    web_hash["allow_queueing"] = allow_queueing unless allow_queueing.nil?
    web_hash["audio_clip_path"] = audio_clip_path if audio_clip_path

    web_hash
  end

  def common_hash_attributes
  end
end
