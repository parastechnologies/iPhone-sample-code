//
//  AffirmationsDetailsVC.swift
//  HighEnergyMind
//
//  Created by iOS TL on 01/03/24.
//

import UIKit
import IBAnimatable

class AffirmationsDetailsVC: BaseClassVC {

    @IBOutlet weak var scrollView           : UIScrollView!
    @IBOutlet weak var gradientView         : UIView!
    @IBOutlet weak var upperView            : UIView!
    @IBOutlet weak var aboutBtn             : AnimatableButton!
    @IBOutlet weak var categoryLbl          : UILabel!
    @IBOutlet weak var timeLbl              : UILabel!
    @IBOutlet weak var categoryBgView       : UIView!
    @IBOutlet weak var timeBgView           : UIView!
    @IBOutlet weak var affirmationsTbl      : UITableView!
    @IBOutlet weak var affirmationsTblHeight: NSLayoutConstraint!
    @IBOutlet weak var favBtn               : UIButton!
    @IBOutlet weak var affirmtionImg        : UIImageView!
    @IBOutlet weak var affTitleLbl          : UILabel!
    @IBOutlet weak var affDetailsLbl        : UILabel!
    
    
    
//    var selectedAffirmation             : LastTrack?
    var trackDetails                    : LastTrack?
    var affirmationDetails              : [AffirmationDetailsData]?
    var trackId                         : Int?
    var vm                              : HomeViewModel!
    var id                              : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm = HomeViewModel(type: .markFav)
        UserData.language = "german"
        
        vm.loadAffirmations()
        vm.didFinishFetch = { [weak self] apiType in
            switch apiType {
            case .markFav:
                print("get affirmation details api success")
                self?.trackDetails = self?.vm.trackDetails
                self?.affirmationDetails = self?.vm.affirmationDetails
                self?.setupUIFromApi()
            default: return
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        Operations.shared.makeGradientLayer(view: gradientView, layers: [categoryBgView.layer, timeBgView.layer], locations: [0.0, 0.7])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        updateFavImg(isFav: selectedAffirmation?.isFavourite ?? 0)
    }
    
    func updateFavImg(isFav: Int) {
        favBtn.setImage(UIImage(named: isFav == 1 ? "heart_filled_with_bg_red" : "heart_filled_with_bg"), for: .normal)
    }
    
    func setupUIFromApi() {
        affirmtionImg.showImage(imgURL: trackDetails?.trackThumbnail ?? "")
        affTitleLbl.text = trackDetails?.trackTitle ?? ""
        affDetailsLbl.text = trackDetails?.trackDesc ?? ""
        timeLbl.text = "\(secondsToMinutes(seconds: trackDetails?.totalTrackDuration ?? 0)) mins"
        categoryLbl.text = trackDetails?.categoryName ?? ""
        if affirmationDetails?.count ?? 0 > 0 {
            affirmationsTbl.reloadData()
        }
    }
    
    func secondsToMinutes(seconds: Int) -> Int {
        return (seconds / 60)
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func shareTap(_ sender: UIButton) {
        let message = "Check this track"
        if let link = NSURL(string: "https://php.parastechnologies.in/highMindEnergy/api/v1/api/inviteLink/\(trackDetails?.id ?? 0)")
        {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            //                activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    @IBAction func playTap(_ sender: UIButton) {
        let vc = pushVC(ViewControllers.AffirmationPlayVC, storyboard: StoryBoardNames.storyBoardMain) as! AffirmationPlayVC
        vc.selectedAffirmation = trackDetails
        vc.selectedAffirmationDetails = affirmationDetails ?? []
        vc.didTapBackBtn = { selectedAffirmation in
            self.trackDetails = selectedAffirmation
//            self.updateFavImg(isFav: self.selectedAffirmation?.isFavourite ?? 0)
        }
        
//        DispatchQueue.global(qos: .background).async {
//            self.hitRecentPlayApi(trackId: self.selectedAffirmation?.id ?? 0)
//        }
    }
    @IBAction func favTap(_ sender: UIButton) {
        let isFav = trackDetails?.isFavourite
        trackDetails?.isFavourite = isFav == 0 ? 1 : 0
        vm.markFavApi(Id: self.trackDetails?.id ?? -1, favourite: self.trackDetails?.isFavourite ?? 0, type: "track")
        vm.didFinishFetch = { apiType in
            switch apiType {
            case .markFav:
                print("mark fav api success")
                sender.setImage(UIImage(named: (self.trackDetails?.isFavourite == 1) ? "heart_filled_with_bg_red" : "heart_filled_with_bg"), for: .normal)
            default: return
            }
        }
    }
}


extension AffirmationsDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if vm.affirmationDetails?.count ?? 0 > 0 {
            return vm.affirmationDetails?.count ?? 0
        } else {
            return 0
        }
//        return affirmations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.AffirmationsDetailsTblCel, for: indexPath) as! UnlockFeaturesTableView
        if vm.affirmationDetails?.count ?? 0 > 0 {
            cell.lbl.text = UserData.language.lowercased() == "english" ? vm.affirmationDetails?[indexPath.row].affirmationTextEnglish : vm.affirmationDetails?[indexPath.row].affirmationTextGerman
        }
//        cell.lbl.text = affirmations[indexPath.row]
        Operations.shared.updateTblHeight(tableView: tableView, tblHeight: affirmationsTblHeight, view: [self.view])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK :- TableView Class of UnlockAllFeaturesVC
class UnlockFeaturesTableView : UITableViewCell {
    @IBOutlet weak var lbl : UILabel!
    @IBOutlet weak var leftImg: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
}


