function init()   
    m.itemPoster  = m.top.findNode("itemPoster")
    m.itemOverlay = m.top.findNode("itemOverlay")
    m.overlayContent = m.top.findNode("overlayContent")
    m.overlayBG   = m.top.findNode("overlayBG")
    m.playIcon    = m.top.findNode("playIcon")
    m.labelPlayAll   = m.top.findNode("labelPlayAll")
    
    m.itemLabel = m.top.findNode("itemLabel")
    
end function

function itemContentChanged()

    m.itemPoster.uri = m.top.itemContent.HDPosterURL
    
    'Set the number of the videos in the playlist
    m.labelPlayAll.text = "Play All"    
    m.itemLabel.text = m.top.itemContent.title

    updateLayout()
end function

function widthChanged()
    updateLayout()
end function

function heightChanged()
    updateLayout()
end function

function focusPercentChanged()    
    m.itemOverlay.opacity = m.top.focusPercent
    m.itemOverlay.visible = m.top.rowListHasFocus and (m.itemOverlay.opacity > 0)
end function

function updateLayout()
    if m.top.height > 0 and m.top.width > 0 
        topWidth = m.top.width
        topHeight = m.top.height
        
        'The following is for showing videos quantityp in playlist
        m.itemPoster.width  = topWidth 
        m.itemPoster.height = topHeight * 0.8
        m.itemPoster.loadWidth = m.itemPoster.width
        m.itemPoster.loadHeight = m.itemPoster.height
        m.itemPoster.translation = [0, 0]
        
        m.overlayBG.width  = topWidth
        m.overlayBG.height = m.itemPoster.height / 4
        m.overlayBG.translation = [0, m.itemPoster.height - m.overlayBG.height ]        
        m.overlayContent.translation = [ 0, (m.overlayBG.height - m.playIcon.height) / 2 ]    
        
        m.itemLabel.width = topWidth
        m.itemLabel.height = topHeight - m.itemPoster.height
        m.itemLabel.translation = [0, m.itemPoster.height]        
    end if
end function

