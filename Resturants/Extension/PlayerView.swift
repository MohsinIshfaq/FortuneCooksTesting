//
//  PlayerView.swift
//  Resturants
//
//  Created by Coder Crew on 28/05/2024.
//

import Foundation
import UIKit
import AVKit;
import AVFoundation;

class PlayerView: UIView {
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
}


import Foundation

public class videosMediaCache: NSObject {
  static let sharedInstance = videosMediaCache()
  let memCache = NSCache<NSString, NSData>()
  public func cacheItem(_ mediaItem: Data, forKey key: String) {
    memCache.setObject(mediaItem as NSData, forKey: key as NSString)
  }
  
  public func getItem(forKey key: String) -> Data? {
    return memCache.object(forKey: key as NSString) as Data?
  }
}
