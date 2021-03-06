//
//  HttpConnection.swift
//  Album
//

import Foundation

class HttpConnection: HttpConnectionInterface {

    private var url: String
    
    init(url: String) {
        self.url = url
    }
    
    func submit(param: String?, callback: ( (nsData:NSData?, response: NSURLResponse?, error: NSError?) -> Void) ) {
     
        /**
        complete this section
        */
        let urlPath = NSString(format: self.url, param!)
        
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            println("Task completed")
            callback(nsData: data, response: response, error: error)
        })
        task.resume()
    }
}