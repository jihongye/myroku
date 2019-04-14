function init()   
    m.categoryPoster  = m.top.findNode("categoryPoster")
    m.overlayGroup = m.top.findNode("overlayGroup")
    m.overlayContent = m.top.findNode("overlayContent")
    m.overlayBG   = m.top.findNode("overlayBG")
    m.playIcon    = m.top.findNode("playIcon")
    m.labelPlayAll   = m.top.findNode("labelPlayAll")
    
    m.labelTitle = m.top.findNode("labelTitle")
    
end function

function itemContentChanged()

    m.categoryPoster.uri = m.top.itemContent.HDPosterURL

    m.labelPlayAll.text = "Play All"    
    m.labelTitle.text = m.top.itemContent.title

    updateLayout()
end function

function widthChanged()
    updateLayout()
end function

function heightChanged()
    updateLayout()
end function

function focusPercentChanged()    
    m.overlayGroup.opacity = m.top.focusPercent
    m.overlayGroup.visible = m.top.rowListHasFocus and (m.overlayGroup.opacity > 0)
end function

function updateLayout()
    if m.top.height > 0 and m.top.width > 0 
        topWidth = m.top.width
        topHeight = m.top.height

        m.categoryPoster.width  = topWidth 
        m.categoryPoster.height = topHeight * 0.8
        m.categoryPoster.loadWidth = m.categoryPoster.width
        m.categoryPoster.loadHeight = m.categoryPoster.height
        m.categoryPoster.translation = [0, 0]
        
        m.overlayBG.width  = topWidth
        m.overlayBG.height = m.categoryPoster.height / 4
        m.overlayBG.translation = [0, m.categoryPoster.height - m.overlayBG.height ]        
        m.overlayContent.translation = [ 0, (m.overlayBG.height - m.playIcon.height) / 2 ]    
        
        m.labelTitle.width = topWidth
        m.labelTitle.height = topHeight - m.categoryPoster.height
        m.labelTitle.translation = [0, m.categoryPoster.height]        
    end if
end function

