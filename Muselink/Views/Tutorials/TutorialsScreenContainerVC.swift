//
//  TutorialsScreenContainerVC.swift
//  Muselink
//
//  Created by appsDev on 27/11/20.
//  Copyright © 2020 Paras Technologies. All rights reserved.
//

import UIKit
import IBAnimatable

class TutorialsScreenContainerVC: UIViewController {
    private enum ScreenType {
        case TutsOne
        case TutsTwo
        case TutsThree
    }
    @IBOutlet weak var container : UIView!
    @IBOutlet weak var btn_Next : SoftUIView!
    @IBOutlet weak var dot_One        : SoftUIView! {
        didSet {
            dot_One.type = .normal
            dot_One.mainColor = UIColor.paleGray.cgColor
        }
    }
    @IBOutlet weak var dot_Two        : SoftUIView! {
        didSet {
            dot_Two.type = .normal
            dot_Two.mainColor = UIColor.paleGray.cgColor
        }
    }
    @IBOutlet weak var dot_Three      : SoftUIView! {
        didSet {
            dot_Three.type = .normal
            dot_Three.mainColor = UIColor.paleGray.cgColor
        }
    }
    @IBOutlet weak var selected_dot   : SoftUIView! {
        didSet {
            selected_dot.borderWidth = 1
            selected_dot.borderColor = UIColor.appRed.cgColor
            selected_dot.addInnerView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), cornerRadius: 5, backgroundColor: UIColor.appRed)
        }
    }
    
    @IBOutlet weak var view_TopLabel  : AnimatableView!
    @IBOutlet weak var lbl_Top_First  : AnimatableLabel!
    @IBOutlet weak var dot_Top_First  : AnimatableView!
    @IBOutlet weak var lbl_Top_Second : AnimatableLabel!
    @IBOutlet weak var dot_Top_Second : AnimatableView!
    @IBOutlet weak var lbl_Top_Third  : AnimatableLabel!
    @IBOutlet weak var view_Quotes    : AnimatableView!
    
    @IBOutlet weak var view_Quotes2   : AnimatableView!
    @IBOutlet weak var view_Quotes3   : AnimatableView!
    
    @IBOutlet weak var img_TopWave    : AnimatableImageView!
    @IBOutlet weak var img_BottomWave : AnimatableImageView!
    
    var tuts1AnimationEnd : (()->())?
    private lazy var tutsScreenOneVC : TutorialsScreenOneVC? = {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TutorialsScreenOneVC") as! TutorialsScreenOneVC
        vc.parentVC = self
        return vc
    }()
    private lazy var tutsScreenTwoVC: TutorialsScreenTwoVC? = {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TutorialsScreenTwoVC") as! TutorialsScreenTwoVC
        vc.parentVC = self
        return vc
    }()
    private lazy var tutsScreenThreeVC: TutorialsScreenThreeVC? = {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TutorialsScreenThreeVC") as! TutorialsScreenThreeVC
        vc.parentVC = self
        return vc
    }()
    private var currentViewController: UIViewController?
    private var selectedScreenType = ScreenType.TutsOne
    var isFromSetting = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if let vc = viewControllerForSelectedSegmentIndex(0) {
            self.addChild(vc)
            vc.didMove(toParent: self)
            vc.view.frame = self.container.bounds
            self.container.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.view_Quotes.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {[weak self] in
            guard let self = self else {return}
            self.lbl_Top_First.isHidden = false
            self.lbl_Top_First.animate(.pop(repeatCount: 1),duration: 1.5)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {[weak self] in
            guard let self = self else {return}
            self.dot_Top_First.isHidden = false
            self.dot_Top_First.animate(.pop(repeatCount: 1),duration: 1.5)
            self.lbl_Top_Second.isHidden = false
            self.lbl_Top_Second.animate(.pop(repeatCount: 1),duration: 1.5)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {[weak self] in
            guard let self = self else {return}
            self.dot_Top_Second.isHidden = false
            self.dot_Top_Second.animate(.pop(repeatCount: 1),duration: 1.5)
            self.lbl_Top_Third.isHidden = false
            self.lbl_Top_Third.animate(.pop(repeatCount: 1),duration: 1.5)
        }
        setUpViews()
    }
    private func setUpViews() {
        btn_Next.type = .pushButton
        btn_Next.addTarget(self, action: #selector(action_Next), for: .touchDown)
        btn_Next.cornerRadius = 10
        btn_Next.mainColor = UIColor.paleGray.cgColor
        btn_Next.darkShadowColor = UIColor(white: 0, alpha: 0.25).cgColor
        btn_Next.borderWidth = 2
        btn_Next.borderColor = UIColor.white.cgColor
        btn_Next.setButtonTitle(font: UIFont.AvenirLTPRo_Demi(size: 25.upperDynamic()), title: "Next")
    }
    private func displayCurrentTab(_ tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            self.addChild(vc)
            vc.didMove(toParent: self)
            vc.view.frame = self.container.bounds
            self.container.addSubview(vc.view)
            vc.view.transform = .init(translationX: view.frame.width, y: 0)
            UIView.animate(withDuration: 1, animations: {
                vc.view.transform = .identity
                self.currentViewController?.view.transform = .init(translationX: -self.view.frame.width, y: 0)
            }) { (res) in
                self.currentViewController?.removeFromParent()
                self.currentViewController = vc
            }
        }
    }
    private func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
            case 0 :
                vc = tutsScreenOneVC
            case 1 :
                vc = tutsScreenTwoVC
            case 2 :
                vc = tutsScreenThreeVC
            default:
                return nil
        }
        return vc
    }
    @objc private func action_Next() {
        switch selectedScreenType {
            case .TutsOne:
                view_Quotes2.transform = .init(translationX: self.view.frame.width, y: 0)
                view_Quotes2.isHidden  = false
                UIView.animate(withDuration: 1, animations: {
                    self.view_Quotes.transform = .init(translationX: -self.view.frame.width, y: 0)
                    self.img_TopWave.transform = .init(translationX: -self.view.frame.width, y: 0)
                    self.img_BottomWave.transform = .init(translationX: -self.view.frame.width, y: 0)
                    self.view_TopLabel.transform  = .init(translationX: -self.view.frame.width, y: 0)
                    self.view_Quotes2.transform   = .identity
                }) { (res) in
                    self.view_Quotes.isHidden = true
                    self.view_TopLabel.isHidden = true
                }
                self.displayCurrentTab(1)
                self.tuts1AnimationEnd?()
                setDot(index: 1)
                selectedScreenType = .TutsTwo
            case .TutsTwo:
                view_Quotes3.transform = .init(translationX: self.view.frame.width, y: 0)
                view_Quotes3.isHidden  = false
                UIView.animate(withDuration: 1, animations: {
                    self.img_TopWave.transform = .init(translationX: -self.view.frame.width*2, y: 0)
                    self.img_BottomWave.transform = .init(translationX: -self.view.frame.width*2, y: 0)
                    self.view_Quotes2.transform = .init(translationX: -self.view.frame.width, y: 0)
                    self.view_Quotes3.transform   = .identity
                }) { (res) in
                    self.view_Quotes2.isHidden = true
                }
                selectedScreenType = .TutsThree
                self.displayCurrentTab(2)
                setDot(index: 2)
            case .TutsThree:
                AppSettings.hasShowTutorials = true
                if isFromSetting {
                    dismiss(animated: true, completion: nil)
                }
                else {
                    performSegue(withIdentifier: "GoToMain", sender: self)
                }
                break
        }
    }
    private func setDot(index:Int) {
        switch index {
            case 0:
                UIView.animate(withDuration: 1) {[weak self] in
                    guard let self = self else {return}
                    self.selected_dot.transform = .init(translationX: 0, y: 0)
                }
                break
            case 1:
                UIView.animate(withDuration: 1) {[weak self] in
                    guard let self = self else {return}
                    self.selected_dot.transform = .init(translationX: self.dot_One.frame.width+10, y: 0)
                }
                break
            case 2:
                UIView.animate(withDuration: 1) {[weak self] in
                    guard let self = self else {return}
                    self.selected_dot.transform = .init(translationX: (self.dot_One.frame.width+10)*2, y: 0)
                }
                break
            default:
                print("Index not found")
        }
    }
}
