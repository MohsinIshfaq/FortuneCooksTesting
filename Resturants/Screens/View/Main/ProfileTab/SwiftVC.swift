//
//  SwiftVC.swift
//  Resturants
//
//  Created by Coder Crew on 27/05/2024.
//

import UIKit
import IGListKit
import CloudKit
import FirebaseStorage

protocol IGBizTokDelegate {
    func didDeletedVideo(index: Int)
}
protocol UploadVideoDelegate {
    func videoUploaded()
}

class SwiftVC: UIViewController {

    @IBOutlet weak var cvVideos: UICollectionView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var btnCancel: UIButton!

    var responseModel   : [ProfileVideosModel]? = []
    var videos          : [ListDiffable] = []
    var delegate        : IGBizTokDelegate? = nil
    var refreshControl  : OffsetableRefreshControl!
    
    lazy var adapter: ListAdapter =  {
        let updater = ListAdapterUpdater()
        let adapter = ListAdapter(updater: updater, viewController: self, workingRangeSize: 1)
        adapter.collectionView = cvVideos
        adapter.dataSource = videos as? ListAdapterDataSource
        return adapter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        _ = adapter
        adapter.dataSource = self
        setUpVideos()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func setupView() {
        cvVideos.frame = UIScreen.main.bounds
        cvVideos.contentInsetAdjustmentBehavior = .never
        cvVideos.contentInset.bottom = cvVideos.safeAreaInsets.bottom
    }

    func setUpVideos() {
        if let response = responseModel {
            for i in response {
                let video = Videos(identifier: UUID().uuidString, address: i.address ?? "", Zipcode: i.Zipcode ?? "", city: i.city ?? "", hashTagsModelList: i.hashtages ?? [], Title: i.Title ?? "", description: i.description ?? "", language: i.language ?? "", ThumbnailUrl: i.thumbnailUrl ?? "", videoUrl: i.videoUrl ?? "")
                self.videos.append(video)
            }
            self.adapter.reloadData(completion: nil)
        }
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        stopAllVideoPlayback()
//    }
//
//    func stopAllVideoPlayback() {
//        if let visibleSectionControllers = adapter.visibleSectionControllers() as? [VideosSectionController] {
//            for sectionController in visibleSectionControllers {
//                sectionController.stopVideoPlayback()
//            }
//        }
//    }
    
    @IBAction func onTapCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @objc func refresh(_ sender: AnyObject) {
    }
}

//MARK: - List Adapters DataSource
extension SwiftVC : ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return videos
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        let sectionController = VideosSectionController()
        sectionController.sectionDelegate = self
        sectionController.fromProfile = true
        return sectionController
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

//MARK: - Share
extension SwiftVC {
    func sharePost(code: String){
//        // Setting description
//        let firstActivityItem = "Check this Post"
//        
//        // Setting url
//        let secondActivityItem = "\(Constants.APP_BASE_URL + "posts/" + code)"
//        let activityViewController : UIActivityViewController = UIActivityViewController(
//            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
//        
//        // This lines is for the popover you need to show in iPad
//        activityViewController.popoverPresentationController?.sourceView = self.view
//        
//        // This line remove the arrow of the popover to show in iPad
//        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
//        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
//        
//        // Pre-configuring activity items
//        activityViewController.activityItemsConfiguration = [
//            UIActivity.ActivityType.message
//        ] as? UIActivityItemsConfigurationReading
//        
//        // Anything you want to exclude
//        activityViewController.excludedActivityTypes = [
//            UIActivity.ActivityType.postToWeibo,
//            UIActivity.ActivityType.print,
//            UIActivity.ActivityType.assignToContact,
//            UIActivity.ActivityType.saveToCameraRoll,
//            UIActivity.ActivityType.addToReadingList,
//            UIActivity.ActivityType.postToFlickr,
//            UIActivity.ActivityType.postToVimeo,
//            UIActivity.ActivityType.postToTencentWeibo,
//            UIActivity.ActivityType.postToFacebook
//        ]
//        activityViewController.isModalInPresentation = true
//        self.present(activityViewController, animated: true, completion: nil)
    }
}

//MARK: - My Custom Delegates
extension SwiftVC: sectionControllerDelegate {
    
    func didTappedComments(sender: String, id: String, thumbnail: String, title: String) {
        
//        if sender == "btnComments" {
//            let nextVC = Constants.BiztokStoryboard.instantiateViewController(withIdentifier: "MessageCommentsVC") as! MessageCommentsVC
//            nextVC.thumbnail = thumbnail
//            nextVC.titleV = title
//            nextVC.postId = id
//            nextVC.userProfile = userProfile
//            self.present(nextVC, animated: true)
//            
//        } else if sender == "lblUsername" {
//            
//            let nextVC = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "ContactProfileVC") as! ContactProfileVC
//            nextVC.fromBizTok = true
//            nextVC.fromBizTokProfileID = id
//            nextVC.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(nextVC, animated: true)
//            
//        } else if sender == "btnLike" {
//            
//            print("Like", id)
//            
//        }
////        else if sender == "btnReport" {
////
////        }
//    else if sender == "btnShare" {
//            
//            sharePost(code: id)
//        }
////        else if sender == "btnOptions" {
////
////        }
//        
    }
    
    func displayingCell(index: Int) {
//        let videoCount = self.videos.count
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//            self.incrementPostViews(videoID: (self.videos[index] as? Videos)?.id ?? "")
//        })
//        if index == videoCount - 3 {
//            
//            print("Displaying Last index")
//            if self.links.next ?? "" != "" {
//                if isSelectedGlobal {
//                    getNewsfeedNextPage(url: (self.links.next ?? "") + "&region=global")
//                } else {
//                    getNewsfeedNextPage(url: (self.links.next ?? "") + "&region=\(UserManager.shared.loggedInUser.user.region ?? "")")
//                }
//            }
//            
//        }
        
    }
    
    func willDisplayingSection(videoURL: String, videoID: String, videoThumb: String) {
        
//        self.displayingVideoID = videoID
//        self.displayingVideoURL = videoURL
//        self.displayingThumbnail = videoThumb
//        self.displayingProfile = videoProfile
//        
//        if self.displayedVideoID == "" {
//            setOptionsAndReportBtn(id: self.displayingProfile.user_id ?? "")
//        }
    }
    
    func endDisplayingSection(videoURL: String, videoID: String, videoThumb: String) {
        print("end")
//        if self.displayingVideoID != videoID {
//            setOptionsAndReportBtn(id: self.displayingProfile.user_id ?? "")
//        }
    }
}

//MARK: - Custom Delegates
extension SwiftVC: UploadVideoDelegate {
    func videoUploaded() {
    }
}

class OffsetableRefreshControl: UIRefreshControl {
    
    var offset: CGFloat = 64
    
    init(offset: CGFloat) {
        super.init()
        self.offset = offset
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var frame: CGRect {
        set {
            var rect = newValue
            rect.origin.y += offset
            super.frame = rect
        }
        get {
            return super.frame
        }
    }
    
}
