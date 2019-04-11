function init()
    print "in CategoryRowListScene init()"
    m.top.isFullScreen = true
    
    m.rowCategoryList = m.top.findNode("categoryRowList")
    m.rowCategoryList.setFocus(true)  
    
    m.rowGroup = m.top.findNode("rowGroup")
    m.rowVideoList = m.top.findNode("videoRowList")
    
    'm.top.observeField("focusedChild", "focusChanged")
end function

function focusChanged()
    if m.top.isInFocusChain()
        print "in FocusChain"
        if m.rowGroup.visible = true AND not m.rowCategoryList.hasFocus() AND not m.rowVideoList.hasFocus()
            m.rowCategoryList.setFocus(true)        
        end if
    end if
end function

function categoryListContentChanged()
    print "in categoryListContentChanged()"
    
    m.rowCategoryList.rowItemSize = [ [350, 400] ]

    m.rowCategoryList.content = m.top.rowListContent
    
    'm.rowCategoryList.visible = true
    m.rowCategoryList.setFocus(true)
    
    m.rowCategoryList.observeField("rowItemSelected", "categoryItemSelected")
    m.rowCategoryList.observeField("rowItemFocused",  "categoryItemFocused")
      
end function

function categoryItemFocused()
    print "item "; m.rowCategoryList.rowItemFocused[1]; " in row "; m.rowCategoryList.rowItemFocused[0]; " was focused"

    'Handle the focused content
    m.focusedContent = m.top.rowListContent.getChild(0).getChild(m.rowCategoryList.rowItemFocused[1])
    
    if (m.focusedContent <> invalid)     
        videoListContentChanged()
    end if
        
end function

function categoryItemSelected()
    print "item "; m.rowCategoryList.rowItemSelected[1]; " in row "; m.rowCategoryList.rowItemSelected[0]; " was selected"
     
    'Handle the selected content
    selectedContent = m.top.rowListContent.getChild(0).getChild(m.rowCategoryList.rowItemFocused[1])
    m.rowGroup.visible = false
    
    'Dynamically create the video node since key press will remove the video node
    m.video = m.top.createChild("Video")
        
    'init of video player and start playback
    m.video.content = selectedContent.getChild(0)
    m.video.contentIsPlaylist = true
    m.video.control = "play"
    m.video.visible = true
    m.video.setFocus(true)
    
    m.video.observeField("state", "OnVideoPlayerStateChange")
end function

function videoListContentChanged()
    print "in videoListContentChanged"
    m.rowVideoList.rowItemSize = [ [250, 300] ]
        
    'print rowVideoContent
    m.rowVideoList.content = m.focusedContent    
    'm.rowVideoList.visible = true
    
    m.rowVideoList.observeField("rowItemFocused", "videoItemFocused")
    m.rowVideoList.observeField("rowItemSelected", "videoItemSelected")
        
end function

function videoItemFocused()
    print "item "; m.rowVideoList.rowItemFocused[1]; " in row "; m.rowVideoList.rowItemFocused[0]; " was focused"
    m.rowVideoList.setFocus(true)
end function

function videoItemSelected()
    print "item "; m.rowVideoList.rowItemSelected[1]; " in row "; m.rowVideoList.rowItemSelected[0]; " was selected"
         
    'Handle the selected content
    selectedContent = m.focusedContent.getChild(m.rowVideoList.rowItemSelected[0]).getChild(m.rowVideoList.rowItemFocused[1])
    m.rowGroup.visible = false
    
    'Dynamically create the video node since key press will remove the video node
    m.video = m.top.createChild("Video")
        
    'init of video player and start playback
    m.video.content = selectedContent
    m.video.control = "play"
    m.video.visible = true
    m.video.setFocus(true)

end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    if press then
        if key = "down"
            print "pressed down"
            if (m.rowCategoryList.hasFocus())
                m.rowVideoList.setFocus(true)  
                m.rowCategoryList.setFocus(false)   
                return true
            end if
        end if
        
        if key = "up"
            print "pressed down"
            if (m.rowVideoList.hasFocus())
                m.rowCategoryList.setFocus(true) 
                m.rowVideoList.setFocus(false)     
                return true
            end if
        end if
              
        if key = "back"
            print "pressed back"
            if (m.video <> invalid)
                print "Remove video"
                m.top.removeChild(m.video)
                m.video = invalid
                
                m.rowGroup.visible = true
                m.rowCategoryList.setFocus(true)

                return true
            end if
        end if
    end if

    return false
end function

function OnVideoPlayerStateChange()
    if m.video.state = "error" OR m.video.state = "finished"
        'hide vide player in case of error
        m.video.control = "stop"
        m.video.visible = false
        
        m.rowGroup.visible = true
        m.rowCategoryList.setFocus(true)
    end if
end function