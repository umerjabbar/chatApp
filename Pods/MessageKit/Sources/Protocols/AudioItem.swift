//
//  AudioItem.swift
//  MessageKit
//
//  Created by Umer Jabbar on 8/17/18.
//  Copyright © 2018 MessageKit. All rights reserved.
//

import Foundation

/// A protocol used to represent the data for a media message.
public protocol AudioItem {
    
    /// The url where the media is located.
    var url: URL? { get }
    
    /// The audio.
    var audio: Data? { get }
    
    /// A placeholder image for when the image is obtained asychronously.
    var placeholderImage: UIImage { get }
    
    /// The size of the media item.
    var size: CGSize { get }
    
}
