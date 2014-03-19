
###
Wait until the test condition is true or a timeout occurs. Useful for waiting
on a server response or for a ui change (fadeIn, etc.) to occur.

#@param testFx javascript condition that evaluates to a boolean,
it can be passed in as a string (e.g.: "1 == 1" or "$('#bar').is(':visible')" or
as a callback function.
#@param onReady what to do when testFx condition is fulfilled,
it can be passed in as a string (e.g.: "1 == 1" or "$('#bar').is(':visible')" or
as a callback function.
#@param timeOutMillis the max amount of time to wait. If not specified, 3 sec is used.
###
waitFor = (testFx, onReady, timeOutMillis) ->
  maxtimeOutMillis = (if timeOutMillis then timeOutMillis else 3001) #< Default Max Timeout is 3s
  start = new Date().getTime()
  condition = false
  interval = setInterval(->
    if (new Date().getTime() - start < maxtimeOutMillis) and not condition

      # If not time-out yet and condition not yet fulfilled
      condition = ((if typeof (testFx) is "string" then eval_(testFx) else testFx())) #< defensive code
    else
      unless condition

        # If condition still not fulfilled (timeout but condition is 'false')
        console.log "'waitFor()' timeout"
        phantom.exit 1
      else

        # Condition fulfilled (timeout and/or condition is 'true')
        console.log "'waitFor()' finished in " + (new Date().getTime() - start) + "ms."
        (if typeof (onReady) is "string" then eval_(onReady) else onReady()) #< Do what it's supposed to do once the condition is fulfilled
        clearInterval interval #< Stop this interval
    return
  , 100) #< repeat check every 100ms
  return
system = require("system")
if system.args.length isnt 2
  console.log "Usage: run-jasmine.js URL"
  phantom.exit 1
page = require("webpage").create()

# Route "console.log()" calls from within the Page context to the main Phantom context (i.e. current "this")
page.onConsoleMessage = (msg) ->
  console.log msg
  return

page.open system.args[1], (status) ->
  if status isnt "success"
    console.log "Unable to access network"
    phantom.exit()
  else
    waitFor (->
      page.evaluate ->
        document.body.querySelector(".symbolSummary .pending") is null

    ), ->
      exitCode = page.evaluate(->
        console.log ""
        console.log document.body.querySelector(".description").innerText
        list = document.body.querySelectorAll(".results > #details > .specDetail.failed")
        if list and list.length > 0
          console.log ""
          console.log list.length + " test(s) FAILED:"
          i = 0
          while i < list.length
            el = list[i]
            desc = el.querySelector(".description")
            msg = el.querySelector(".resultMessage.fail")
            console.log ""
            console.log desc.innerText
            console.log msg.innerText
            console.log ""
            ++i
          1
        else
          console.log document.body.querySelector(".alert > .passingAlert.bar").innerText
          0
      )
      phantom.exit exitCode
      return

  return
