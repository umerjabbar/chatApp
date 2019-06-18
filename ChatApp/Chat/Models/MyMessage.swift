//
//  MyMessage.swift
//  Akhdmny
//
//  Created by Umer Jabbar on 10/09/2018.
//  Copyright © 2018 ZotionApps. All rights reserved.
//

import Foundation
import CoreLocation
import MessageKit
import Kingfisher
import Alamofire

private struct MyLocationItem: LocationItem {
    
    var location: CLLocation
    var size: CGSize
    
    init(location: CLLocation) {
        self.location = location
        self.size = CGSize(width: 240, height: 240)
    }
    
}

private struct MyMediaItem: MediaItem {
    
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
    
    init(imageUrl: URL) {
        self.url = imageUrl
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = #imageLiteral(resourceName: "logoPlaceHolder")
    }
    
    init(audioUrl: URL) {
        self.url = audioUrl
        self.size = CGSize(width: 100, height: 40)
        self.placeholderImage = UIImage()
    }
    
    init(imageUrl : String) {
        self.placeholderImage = #imageLiteral(resourceName: "logoPlaceHolder")
        self.size = CGSize(width: 240, height: 240)
    }
    
}

internal struct MyMessage: MessageType {
    
    var messageId: String
    var sender: Sender
    var sentDate: Date
    var kind: MessageKind
    var status: Status
    
    private init(kind: MessageKind, sender: Sender, messageId: String, date: Date, status : Status) {
        self.kind = kind
        self.sender = sender
        self.messageId = messageId
        self.sentDate = date
        self.status = status
    }
    
    init(text: String, sender: Sender, messageId: String, date: Date, status : Status) {
        self.init(kind: .text(text), sender: sender, messageId: messageId, date: date, status : status)
    }
    
    init(attributedText: NSAttributedString, sender: Sender, messageId: String, date: Date, status : Status) {
        self.init(kind: .attributedText(attributedText), sender: sender, messageId: messageId, date: date, status : status)
    }
    
    init(image: UIImage, sender: Sender, messageId: String, date: Date, status : Status) {
        let mediaItem = MyMediaItem(image: image)
        self.init(kind: .photo(mediaItem), sender: sender, messageId: messageId, date: date, status : status)
    }
    
    init(imageUrl: URL, sender: Sender, messageId: String, date: Date, status: Status) {
        let mediaItem = MyMediaItem(imageUrl: imageUrl)
        self.init(kind: .photo(mediaItem), sender: sender, messageId: messageId, date: date, status: status)
    }
    
    init(imageUrl: String, sender: Sender, messageId: String, date: Date, status : Status) {
        
        let mediaItem = MyMediaItem(imageUrl: imageUrl)
        self.init(kind: .photo(mediaItem), sender: sender, messageId: messageId, date: date, status : status)
        
    }
    
    init(thumbnail: UIImage, sender: Sender, messageId: String, date: Date, status : Status) {
        let mediaItem = MyMediaItem(image: thumbnail)
        self.init(kind: .video(mediaItem), sender: sender, messageId: messageId, date: date, status : status)
    }
    
    init(audioUrl: URL, sender: Sender, messageId: String, date: Date, status : Status) {
        let mediaItem = MyMediaItem(audioUrl: audioUrl)
        self.init(kind: .audio(mediaItem), sender: sender, messageId: messageId, date: date, status : status)
    }
    
    init(location: CLLocation, sender: Sender, messageId: String, date: Date, status : Status) {
        let locationItem = MyLocationItem(location: location)
        self.init(kind: .location(locationItem), sender: sender, messageId: messageId, date: date, status : status)
    }
    
    init(emoji: String, sender: Sender, messageId: String, date: Date, status : Status) {
        self.init(kind: .emoji(emoji), sender: sender, messageId: messageId, date: date, status : status)
    }
    
}

