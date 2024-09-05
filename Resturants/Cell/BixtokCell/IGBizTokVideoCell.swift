//
//  IGBizTokVideoCell.swift
//  Resturants
//
//  Created by Coder Crew on 28/05/2024.
//

import UIKit
import SDWebImage
import AVFoundation
import SwiftUI

protocol bizTokCellDelegate: NSObject {

    func onTapComments(sender: String, id: String, thumbnail: String, title: String)
}

class IGBizTokVideoCell: UICollectionViewCell, VideosModelUpdatable {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnOptions: UIButton!
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblShare: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblSocialLinks: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imageThumb: UIImageView!
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var stackComment: UIStackView!
    @IBOutlet weak var stackOptions: UIStackView!
    @IBOutlet weak var stackViews: UIStackView!
    @IBOutlet weak var stackLikes: UIStackView!
    @IBOutlet weak var stackShare: UIStackView!
    @IBOutlet weak var viewReport: UIView!
    @IBOutlet weak var lblViews: UILabel!
    @IBOutlet weak var consDescriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var consBottomView: NSLayoutConstraint!
    @IBOutlet weak var viewUserInfo: UIView!
    @IBOutlet weak var btnAddtoCollect: UIButton!
    
    @IBOutlet weak var viewContactInfo: UIView!
    @IBOutlet weak var imgContactInfo: UIImageView!
    @IBOutlet weak var btnContactInfo: UIButton!
    
    //MARK: - Variables and Properties
    private lazy var spinner = UIActivityIndicatorView(style: .large)
    var videoPlayer: AVPlayer? = nil
    var playing = false
    var videoID = ""
    var thumbnail = ""
    var title = ""
    var profileID = ""
    var videoURL = ""
    var liked = false
    var totalLikes: Int = 0
    var isDescriptionExpanded: Bool = false
    weak var cellDelegate: bizTokCellDelegate? = nil
//    var userProfile = User_Profiles_Model()
//    var contactInfo = Platforms_Data_Model()
    
    //MARK: - Identifier
    static var identifier: String { return String(describing: self) }
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    //MARK: - Identifier
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
        setUpTapGesture()
        viewUserInfo.backgroundColor = .blue.withAlphaComponent(0.3)
        pauseObserver()
    }
    
    
    
    //MARK: - IBActions
    
    @IBAction func onTapPlayBtn(_ sender: Any) {
        playPause()
    }
    
    @IBAction func onTapCommentsBtn(_ sender: Any) {
        guard sender is UIButton else { return }
        cellDelegate?.onTapComments(sender: "btnComments", id: self.videoID, thumbnail: self.thumbnail, title: self.title)
        
    }
    
    @IBAction func onTapLikesBtn(_ sender: Any) {
        if self.liked {
            self.liked = false
            let likes = self.totalLikes
            self.totalLikes = self.totalLikes - 1
            //self.lblLike.text = "\(((likes ) - 1).roundedWithAbbreviations)"
            self.btnLike.setImage(UIImage(named: "thumbsUp_icon"), for: .normal)
        } else {
            self.liked = true
            let likes = self.totalLikes
            self.totalLikes = self.totalLikes + 1
            //self.lblLike.text = "\(((likes) + 1).roundedWithAbbreviations)"
            self.btnLike.setImage(UIImage(named: "liked"), for: .normal)
        }
        btnLike.isEnabled = false
        print("Post-id", videoID)
       // likePost(videoID: videoID)
        
    }
    
    @IBAction func onTapReportBtn(_ sender: Any) {
        
//        guard sender is UIButton else { return }
//        cellDelegate?.onTapComments(sender: "btnReport", id: self.videoID, thumbnail: self.thumbnail, title: self.title, userProfile: self.userProfile)
    }
    
    @IBAction func onTapShareBtn(_ sender: Any) {
        
        guard sender is UIButton else { return }
        cellDelegate?.onTapComments(sender: "btnShare", id: self.videoID, thumbnail: self.thumbnail, title: self.title)
    }
    
    @IBAction func onTapOptions(_ sender: Any) {
        
//        guard sender is UIButton else { return }
//        cellDelegate?.onTapComments(sender: "btnOptions", id: self.videoID, thumbnail: self.thumbnail, title: self.videoURL, userProfile: self.userProfile)
    }
    
    @IBAction func onTapContactInfo(_ sender: Any) {
        if let url = URL(string: "contactInfo.platform") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func didTappedDescription(_ sender: UITapGestureRecognizer) {
        
        if isDescriptionExpanded {
            UIView.animate(withDuration: 0.8) {
                self.consDescriptionHeight.constant = 38
                self.lblDescription.numberOfLines = 2

                self.isDescriptionExpanded = false
            }
        } else {
//            if lblDescription.isTruncated {
//                UIView.animate(withDuration: 0.8) {
//                    self.consDescriptionHeight.constant = 78
//                    self.lblDescription.numberOfLines = 5
//                    self.isDescriptionExpanded = true
//                }
//            }
        }
    }
    
}

//MARK: - @objc Selectors
extension IGBizTokVideoCell {
    
    @objc func onTapNameLbl() {
        
        cellDelegate?.onTapComments(sender: "lblUsername", id: profileID, thumbnail: self.thumbnail, title: self.title)
    }
}

//MARK: - Custom Implementations
extension IGBizTokVideoCell {
    
    func replayObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(videoSeekDidEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.videoPlayer?.currentItem) // Add observer
    }
    
    func pauseObserver() {
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("ViewDisappears"), object: nil, queue: .main) { action in
            self.stopVideo()
            self.removeReplayObserver()
            self.playing = false
        }
    }
    
    func viewAgainAppeared() {
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("viewAgainAppeared"), object: nil, queue: .main) { action in
            self.startVideo()
            self.playing = true
        }
    }
    
    func removeReplayObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.videoPlayer?.currentItem)
    }
    
    @objc func videoSeekDidEnd() {
        
        videoPlayer?.seek(to: CMTime.zero)
        videoPlayer?.play()
    }
    
    func setupCell() {
        
        let openProfile = UITapGestureRecognizer( target: self, action: #selector(onTapNameLbl))
        lblUsername.addGestureRecognizer(openProfile)
        lblUsername.isUserInteractionEnabled = true
        let openProfilee = UITapGestureRecognizer( target: self, action: #selector(onTapNameLbl))
        imgUser.addGestureRecognizer(openProfilee)
        imgUser.isUserInteractionEnabled = true
        let window = UIApplication.shared.windows.first
        let bottomPadding = window?.safeAreaInsets.bottom
        consBottomView.constant = (bottomPadding ?? 0.0) + 50 + 20
        setupLoader()
        
    }
    
    func setupForProfileVideos(fromProfile: Bool) {
        
        if fromProfile == true {
            
            let window = UIApplication.shared.windows.first
            let bottomPadding = window?.safeAreaInsets.bottom
            consBottomView.constant = (bottomPadding ?? 0.0) + 20
        }
        
    }
    
    func updateWith(videos: Videos) {
        
        lblSocialLinks.isHidden = true
       // lblLike.text = "\(Int(videos.likes)?.roundedWithAbbreviations ?? "0")"
       // self.totalLikes = Int(videos.likes) ?? 0
        lblComment.text = "Message"
        lblShare.text = "Share" //videos.shares
        //lblViews.text = videos.shares
//        if videos.display_business_name == 1 {
//            lblUsername.text = (videos.profile?.business_name ?? videos.username).capitalizingFirstLetter()
//        } else {
//            lblUsername.text = videos.username.capitalizingFirstLetter()
//        }
        
//        if videos.have_i_reacted == 1 {
//            self.btnLike.setImage(UIImage(named: "liked"), for: .normal)
//            self.liked = true
//        }
        
        if videos.description == "" {
            lblDescription.isHidden = true
        } else {
            lblDescription.text = videos.description
        }
//        
//        if UserManager.shared.userID == videos.profile?.user_id {
//            stackComment.isHidden = true
//        } else {
//            stackComment.isHidden = false
//        }
        
//        if videos.id == "ad_video" {
//            stackViews.isHidden = true
//            stackLikes.isHidden = true
//            stackComment.isHidden = true
//            stackShare.isHidden = true
//        } else {
//            stackViews.isHidden = false
//            stackLikes.isHidden = false
////            stackComment.isHidden = false
//            stackShare.isHidden = false
//        }
        
//        if let platform = videos.platform {
//            viewContactInfo.isHidden = false
//            self.contactInfo = platform
//            imgContactInfo.sd_imageIndicator = SDWebImageActivityIndicator.gray
//            if let url = URL(string: Constants.APP_BASE_URL + platform.icon) {
//                imgContactInfo.sd_setImage(with: url, placeholderImage: UIImage(named: "whatsapp"))
//            } else {
//                imgContactInfo.image = UIImage(named: "whatsapp")
//            }
//        } else {
//            viewContactInfo.isHidden = true
//        }
        
        //let date = getDate(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", stringDate: videos.created_at)
//        if let date = date {
//            lblTime.isHidden = false
//            var timeAgo = date.timeAgoDisplay()
//            let timeAgoComp = timeAgo.components(separatedBy: " ")
//            if timeAgoComp.count == 3 {
//                if timeAgoComp[1].contains("month") {
//                    lblTime.text = timeAgoComp[0] + " " + ((timeAgoComp[1]).prefix(2)) + " " + timeAgoComp[2]
//                } else {
//                    lblTime.text = timeAgoComp[0] + ((timeAgoComp[1]).prefix(1)) + " " + timeAgoComp[2]
//                }
//            } else {
//                lblTime.text = timeAgo
//            }
//            if timeAgo.contains("second") {
//                lblTime.text = "Just now"
//            } else if timeAgo.contains("day") || timeAgo.contains("hour") || timeAgo.contains("minute") {
//                lblTime.text = timeAgo
//            } else {
//                lblTime.text = getStringFromDate(dateFormat: "dd MMM hh:mm a")
//            }
//        } else {
//            lblTime.isHidden = true//"\(Date(milliseconds: Double(chat.sentAt / 1000)))".utcToLocal(format: "dd MMM hh:mm a", utcFormat: "yyyy-MM-dd HH:mm:ss Z")
//        }
        
        //lblSocialLinks.text = videos.socialLinks
        //let imageURL = URL(string: videos.profile?.photo ?? "")
        //imgUser.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "profileThumb"))
        //self.videoID = videos.id
      //  self.thumbnail = videos.th
        self.title = videos.description
       // self.profileID = videos.profile?.id ?? ""
        //self.userProfile = videos.profile!
        self.videoURL = videos.videoUrl
        
    }
    
    func getDate(dateFormat: String, stringDate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: stringDate)
    }
    
    func getStringFromDate(dateFormat: String, date: Date = Date()) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
        
    }
    
    func setUpTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTappedDescription(_:)))
        lblDescription.isUserInteractionEnabled = true
        lblDescription.addGestureRecognizer(tap)
    }
    
    func setImage(image: UIImage) {
        
        self.imageThumb.image = image
    }
    
    func playVideo(videoPlayer: AVPlayer) {
        
        print("playVideo called")
        self.videoPlayer = videoPlayer
        playerView.player = self.videoPlayer
        videoPlayer.playImmediately(atRate: 1)
        playing = true
        replayObserver()
        print("Video should be playing")
    }
    
    func startVideo(){
        
        self.videoPlayer!.play()
//        playerView.player = self.videoPlayer
    }
    
    func stopVideo() {
        playerView.player?.pause()
    }
    
    func playPause() {
        
        if playing {
            playerView.player?.pause()
            btnPlay.setImage(UIImage(named: "play"), for: .normal)
        } else {
            playerView.player?.play()
            btnPlay.setImage(UIImage(systemName: ""), for: .normal)
        }
        playing.toggle()
    }
    
    func setupLoader() {
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
    }

    
}

//MARK: - Api Callings
extension IGBizTokVideoCell {
    
//    func likePost(videoID: String) {
//        
//        let body = ["post_id": videoID]
//        
//        RequestServices.shared.postDataWithBody(body: body, endUrl: Constants.LIKE_POST) { data, error in
//            self.btnLike.imageView?.stopAnimating()
//            
//            guard error == nil else {
//                if self.liked {
//                    self.liked = false
//                    let likes = self.totalLikes
//                    self.totalLikes = self.totalLikes - 1
//                    self.lblLike.text = "\(((likes) - 1).roundedWithAbbreviations)"
//                    self.btnLike.setImage(UIImage(named: "thumbsUp_icon"), for: .normal)
//                } else {
//                    self.liked = true
//                    let likes = self.totalLikes
//                    self.totalLikes = self.totalLikes + 1
//                    self.lblLike.text = "\(((likes) + 1).roundedWithAbbreviations)"
//                    self.btnLike.setImage(UIImage(named: "liked"), for: .normal)
//                }
//                print(error!.localizedDescription)
//                return
//            }
//            
//            if let data : Data = data as? Data {
//                
//                let decoder = JSONDecoder()
//                
//                do {
//                    
//                    let response = try decoder.decode(Message_Model.self, from: data)
//                    print(response)
//                    self.btnLike.isEnabled = true
//                } catch {
//                    //self.showErrorAlert()
//                    if self.liked {
//                        self.liked = false
//                        let likes = self.totalLikes
//                        self.totalLikes = self.totalLikes - 1
//                        self.lblLike.text = "\(((likes) - 1).roundedWithAbbreviations)"
//                        self.btnLike.setImage(UIImage(named: "thumbsUp_icon"), for: .normal)
//                    } else {
//                        self.liked = true
//                        let likes = self.totalLikes
//                        self.totalLikes = self.totalLikes + 1
//                        self.lblLike.text = "\(((likes) + 1).roundedWithAbbreviations)"
//                        self.btnLike.setImage(UIImage(named: "liked"), for: .normal)
//                    }
//                    print("Error: ", error.localizedDescription)
//                }
//            }
//        }
//    }
    
}
