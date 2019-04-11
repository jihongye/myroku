function init()   
    m.videoPoster  = m.top.findNode("videoPoster")
    m.playIcon    = m.top.findNode("playIcon")
    
    m.videoItemLabel = m.top.findNode("videoItemLabel")
    
end function

function videoItemContentChanged()
    m.videoPoster.uri = m.top.itemContent.HDPosterURL
    m.videoItemLabel.text = m.top.itemContent.title

    updateLayout()
end function

function widthChanged()
    updateLayout()
end function

function heightChanged()
    updateLayout()
end function

function updateLayout()
    if m.top.height > 0 and m.top.width > 0 
        topWidth = m.top.width
        topHeight = m.top.height
        
        'The following is for showing videos quantityp in playlist
        m.videoPoster.width  = topWidth 
        m.videoPoster.height = topHeight * 0.8
        m.videoPoster.loadWidth = m.videoPoster.width
        m.videoPoster.loadHeight = m.videoPoster.height
        m.videoPoster.translation = [0, 0]
   
        m.playIcon.translation = [(m.videoPoster.width-m.playIcon.width)/2, (m.videoPoster.height-m.playIcon.height)/2]
        
        m.videoItemLabel.width = topWidth
        m.videoItemLabel.height = topHeight - m.videoPoster.height
        m.videoItemLabel.translation = [0, m.videoPoster.height]
        
    end if
end function

