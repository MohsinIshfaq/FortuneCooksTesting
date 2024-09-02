//
//  MenuVC.swift
//  Resturants
//
//  Created by Coder Crew on 08/08/2024.
//

import UIKit
import FirebaseFirestoreInternal

class MenuesVC: UIViewController {

    //MARK: - IBOUtlets
      @IBOutlet weak var tblLocation: UITableView!
      
    
    let db                                = Firestore.firestore()
    var locations: [RestaurantLocation]   = []
    var profileModel: UserProfileModel?   = nil
      
      override func viewDidLoad() {
          super.viewDidLoad()
          onLoad()
      }
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          onAppear()
      }
      
      @IBAction func ontapAddNewLocation(_ sender: UIButton){
          let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "ManageInfoVC") as! ManageInfoVC
          vc.isFromNewLocation        = true
          vc.hidesBottomBarWhenPushed = true
          self.navigationController?.pushViewController(vc, animated: true)
      }

  }

  //MARK: - Custom Implementation {}
  extension MenuesVC {
      
      func onLoad() {
          setupView()
          removeNavBackbuttonTitle()
      }
      
      func onAppear() {
          getLocations()
          self.navigationItem.title = "Add or manage"
      }
      
      func setupView() {
          tblLocation.register(LocationTCell.nib, forCellReuseIdentifier: LocationTCell.identifier)
          tblLocation.delegate   = self
          tblLocation.dataSource = self
      }
  }

  //MARK: - TableView {}
  extension MenuesVC : UITableViewDelegate , UITableViewDataSource {
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

          return self.locations.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: LocationTCell.identifier, for: indexPath) as? LocationTCell
          print(locations[indexPath.row].channalNm)
          var captalLetter     = locations[indexPath.row].channalNm.capitalizingFirstLetter()
          cell?.lblName.text   = captalLetter
          print(locations[indexPath.row].channalNm.capitalizingFirstLetter())
          cell?.lblLoc.text    = locations[indexPath.row].address
          if locations[indexPath.row].timings?.count != 0 {
              var range = locations[indexPath.row].timings?[getCurrentDayOfWeek().1]
              cell?.lblStatus.text    = "\(isRestaurantOpen(timeRange:range ?? "") ? "Open" : "Closed")"
              cell?.lblSchedule.text  = locations[indexPath.row].timings?[getCurrentDayOfWeek().1]
              cell?.lblStatus.textColor = cell?.lblStatus.text == "Open" ? .green : .red
              if cell?.lblStatus.text == "Open" {
                  cell?.lblStatus.text = "\(isOneHourOrLessLeft(timeRange:range ?? "") ? "Closing Soon" : "Open")"
                  cell?.lblStatus.textColor = cell?.lblStatus.text == "Closing Soon" ? .yellow : .green
              }
          }
          if locations[indexPath.row].locType == "main" {
              cell?.btnManangeInfo.isHidden = true
          }
          else{
              cell?.btnManangeInfo.isHidden = false
          }
          cell?.btnManangeInfo.addTarget(self, action: #selector(ontapMangeInfo(sender:)), for: .touchUpInside)
          cell?.btnManangeInfo.tag = indexPath.row
          cell?.btnManageMenu.addTarget(self, action: #selector(ontapMangeMenu(sender:)), for: .touchUpInside)
          cell?.btnManageMenu.tag  = indexPath.row
          return cell!
      }
      
      @objc func ontapMangeInfo(sender: UIButton) {
          let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "ManageInfoVC") as! ManageInfoVC
          vc.isFromNewLocation        = false
          vc.location                 = locations[sender.tag]
          vc.hidesBottomBarWhenPushed = true
          self.navigationController?.pushViewController(vc, animated: true)
      }
      
      @objc func ontapMangeMenu(sender: UIButton) {
          let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "ManageMenuVC") as! ManageMenuVC
          vc.location                 = locations[sender.tag]
          vc.hidesBottomBarWhenPushed = true
          self.navigationController?.pushViewController(vc, animated: true)
      }
      
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 150
      }
  }

extension MenuesVC {
    
    func getLocations() {
        self.locations.removeAll()
        self.startAnimating()
        let collectionPath = "restaurants_Locations/\(UserDefault.token)/locations"
        db.collection(collectionPath).getDocuments { (querySnapshot, error) in
            self.stopAnimating() // Ensure animation stops whether there's an error or not

            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                return
            }

            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("No documents found.")
                if self.locations.count == 0 {
                    self.addLocationOfResturant()
                }
                else{
                    
                }
                return
            }

            for document in documents {
                let data = document.data()
                let id               = data["id"] as? String ?? ""
                let channalNm        = data["channalNm"] as? String ?? ""
                let bio              = data["bio"] as? String ?? ""
                let email            = data["email"] as? String ?? ""
                let website          = data["website"] as? String ?? ""
                let telephoneNumber  = data["telephoneNumber"] as? String ?? ""
                let address          = data["address"] as? String ?? ""
                let zipCode          = data["zipCode"] as? String ?? ""
                let city             = data["City"] as? String ?? ""
                let timings          = data["timings"] as? [String] ?? []
                let locType          = data["locType"] as? String ?? ""
                self.locations.append(RestaurantLocation(id: id, channalNm: channalNm, bio: bio, email: email, website: website, telephoneNumber: telephoneNumber, address: address, zipCode: zipCode, City: city, timings: timings, locType: locType))
            }
            print(self.locations)
            self.locations = self.locations.sorted { $0.channalNm.lowercased() < $1.channalNm.lowercased() }
            self.tblLocation.reloadData()
            self.UpdateLocation()
        }
    }
}

//get menus
extension MenuesVC  {
    
    func addLocationOfResturant() {
        self.startAnimating()
        let uniqueID = UUID().uuidString
        let db = Firestore.firestore()
        // Create the restaurant location object
        let restaurantLocation = RestaurantLocation(
            id: uniqueID,
            channalNm: profileModel?.channelName ?? "",
            bio: profileModel?.bio ?? "",
            email: profileModel?.businessEmail ?? "",
            website: profileModel?.website ?? "",
            telephoneNumber: profileModel?.businessphoneNumber ?? "",
            address: profileModel?.address ?? "",
            zipCode: profileModel?.zipcode ?? "",
            City: profileModel?.city ?? "",
            timings: profileModel?.timings,
            locType: "main"
        )
        
        let collectionPath = "restaurants_Locations/\(UserDefault.token)/locations"
        db.collection(collectionPath).addDocument(data: restaurantLocation.toDictionary()) { error in
            if let error = error {
                print("Error saving location: \(error.localizedDescription)")
            } else {
                self.stopAnimating()
                self.locations.append(restaurantLocation)
                self.tblLocation.reloadData()
                self.menuGroups(id: uniqueID)
            }
        }
    }
    
    func menuGroups(id: String) {
        let uniqueID = UUID().uuidString
        let groupName = "Popular"
        
        let db = Firestore.firestore()
        self.startAnimating()
        
        let group: [String: Any] = [
            "uniqueID": uniqueID,
            "groupName": groupName
        ]
        
        // Creating an array of groups, even if it's just one for now
        let data: [String: Any] = [
            "groups": [group] // Storing the group in an array
        ]
        
        db.collection("groupsNames").document(id).setData(data) { error in
            self.stopAnimating()
            if let error = error {
                print("Error saving document: \(error.localizedDescription)")
            } else {
            }
        }
    }

    
    func UpdateLocation() {
        self.startAnimating()
        
        // Prepare the timings array
        
        let db = Firestore.firestore()
        let mainLocationId = locations.first { $0.locType == "main" }?.id ?? ""
        // Create the restaurant location object
        let restaurantLocation = RestaurantLocation(
            id: mainLocationId,
            channalNm: profileModel?.channelName ?? "",
            bio: profileModel?.bio ?? "",
            email: profileModel?.businessEmail ?? "",
            website: profileModel?.website ?? "",
            telephoneNumber: profileModel?.businessphoneNumber ?? "",
            address: profileModel?.address ?? "",
            zipCode: profileModel?.zipcode ?? "",
            City: profileModel?.city ?? "",
            timings: profileModel?.timings,
            locType: "main"
        )
        
        // Firestore collection path
        let collectionPath = "restaurants_Locations/\(UserDefault.token)/locations"
        
        // Query for the document with the matching channel name
        db.collection(collectionPath)
            .whereField("locType", isEqualTo: "main")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error finding document: \(error.localizedDescription)")
                    self.stopAnimating()
                } else if let document = querySnapshot?.documents.first {
                    // Document exists, update it
                    db.collection(collectionPath).document(document.documentID).updateData(restaurantLocation.toDictionary()) { error in
                        if let error = error {
                            print("Error updating document: \(error.localizedDescription)")
                        } else {
                            self.stopAnimating()
                            for i in 0 ..< self.locations.count {
                                if self.locations[i].locType == "main" {
                                    self.locations.remove(at: i)
                                    self.locations.insert(restaurantLocation, at: 0)
                                    self.tblLocation.reloadData()
                                }
                            }
                        }
                    }
                }
            }
    }
    
}
