'Interface for reading data from JSON
function readMetaData()
    'Json location    
    datafile = "https://dl.dropboxusercontent.com/s/rwkc3hntz1q9ph6/roku-front.json"
    
    'Get JSON data structure and assign it to top interface
    m.top.content = readDataFromJSON(datafile)

end function

'Read data from JSON and store it to list data structure
function readDataFromJSON(fileName as String) as object
    'get data from source
    request = CreateObject("roUrlTransfer")
    request.SetURL(fileName)
    
    'Set cert file for dropbox
    request.SetCertificatesFile("pkg:/certs/dropbox.crt")
    jsonAsString = request.GetToString()
    
    'Parse JSON string
    json = ParseJSON(jsonAsString)
    
    contentNode = createObject("RoSGNode","ContentNode")
    rowNode = contentNode.createChild("ContentNode")
    rowNode.title = "Themed News"
    
    for each category in json.entries
        categoryNode = rowNode.createChild("ContentNode")
        categoryNode.title = category.title
      
        'There're some category which don't have background image
        'Since thumbnail is needed for each category, we use an backup image
        if (category.background <> invalid)
            categoryNode.SDPosterURL = category.background 
            categoryNode.HDPosterURL = category.background
        else
            categoryNode.SDPosterURL = "pkg:/images/Pic_Backup.png" 
            categoryNode.HDPosterURL = "pkg:/images/Pic_Backup.png"
        end if
        
        rowVideo = categoryNode.createChild("ContentNode")
        rowVideo.title = category.title
        for each video in category.entries
            videoNode = rowVideo.createChild("ContentNode")
            videoNode.title = video.title                        
            videoNode.ReleaseDate = video.published
            videoNode.Description = video.summary
            videoNode.duration = video.videoDuration            
            videoNode.Url = video.contentSrc            
            videoNode.HDPosterUrl = video.mainArtUrl            
        end for

    end for
    
    return contentNode
end function
