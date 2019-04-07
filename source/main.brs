Function Main() as void
    print "App Start----------------"
    
    InitTheme()
    
    listContent = FetchDataFromJSON()
    ShowPosterScreen(listContent)
    
End Function

'Set theme for the scene
Function InitTheme() as void
    app = CreateObject("roAppManager")

    theme = {
        OverhangOffsetSD_X:         "18"
        OverhangOffsetSD_Y:         "0"
        OverhangSliceSD:            "pkg:/images/Overhang_BackgroundSlice_SD.png"
        OverhangLogoSD:             "pkg:/images/json.png"
        OverhangOffsetHD_X:         "18"
        OverhangOffsetHD_Y:         "0"
        OverhangSliceHD:            "pkg:/images/Overhang_BackgroundSlice_HD.png"
        OverhangLogoHD:             "pkg:/images/json.png"
    }
    app.SetTheme(theme)

End Function

'store the data in the list object by following the json structure
Function FetchDataFromJSON() as object
    'jsonAsString = ReadAsciiFile("https://dl.dropboxusercontent.com/s/rwkc3hntz1q9ph6/roku-front.json")
    jsonAsString = ReadAsciiFile("pkg:/json/roku-front.json")
    json = ParseJSON(jsonAsString)
    
    result = []    
    for each playList in json.entries
        category = {}
        category.ShortDescriptionLine1 = playList.Title
        category.SDPosterURL = playList.background 
        category.HDPosterURL = playList.background
        
        category.videos = []
        
        for each video in playList.entries
            item = {}
            item.Title = video.title
            item.ReleaseDate = video.published
            item.Description = video.summary
            item.Url = video.contentSrc            
            item.HDPosterUrl = video.mainArtUrl

            category.videos.push(item)
        end for

        result.push(category)
    end for
    
    return result

End Function

'The Poster screen displys the entries about different categories
Function ShowPosterScreen(entries as object) as integer
    print "ShowPosterScreen"
    
    posterScreen = CreateObject("roPosterScreen")
    port = CreateObject("roMessagePort")      
    posterScreen.SetMessagePort(port)
    posterScreen.SetBreadcrumbText("My First Roku App", "")

    contentList = CreateObject("roArray", 2, true)
    for each category in entries
        poster = CreateObject("roAssociativeArray")

        poster.ShortDescriptionLine1 = category.Title
        if (category.SDPosterURL <> invalid)
            poster.SDPosterURL = category.SDPosterURL 
            poster.HDPosterURL = category.HDPosterURL
        else
            poster.SDPosterURL = "pkg:/images/Pic_Backup.png"
            poster.HDPosterURL = "pkg:/images/Pic_Backup.png"
        end if
        
        contentList.push( poster )
    end for

    if contentList <> invalid
        posterScreen.SetContentList(contentList)
        posterScreen.SetFocusedListItem(0)
    end if
    
    posterScreen.show()

    while (true)
        msg = wait(0, port)
        if type(msg) = "roPosterScreenEvent"
            if (msg.isListItemSelected())                
                PlayVideo(entries[msg.GetIndex()].videos, 0)
            else if (msg.isScreenClosed())
                return -1
            end if
        endif
    end while

End Function

'Play all the video in each entry
Function PlayVideo(videos as object, index as integer) as integer
    print "Play video..."
    
    videoScreen = CreateObject("roVideoScreen")
    port = CreateObject("roMessagePort")
    videoScreen.SetMessagePort( port )
    

    metaData = {
        ContentType: "episode",
        Title: videos[index].Title,
        Description: videos[index].Description,
        Stream: {
            Url: videos[index].Url
        }
    }

    videoScreen.SetContent( metaData )
    videoScreen.show()
    
    while (true)
        msg = wait(0, port)
        if type(msg) = "roVideoScreenEvent"
            if (msg.isStatusMessage())
                if (msg.GetMessage() = "end of playlist")
                    return -1
                else if (msg.GetMessage() = "end of stream")
                    print "The current video clip is at the end"
                    
                    if (index + 1 < videos.Count())
                        PlayVideo(videos, index + 1)
                    end if
                end if
            end if
            if (msg.isScreenClosed())
                return -1
            end if
        endif
    end while
    
End Function
