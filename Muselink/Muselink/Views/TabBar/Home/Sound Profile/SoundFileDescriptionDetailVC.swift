//
//  SoundFileDescriptionDetailVC.swift
//  Muselink
//
//  Created by appsdeveloper Developer on 03/02/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import UIKit

class SoundFileDescriptionDetailVC: UIViewController {
    @IBOutlet weak var View_Description    : SoftUIView!
    @IBOutlet weak var txtView_Description : SoftUIView!
    @IBOutlet weak var view_Back           : UIView!
    @IBOutlet weak var lbl_Description     : UILabel!
    @IBOutlet weak var lbl_WordLength      : UILabel!
    @IBOutlet weak var tbl_SoundFile       : UITableView!
    private        var desctext            : UITextView!
    var viewmodel : SoundProfileViewModel!
    var callback_ViewDisappear : (()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        callback_ViewDisappear?()
    }
    private func setUpViews() {
        
        View_Description.type = .normal
        View_Description.cornerRadius = 10
        View_Description.mainColor = UIColor.darkBackGround.cgColor
        View_Description.darkShadowColor = UIColor(white: 0, alpha: 0.8).cgColor
        View_Description.lightShadowColor = UIColor.darkGray.cgColor
        View_Description.isUserInteractionEnabled = true
        
        txtView_Description.type             = .normal
        txtView_Description.isSelected       = true
        txtView_Description.cornerRadius     = 10
        txtView_Description.mainColor        = UIColor.darkBackGround.cgColor
        txtView_Description.darkShadowColor  = UIColor(white: 0, alpha: 0.8).cgColor
        txtView_Description.lightShadowColor = UIColor.black.cgColor
        txtView_Description.borderWidth      = 1
        txtView_Description.borderColor      = UIColor.white.cgColor
        txtView_Description.isUserInteractionEnabled = true
        desctext = txtView_Description.setTextView(font: .AvenirLTPRo_Regular(size: 16), textColor: .white)
        desctext.isEditable = false
        desctext.text = viewmodel.selectedAudioDetail?.dataDescription
        tbl_SoundFile.reloadData()
    }
    @IBAction func action_Back() {
        dismiss(animated: true, completion: nil)
    }
}
extension SoundFileDescriptionDetailVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if (viewmodel.selectedAudioDetail?.projectRoles?.count ?? 0).isMultiple(of: 2) {
                return (viewmodel.selectedAudioDetail?.projectRoles?.count ?? 0)/2
            }
            else {
                return Int((viewmodel.selectedAudioDetail?.projectRoles?.count ?? 0)/2) + 1
            }
        }
        else {
            if (viewmodel.selectedAudioDetail?.projectGoals?.count ?? 0).isMultiple(of: 2) {
                return (viewmodel.selectedAudioDetail?.projectGoals?.count ?? 0)/2
            }
            else {
                return Int((viewmodel.selectedAudioDetail?.projectGoals?.count ?? 0)/2) + 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_ProfileAboutMe") as? Cell_ProfileAboutMe else {
            return Cell_ProfileAboutMe()
        }
        cell.selectionStyle = .none
        if indexPath.section == 0 {
            if let data = viewmodel.selectedAudioDetail?.projectRoles?[2*indexPath.row] {
                cell.btn_First.setTitle("\(data.projectRoleIcon ?? "") \(data.roleName ?? "")", for: .normal)
                if viewmodel.selectedAudioDetail?.projectRoles?.count ?? 0 > (2*indexPath.row)+1, let data = viewmodel.selectedAudioDetail?.projectRoles?[(2*indexPath.row)+1] {
                    cell.btn_Second.setTitle("\(data.projectRoleIcon ?? "") \(data.roleName ?? "")", for: .normal)
                }
            }
        }
        else {
            if let data = viewmodel.selectedAudioDetail?.projectGoals?[2*indexPath.row] {
                cell.btn_First.setTitle("\(data.goalIcon ?? "") \(data.goalName ?? "")", for: .normal)
                if viewmodel.selectedAudioDetail?.projectGoals?.count ?? 0 > (2*indexPath.row)+1, let data = viewmodel.selectedAudioDetail?.projectGoals?[(2*indexPath.row)+1] {
                    cell.btn_Second.setTitle("\(data.goalIcon ?? "") \(data.goalName ?? "")", for: .normal)
                }
            }
        }
        return cell
    }
}

extension SoundFileDescriptionDetailVC :UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        view.backgroundColor = .paleGray
        let label = UILabel(frame: CGRect(x:  UIScreen.main.bounds.width/2-70, y: 0, width: 300, height: 50))
        label.textColor = .black
        label.font      = UIFont.Avenir_Medium(size: 25)
        if section == 0 {
            label.text      = "Project Roles"
        }
        else {
            label.text      = "Milestones"
        }
        view.addSubview(label)
        
        let editView = UIButton(frame: CGRect(x: UIScreen.main.bounds.width/2+70, y: 10, width: 80, height: 30))
        editView.setImage(#imageLiteral(resourceName: "questionMark"), for: .normal)
        editView.tag = section
        editView.addTarget(self, action: #selector(action_info(_:)), for: .touchUpInside)
        view.addSubview(editView)
        return view
    }
    @objc private func action_info(_ sender:UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SoundDescInfoPopUp") as! SoundDescInfoPopUp
        vc.selectedPopUpType = sender.tag == 1 ? .MileStone : .Interest
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle   = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
}
