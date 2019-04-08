function init()
    print "in RowListTestScene init()"

    m.top.panelSet.visible = true

    ' create the RowListExamplesListPanel and add it to the PanelSet
    m.categoryRowListPanel = createObject("RoSGNode", "CategoryRowListPanel")

    m.top.panelSet.appendChild(m.categoryRowListPanel)
end function
