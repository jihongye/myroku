function init()
    
    m.rowList = m.top.findNode("categoryRowList")
    m.rowList.visible = false
    m.rowList.numRows = 1
    
    m.rowVideoList = m.top.findNode("videoRowList")
        
    m.rowList.itemSize = [ 1920, 450 ]
    m.rowList.itemComponentName = "MoreInfoOnFocusItem"
        
    m.top.observeField("focusedChild", "focusChanged")

    m.top.id = "MainScene"
    m.top.visible = true

    m.readerTask = createObject("roSGNode", "ContentReader")
    m.readerTask.observeField("content", "readContent")
    m.readerTask.control = "RUN"
end function

function readContent()
    print "gotContent()"
    
    if m.readerTask.content = invalid
        print "invalid data content"
    else
        m.top.rowListContent = m.readerTask.content
    end if
end function

function focusChanged()
    if m.top.isInFocusChain()
    if not m.rowList.hasFocus()
            m.rowList.setFocus(true)            
        end if
    end if
end function

function itemFocused()
    print "item "; m.rowList.rowItemFocused[1]; " in row "; m.rowList.rowItemFocused[0]; " was focused"
    print "ITEM Focus"
    print m.top.rowListContent.getChild(0).getChild(m.rowList.rowItemFocused[1])

end function

function itemSelected()
    print "item "; m.rowList.rowItemSelected[1]; " in row "; m.rowList.rowItemSelected[0]; " was selected"
    print m.top.rowListContent.getChild(0).getChild(m.rowList.rowItemFocused[1]).getChild(0)
    
end function

function rowListContentChanged()

    m.rowList.rowItemSize = [ [350, 350] ]

    m.rowList.rowItemSpacing = [ [20, 20] ]
    m.rowList.focusXOffset = 0

    m.rowList.showRowLabel   = true
    m.rowList.showRowCounter = true

    m.rowList.rowLabelOffset = [ [0, 20] ]

    m.rowList.rowFocusAnimationStyle = "fixedFocusWrap"

    m.rowList.content = m.top.rowListContent
    
    m.rowList.visible = true

    m.rowList.observeField("rowItemSelected", "itemSelected")
    m.rowList.observeField("rowItemFocused",  "itemFocused")

end function