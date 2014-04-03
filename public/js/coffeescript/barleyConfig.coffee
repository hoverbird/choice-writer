# define ["underscore", "barley"], (_, barley) ->

# 1. Define everything - A list of methods to enhance the configurability
# You can use the `barley.bar.settings.lock_edits` anytime to lock the editor.
# Just set that to TRUE and run barley.editor.init()
barley = barley or {}
barley.editor = barley.editor or {}
barley.timers = barley.timers or {}
barley.bar = barley.bar or {}
barley.bar.settings = barley.bar.settings or {}
barley.bar.settings.lock_edits = false

# 2. Save Method - What happens when the editor sends data to be saved.
barley.editor.save = (obj) ->
  k = obj.data("barley")
  v = obj.html()
  console.log "Barley save"
  # console.log "Key: \"" + k + "\" Value: " + v + "\""
  return

# 3. Error Tracking - What happens when the editor returns an error
barley.trackError = (obj) ->
  console.log "Barley Editor Error Found"
  console.log obj
  return

# 4. Image Handling - What happens when the image button is clicked.
barley.editor.upload = (type, width, height) ->
  console.log "Image Upload Called"
  return

barley.editor.jazz = -> "Yeah!"
# # 5. Video Handling - What happens when the video button is clicked.
# barley.editor.video = (type, url, width) ->
#   console.log "Video Upload/Embed Called"
#   return

# barley
