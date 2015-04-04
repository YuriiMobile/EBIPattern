//
//  GetAlbumInteractor.swift
//  Album
//
//

import Foundation

class GetAlbumInteractor: GetAlbumInteractorInterface {
    private var albumDao: AlbumDaoInterface
    private var albumSorter: AlbumSortInterface
    
    init(albumDao: AlbumDaoInterface, sorter: AlbumSortInterface) {
        self.albumDao = albumDao
        self.albumSorter = sorter
    }
    
    func getAlbum(getAlbumRequest: GetAlbumRequestInterface, getAlbumResponse: GetAlbumResponseInterface)  {
        self.albumDao.getAlbum(
            getAlbumRequest.getArtistName()!,
            callback: {(nsData:NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                var requestCallback = getAlbumRequest.getCallback()
                self.processResponse(requestCallback!, nsData: nsData, response: response, error: error, getAlbumResponse: getAlbumResponse)
        })
    }
    
    
    func processResponse(
        callback: ((GetAlbumResponseInterface)->Void),
        nsData: NSData?,
        response:NSURLResponse?,
        error:NSError?,
        getAlbumResponse: GetAlbumResponseInterface
    )  {
        
        /**
        Complete this section
        */
        var albumCollection = [AlbumInterface]()
        
        let httpResponse = response as NSHTTPURLResponse
        let statusCode = httpResponse.statusCode
        switch (httpResponse.statusCode) {
        case 201, 200, 401:
            println("status")
        default:
            println("ignore")
        }
        
        if(error != nil) {
            // If there is an error in the web request, print it to the console
            println("error occured")
        } else {
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(nsData!, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if(err != nil) {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }
            let results: NSArray = jsonResult["results"] as NSArray
            for album in results {
                albumCollection.append(self.mapData(album as NSDictionary))
            }
            getAlbumResponse.setAlbums(albumCollection)
            callback(getAlbumResponse)
        }
    }
    
    private func mapData(jsonData: NSDictionary) -> AlbumInterface {
        /**
        Complete this section
        */
        var albumTitle = jsonData["trackName"] as? NSString // Get album name
        if albumTitle == nil {
            albumTitle = jsonData["collectionName"] as? NSString
        }
        
        var album = Album()
        album.setTitle(albumTitle)
        album.setImage(jsonData["artworkUrl100"] as NSString)
        
        var priceVal = jsonData["formattedPrice"] as? NSString // Get album price
        if priceVal == nil {
            priceVal = jsonData["collectionPrice"] as? NSString
            if priceVal == nil {
                var priceFloat: Float? = jsonData["collectionPrice"] as? Float
                if priceFloat != nil {
                    priceVal = NSString(format: "$%.02f", priceFloat!)
                }
                
            }
        }
        
        album.setPrice(priceVal!.doubleValue)
        return album
    }
 }