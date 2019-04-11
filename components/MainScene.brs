function init()
    print "in MainScene init()"
        
    m.readerTask = createObject("roSGNode", "ContentReader")
    m.readerTask.observeField("content", "setCategories")
    m.readerTask.control = "RUN"
end function


function setCategories()
    print "setCategories()"
    
    if m.readerTask.content = invalid
        print "invalid data content"
    else        
        m.categoryRowListPanel = m.top.createChild("CategoryRowListPanel")
        m.categoryRowListPanel.rowListContent = m.readerTask.content                
    end if
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    if press then
        if key = "back"
            print "pressed back"

        end if
    end if

      return false
end function