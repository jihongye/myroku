
sub init()
    m.top.isFullScreen = true
                
    'Run the feedReader task    
    m.readerTask = createObject("roSGNode", "FeedReader")
    m.readerTask.observeField("content", "setCategories")
    m.readerTask.control = "RUN" 
            
    m.rowGroup = m.top.findNode("rowGroup")
    m.rowGroup.observeField("visible", "onVisibleChanged")
    
    m.rowCategoryList = m.top.findNode("categoryRowList")
    m.rowCategoryList.setFocus(true)  
    
    'To control the last focused item
    m.lastFocus = m.rowCategoryList
        
    m.BottomBar = m.top.findNode("BottomBar")
    
    m.rowVideoList = m.top.findNode("videoRowList")
    m.rowVideoList.observeField("rowItemSelected", "onVideoItemSelected")
    
    m.video = m.top.findNode("video")
    m.video.visible = false
    m.video.observeField("state", "onVideoPlayerStateChange")
    
    m.Hint = m.top.findNode("Hint")
End sub

function setCategories()
    print "in setCategories()"
    
    if m.readerTask.content = invalid
        print "Invalid data content"
    else                        
        m.top.rowListContent = m.readerTask.content                  
    end if
end function

function onRowCategoryContentChanged()
    print "in onRowCategoryContentChanged()"
    
    m.rowCategoryList.content = m.top.rowListContent
    
    m.rowCategoryList.observeField("rowItemFocused",  "onCategoryItemFocused")    
    m.rowCategoryList.observeField("rowItemSelected", "onCategoryItemSelected")
    
end function

function onVisibleChanged()
    print "Visible changed to - " ; m.lastFocus.id 
    m.lastFocus.setFocus(true)
end function

function onCategoryItemFocused()    
    print "category item "; m.rowCategoryList.rowItemFocused[1]; " was focused"

    'Get the focused content
    m.focusedContent = m.top.rowListContent.getChild(0).getChild(m.rowCategoryList.rowItemFocused[1])
    
    'call the function to set the video list content
    if (m.focusedContent <> invalid)     
        m.rowVideoList.content = m.focusedContent
    end if
        
end function

function onCategoryItemSelected()    
    print "category item "; m.rowCategoryList.rowItemSelected[1]; " was selected"
        
    'Get the selected content
    selectedContent = m.top.rowListContent.getChild(0).getChild(m.rowCategoryList.rowItemFocused[1])

    setVisible(false, false)
    m.lastFocus = m.rowCategoryList 
            
    'init of video player and start playback
    m.video.content = selectedContent.getChild(0)
    m.video.contentIsPlaylist = true
    m.video.control = "play"
    m.video.visible = true
    m.video.setFocus(true)    
       
end function

function onVideoItemSelected()
    print "video item "; m.rowVideoList.rowItemSelected[1]; " was selected"
        
    'Handle the selected content
    selectedContent = m.focusedContent.getChild(0).getChild(m.rowVideoList.rowItemFocused[1])

    setVisible(false, false)
    m.lastFocus = m.rowVideoList
       
    'set video content and start playback single video
    m.video.content = selectedContent
    m.video.control = "play"
    m.video.visible = true
    m.video.setFocus(true)
    
end function

function setVisible(isRowGroupAndVideoVisible as Boolean, isCategoryVisible as Boolean)
    m.rowGroup.visible = isRowGroupAndVideoVisible
    m.rowVideoList.visible = isRowGroupAndVideoVisible
    m.rowCategoryList.visible = isCategoryVisible
end function

function onVideoPlayerStateChange()
    if m.video.visible = true
        if m.video.state = "error" OR m.video.state = "finished"
            'hide vide player in case of error
            m.video.control = "stop"
            m.video.visible = false

            setVisible(true, true)        
        end if    
    end if
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    if press then      
        if key = "up" then
        
            if (m.video.visible = true)                
                setVisible(true, false)                
                m.rowVideoList.setFocus(true)        
            else if (m.rowVideoList.hasFocus())
                m.rowCategoryList.setFocus(true) 
            end if
            
        else if key = "down" then
        
            if (m.video.visible = true) 
                print "video is visible"
                setVisible(false, false)
                m.video.setFocus(true)    
            else if (m.rowCategoryList.hasFocus())
                print "set focus to video list"
                m.rowVideoList.visible = true
                m.rowVideoList.setFocus(true)   
            end if
            
        else if key = "back"
        
            if (m.video.visible = true)                
                m.video.control = "stop"
                m.video.visible = false
                
                setVisible(true, true)
                return true
            end if
            
        end if
    end if

    return false
end function

