function init()   
    m.videoPoster  = m.top.findNode("videoPoster")
    m.playIcon    = m.top.findNode("playIcon")
    m.labelVideoTitle = m.top.findNode("labelVideoTitle")
    
end function

function videoItemContentChanged()
    m.videoPoster.uri = m.top.itemContent.HDPosterURL
    m.labelVideoTitle.text = m.top.itemContent.title
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

        m.videoPoster.width  = topWidth 
        m.videoPoster.height = topHeight - 80
        m.videoPoster.loadWidth = m.videoPoster.width
        m.videoPoster.loadHeight = m.videoPoster.height        
        m.videoPoster.translation = [0, 0]

        m.playIcon.translation = [m.videoPoster.width / 2 - 20, m.videoPoster.height / 2 - 20]
        
        m.labelVideoTitle.width = topWidth
        m.labelVideoTitle.height = 80
        m.labelVideoTitle.translation = [0, m.videoPoster.height]
        
    end if
end function

