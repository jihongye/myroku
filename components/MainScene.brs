' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

sub init()
    m.Image       = m.top.findNode("Image")
    m.ButtonGroup = m.top.findNode("ButtonGroup")
    m.Details     = m.top.findNode("Details")
    m.Title       = m.top.findNode("Title")
    m.Video       = m.top.findNode("Video")
    m.Warning     = m.top.findNode("WarningDialog")
    m.Exiter      = m.top.findNode("Exiter")
    setContent()
    m.ButtonGroup.setFocus(true)
    m.ButtonGroup.observeField("buttonSelected","onButtonSelected")
End sub

sub onButtonSelected()
  'Ok'
  if m.ButtonGroup.buttonSelected = 0
    m.Video.visible = "true"
    m.Video.control = "play"
    m.Video.setFocus(true)
  'Exit button pressed'
  else
    m.Exiter.control = "RUN"
  end if
end sub

'Set your information here
sub setContent()
    
    'json = ParseJSON("https://dl.dropboxusercontent.com/s/rwkc3hntz1q9ph6/roku-front.json")
    jsonAsString = ReadAsciiFile("pkg:/json/roku-front.json")
    json = ParseJSON(jsonAsString)
    for each video in json.entries
       'print video.Title; video.Image; video.Url
       m.Title.text = video.Title
       m.Details.text = video.Url
    end for
 
  'm.Video.content = ContentNode

  'Change the buttons
  Buttons = ["Play","Exit"]
  m.ButtonGroup.buttons = Buttons

end sub

' Called when a key on the remote is pressed
function onKeyEvent(key as String, press as Boolean) as Boolean
  print "in MainScene.xml onKeyEvent ";key;" "; press
  if press then
    if key = "back"
      print "------ [back pressed] ------"
      if m.Warning.visible
        m.Warning.visible = false
        m.ButtonGroup.setFocus(true)
        return true
      else if m.Video.visible
        m.Video.control = "stop"
        m.Video.visible = false
        m.ButtonGroup.setFocus(true)
        return true
      else
        return false
      end if
    else if key = "OK"
      print "------- [ok pressed] -------"
      if m.Warning.visible
        m.Warning.visible = false
        m.ButtonGroup.setFocus(true)
        return true
      end if
    else
      return false
    end if
  end if
  return false
end function
