'Interface for reading data from JSON
function readMetaData()
    'Json location
    datafile = "pkg:/json/roku-front.json"
    
    'Get JSON data structure and assign it to top interface
    m.top.content = readDataFromJSON(datafile)

end function

'Read data from JSON and store it to list data structure
function readDataFromJSON(fileName as String) as object
    'get data from source
    jsonAsString = ReadAsciiFile(fileName)
    
    'Parse JSON string
    json = ParseJSON(jsonAsString)
    
    contentNode = createObject("RoSGNode","ContentNode")
    rowNode = contentNode.createChild("ContentNode")
    rowNode.title = "Themed News"
    
    for each playList in json.entries
        itemCategory = rowNode.createChild("ContentNode")
        itemCategory.title = playList.Title
      
        'There're some playlist which don't have background image
        'Since thumbnail is needed for each playlist, we use an backup image
        if (playList.background <> invalid)
            itemCategory.SDPosterURL = playList.background 
            itemCategory.HDPosterURL = playList.background
        else
            itemCategory.SDPosterURL = "pkg:/images/Pic_Backup.png" 
            itemCategory.HDPosterURL = "pkg:/images/Pic_Backup.png"
        end if

        for each video in playList.entries
            itemVideo = itemCategory.createChild("ContentNode")
            itemVideo.title = video.Title                        
            itemVideo.ReleaseDate = video.ReleaseDate
            itemVideo.Description = video.Description
            itemVideo.Url = video.Url            
            itemVideo.HDPosterUrl = video.HDPosterUrl            
        end for

    end for
    
    return contentNode
end function

