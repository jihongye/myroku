function init()
    print "in CategoryRowListScene init()"
    m.top.isFullScreen = true
    m.top.focusable = true
    
    m.rowCategoryList = m.top.findNode("categoryRowList")
    
    'To control focus that back from video playback
    m.rowCategoryList.setFocus(true)  
    m.lastFocus = m.rowCategoryList
    
    m.c = m.top.findNode("rowGroup")
    m.BottomBar = m.top.findNode("BottomBar")
    
    m.rowVideoList = m.top.findNode("videoRowList")
    m.rowVideoList.observeField("rowItemSelected", "videoItemSelected")
    
    m.rowGroup = m.top.findNode("rowGroup")
    m.rowGroup.observeField("visible", "visibleChanged")
    
    m.video = m.top.findNode("video")
    m.video.visible = false
    m.video.observeField("state", "OnVideoPlayerStateChange")
    
    m.Hint = m.top.findNode("Hint")
end function

function categoryListContentChanged()
    print "in categoryListContentChanged()"
    
    m.rowCategoryList.content = m.top.rowListContent
        
    m.rowCategoryList.observeField("rowItemSelected", "categoryItemSelected")
    m.rowCategoryList.observeField("rowItemFocused",  "categoryItemFocused")
end function

function visibleChanged()
    print "visible changed to - " ; m.lastFocus.id 
    m.lastFocus.setFocus(true)
end function

function categoryItemFocused()    
    print "category item "; m.rowCategoryList.rowItemFocused[1]; " in row "; m.rowCategoryList.rowItemFocused[0]; " was focused"

    'Handle the focused content
    m.focusedContent = m.top.rowListContent.getChild(0).getChild(m.rowCategoryList.rowItemFocused[1])
    
    'call the function to set the video list content
    if (m.focusedContent <> invalid)     
        videoListContentChanged()
    end if
        
end function

function categoryItemSelected()    
    print "category item "; m.rowCategoryList.rowItemSelected[1]; " in row "; m.rowCategoryList.rowItemSelected[0]; " was selected"

    'Handle the selected content
    selectedContent = m.top.rowListContent.getChild(0).getChild(m.rowCategoryList.rowItemFocused[1])
    m.rowGroup.visible = false
            
    'init of video player and start playback
    m.video.content = selectedContent.getChild(0)
    m.video.contentIsPlaylist = true
    m.video.control = "play"
    m.video.visible = true
    m.video.setFocus(true)
    
    m.lastFocus = m.rowCategoryList
    
end function

function videoListContentChanged()
    print "in videoListContentChanged"
            
    'set rowVideo Content    
    m.rowVideoList.content = m.focusedContent               
end function

function videoItemSelected()
    print "video item "; m.rowVideoList.rowItemSelected[1]; " in row "; m.rowVideoList.rowItemSelected[0]; " was selected"

    'Handle the selected content
    selectedContent = m.focusedContent.getChild(m.rowVideoList.rowItemSelected[0]).getChild(m.rowVideoList.rowItemFocused[1])
    m.rowGroup.visible = false
       
    m.lastFocus = m.rowVideoList
        
    'set video content and start playback single video
    m.video.content = selectedContent
    m.video.control = "play"
    m.video.visible = true
    m.video.setFocus(true)

end function

function setVisible(isShowVisible as Boolean, isHideCategory as Boolean)
    m.rowGroup.visible = isShowVisible
    m.rowVideoList.visible = isShowVisible
    m.rowCategoryList.visible = isHideCategory
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    if press then      
        if key = "up" OR key = "down"
            print "pressed up"
            if (m.video.visible = true)                
                setVisible(true, false)                
                m.rowVideoList.setFocus(true)
            else if (m.rowCategoryList.hasFocus())
                m.rowVideoList.setFocus(true)   
                return true
            else if (m.rowVideoList.hasFocus())
                m.rowCategoryList.setFocus(true) 
                return true
            end if
        else if key = "back"
            print "pressed back"
            if (m.video.visible = true)
                print "Remove video"
                m.video.control = "stop"
                m.video.visible = false
                
                setVisible(true, true)
                return true
            end if
        end if
    end if

    return false
end function

function OnVideoPlayerStateChange()
    if m.video.visible = true
        if m.video.state = "error" OR m.video.state = "finished"
            print "video state is:" ; m.video.state
            'hide vide player in case of error
            m.video.control = "stop"
            m.video.visible = false
            
            m.rowGroup.visible = true            
        end if    
    end if
end function