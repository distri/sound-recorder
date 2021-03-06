Recorder = require "./lib/recorder"

module.exports = ({input, Observable, save}) ->
  recorder = new Recorder(input)

  player = document.createElement "audio"

  self =
    recordingClass: ->
      if self.recording()
        "recording"

    recording: Observable false

    play: ->
      self.recording false
      recorder.exportWAV (blob) ->
        player.src = URL.createObjectURL(blob)
        player.play()

    record: ->
      self.recording !self.recording()
      recorder.clear() if self.recording()

    stop: ->
      self.recording false

    asBlob: ->
      new Promise (resolve, reject) ->
        recorder.exportWAV resolve

    save: save

  self.recording.observe (newValue) ->
    if newValue
      recorder.record()
    else
      recorder.stop()

  return self
