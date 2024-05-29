//
//  VideosSectionController.swift
//  Resturants
//
//  Created by Coder Crew on 28/05/2024.
//

import Foundation
import IGListKit
import CoreImage
import CachingPlayerItem
import AVFoundation

protocol VideosModelUpdatable {
    
    func updateWith(videos: Videos)
    func setImage(image: UIImage)
    func playVideo(videoPlayer: AVPlayer)
    func setupForProfileVideos(fromProfile: Bool)
}

//MARK: - Enums
enum Index: Int {
    case videoView
}

protocol sectionControllerDelegate {
    
    func didTappedComments(sender: String, id: String, thumbnail: String, title: String)
    func displayingCell(index: Int)
    
    func willDisplayingSection(videoURL: String, videoID: String, videoThumb: String)
    func endDisplayingSection(videoURL: String, videoID: String, videoThumb: String)
}

class VideosSectionController: ListSectionController {
    
    //MARK: - Variables and Properties
    var fromProfile = false
    var currentVideo: Videos?
    private var downloadedImage: UIImage?
    private var task: URLSessionDataTask?
    private var videoPlayer: AVPlayer?
    private var displayingVideoURL: String = ""
    private var displayingVideoID: String = ""
    private var displayingThumb: String = ""
    private var displayingVideoTitle: String = ""
    //private var displayingVideoProfile: User_Profiles_Model = User_Profiles_Model()
    var sectionDelegate: sectionControllerDelegate? = nil
    
    
    //MARK: - Initializers and Overridings
    deinit {
        task?.cancel()
    }
    
    override init() {
        super.init()
        workingRangeDelegate = self
        displayDelegate = self
    }
    
    override func didUpdate(to object: Any) {
        guard let superHero = object as? Videos else {
            return
        }
        currentVideo = superHero
        
    }
    
    override func numberOfItems() -> Int {
        return 1 // One hero will be represented by one cell
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let nibName = String(describing: IGBizTokVideoCell.self)
        guard let ctx = collectionContext, let video = currentVideo  else {
            return UICollectionViewCell()
        }

        let cell = ctx.dequeueReusableCell(withNibName: nibName, bundle: nil, for: self, at: index)
        guard let thisCell = cell as? IGBizTokVideoCell else {
            return cell
        }
        guard let videosCell = cell as? VideosModelUpdatable else {
            return cell
        }
        
        thisCell.cellDelegate = self
        thisCell.btnComment.tag = index
        
        if let cell2 = self.collectionContext?.cellForItem(at: index, sectionController: self) as? IGBizTokVideoCell {
            
            cell2.btnPlay.tag = self.section
        }
        
        videosCell.updateWith(videos: video)
        videosCell.setupForProfileVideos(fromProfile: fromProfile)
        videosCell.setImage(image: downloadedImage ?? UIImage(named: "bgImg")!)
        if videoPlayer != nil {
            videosCell.playVideo(videoPlayer: videoPlayer!)
        }
        
        return cell
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext?.containerSize.width ?? 0
        let height = collectionContext?.containerSize.height ?? 0
        return CGSize(width: width, height: height)
    }
    
    func visibleSectionControllers() -> [ListSectionController]{
        
        return visibleSectionControllers()
    }
    
    
}

//MARK: - Extension Section Controller Delegates
extension VideosSectionController: ListWorkingRangeDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerWillEnterWorkingRange sectionController: ListSectionController) {
        
        //Fetch Thumbnail Image
//        guard downloadedImage == nil,
//            task == nil,
//              let urlString = currentVideo?.imgThumbnail,
//            let url = URL(string: urlString)
//            else { return }
//
//        print("Downloading image \(urlString) for section \(self.section)")
//
//        task = URLSession.shared.dataTask(with: url) { data, _, error in
//            guard let data = data, let image = UIImage(data: data) else {
//                return print("Error downloading \(urlString): " + String(describing: error))
//            }
//            DispatchQueue.main.async {
//                self.downloadedImage = image
//                if let cell = self.collectionContext?.cellForItem(at: 0, sectionController: self) as? IGBizTokVideoCell {
//                    cell.setImage(image: image)
//                    cell.cellDelegate = self
//                }
//            }
//        }
//        task?.resume()
        //––––––––––––––––––––
        
        //Fetch Video
        guard videoPlayer == nil,
              let urlString = currentVideo?.videoUrl,
            let videoURL = URL(string: urlString)
            else { return }
        
        var playerItem = CachingPlayerItem(url: videoURL)
        
        if let videoData = videosMediaCache.sharedInstance.getItem(forKey: currentVideo?.videoUrl ?? "unknown") {
            
            do {
                try playerItem = CachingPlayerItem(data: videoData as Data, customFileExtension: "mp4")
            } catch {
                print("Video not found in Cache")
            }
        
        } else {
            playerItem = CachingPlayerItem(url: videoURL, customFileExtension: "mp4")
        }
        
        let Video = AVPlayer(playerItem: playerItem)
        Video.automaticallyWaitsToMinimizeStalling = false
        
        
        DispatchQueue.main.async {
            self.videoPlayer = Video
            if let cell = self.collectionContext?.cellForItem(at: 0, sectionController: self) as? IGBizTokVideoCell {

                cell.playVideo(videoPlayer: Video)
                cell.replayObserver()

            }
        }
        //––––––––––––––––––––––
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerDidExitWorkingRange sectionController: ListSectionController) {
        
        //let cell = sectionController.cellForItem(at: section) as! IGBizTokVideoCell
//        cell.videoPlayer?.pause()
        print("Exit")
    }
    
}

extension VideosSectionController: ListDisplayDelegate {
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController) {
        print("ListDisplayDelegate: Will display section \(self.section)")
        let cell = sectionController.cellForItem(at: section) as! IGBizTokVideoCell
        cell.videoPlayer?.seek(to: CMTime.zero)
        cell.videoPlayer?.play()
        
        self.sectionDelegate?.displayingCell(index: section)
        
        self.displayingVideoID = cell.videoID
        self.displayingVideoURL = cell.videoURL
        self.displayingThumb = cell.thumbnail
       // self.displayingVideoProfile = cell.userProfile
        self.displayingVideoTitle = cell.title
        self.sectionDelegate?.willDisplayingSection(videoURL: cell.videoURL, videoID: cell.videoID, videoThumb: cell.thumbnail)
        
    }
    
    func listAdapter(_ listAdapter: ListAdapter, willDisplay sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        print("ListDisplayDelegate: Did will display cell \(index) in section \(self.section)")
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController) {
        print("ListDisplayDelegate: Did end displaying section \(self.section)")
        let cell = sectionController.cellForItem(at: section) as! IGBizTokVideoCell
        cell.isDescriptionExpanded = false
        cell.videoPlayer?.pause()
        sectionDelegate?.endDisplayingSection(videoURL: cell.videoURL, videoID: cell.videoID, videoThumb: cell.thumbnail)
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying sectionController: ListSectionController, cell: UICollectionViewCell, at index: Int) {
        print("ListDisplayDelegate: Did end displaying cell \(index) in section \(self.section)")
    }
}


extension VideosSectionController: bizTokCellDelegate {
    func onTapComments(sender: String, id: String, thumbnail: String, title: String) {
        
        sectionDelegate?.didTappedComments(sender: sender, id: id, thumbnail: thumbnail, title: title)
    }
    
}
