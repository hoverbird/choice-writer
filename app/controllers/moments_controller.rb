class MomentsController < ApplicationController
  respond_to :json

  def index
    respond_with [
      {id: "1",
      character: "Hank",
      text: "A day in the life",
      scene: "Cabin",
      next_line_id: "2",
      type: "Speech",
      timestamp: Time.now.to_s
    },
     {
      id: "2",
      character: "Anna",
      text: "His last breath",
      scene: "Cabin",
      next_line_id: "3",
      type: "Speech",
    },
     {
      id: "3",
      character: "Hank",
      text: "Their first kiss",
      scene: "Cabin",
      type: "Speech"
      }
    ]
  end
end
