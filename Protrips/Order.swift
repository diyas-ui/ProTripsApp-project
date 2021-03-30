//
//  Order.swift
//  Protrips
//
//  Created by mac on 12/16/20.
//

import Foundation
import FirebaseDatabase

struct Order {
    var content : String?
    var author: String?
    var time: String?
    var secondContent : String?
    var dict: [String : String]{
        return[
            "content" : content!,
            "time" : time!,
            "author" : author!,
            "secondContent" : secondContent!
        ]
    }
    init(_ content: String,_ author: String,_ time: String, _ secondContent: String){
        self.content = content
        self.author = author
        self.time = time
        self.secondContent = secondContent
    }
    init(snapshot: DataSnapshot){
        if let value = snapshot.value as? [String: String]{
            content = value["content"]
            author = value["author"]
            time = value["time"]
            secondContent = value["secondContent"]
        }
    }
    
}
