//
//  Constants.swift
//  HighEnergyMind
//
//  Created by Gursewak Mac on 13/02/24.
//

import Foundation
import UIKit

var isSignUpFlow = true
var isSuspended = false

struct StoryBoardNames {
    static let main                     = "Main"
    static let auth                     = "Auth"
    static let settings                 = "Setting"
    static let home                     = "Home"
    
    static let storyBoardAuth = UIStoryboard(name: auth, bundle: nil)
    static let storyBoardMain = UIStoryboard(name: main, bundle: nil)
    static let storyBoardSettings = UIStoryboard(name: settings, bundle: nil)
}

struct ViewControllers {
    static let LoginVC                      = "LoginVC"
    static let SelectCategoryVC             = "SelectCategoryVC"
    static let PersonalDetailsVC            = "PersonalDetailsVC"
    static let AffirmationsVC               = "AffirmationsVC"
    static let CategoryWarningPopUpVC       = "CategoryWarningPopUpVC"
    static let AffirmationsCategoriesVC     = "AffirmationsCategoriesVC"
    static let SubscriptionVC               = "SubscriptionVC"
    static let TabBarControllerVC           = "TabBarControllerVC"
    static let HomeVC                       = "HomeVC"
    static let OTPVC                        = "OTPVC"
    static let ForgotPasswordVC             = "ForgotPasswordVC"
    static let ResetPasswordVC              = "ResetPasswordVC"
    static let SignUpVC                     = "SignUpVC"
    static let AffirmationsPopUpVC          = "AffirmationsPopUpVC"
    static let AffirmationsDetailsVC        = "AffirmationsDetailsVC"
    static let AgeGroupVC                   = "AgeGroupVC"
    static let UnlockAllFeaturesVC          = "UnlockAllFeaturesVC"
    static let RedeemCodeVC                 = "RedeemCodeVC"
    static let SetReminderVC                = "SetReminderVC"
    static let MyProfileVC                  = "MyProfileVC"
    static let InviteFriendsVC              = "InviteFriendsVC"
    static let SecondRedeemCodeVC           = "SecondRedeemCodeVC"
    static let FAQsVC                       = "FAQsVC"
    static let ContactUSVC                  = "ContactUSVC"
    static let SuggestAffirmationVC         = "SuggestAffirmationVC"
    static let FollowUSVC                   = "FollowUSVC"
    static let NotificationsVC              = "NotificationsVC"
    static let PrivacyPolicyVC              = "PrivacyPolicyVC"
    static let ChangePasswordVC             = "ChangePasswordVC"
    static let SubscriptionPlanVC           = "SubscriptionPlanVC"
    static let Favourite_AddTracks_VC       = "Favourite_AddTracks_VC"
    static let RequestSentVC                = "RequestSentVC"
    static let AffirmationPlayVC            = "AffirmationPlayVC"
    static let AudioSettingsVC              = "AudioSettingsVC"
    static let VoiceSettingsVC              = "VoiceSettingsVC"
    static let MusicSettingsVC              = "MusicSettingsVC"
    static let MusicDetailsVC               = "MusicDetailsVC"
    static let MusicPlayVC                  = "MusicPlayVC"
    static let AffirmationsFullScreenVC     = "AffirmationsFullScreenVC"
    static let ThemeBackgroundVC            = "ThemeBackgroundVC"
    static let RedeemCodeHomeVC             = "RedeemCodeHomeVC"
    static let ExploreVC                    = "ExploreVC"
    static let FollowVC                     = "FollowVC"
    static let SearchVC                     = "SearchVC"
    static let ContentTypePopUpVC           = "ContentTypePopUpVC"
    static let CategoryFromExploreVC        = "CategoryFromExploreVC"
    static let AccountVC                    = "AccountVC"
    static let DeleteAccountVC              = "DeleteAccountVC"
    static let LogOutPopUpVC                = "LogOutPopUpVC"
    static let ManageCategoriesVC           = "ManageCategoriesVC"
    static let SelectLanguagePopUpVC        = "SelectLanguagePopUpVC"
    static let WebVC                        = "WebVC"
    static let SeeAllMusicVC                = "SeeAllMusicVC"
    static let CustomShareAffirmation       = "CustomShareAffirmation"
    static let MiddleBtnNavigationController = "MiddleBtnNavigationController"
    
}

struct CellIdentifiers {
    static let SelectCategoryCollCell       = "SelectCategoryCollCell"
    static let GenderCollCell               = "GenderCollCell"
    static let AffirmationsCollCell         = "AffirmationsCollCell"
    static let AffirmationsTblCell          = "AffirmationsTblCell"
    static let SubscriptionTblCell          = "SubscriptionTblCell"
    static let SubscriptionCollCell         = "SubscriptionCollCell"
    static let HomeAffirmationsCollCell     = "HomeAffirmationsCollCell"
    static let HomeAffirmationsTblCell      = "HomeAffirmationsTblCell"
    static let HomeAffirmationsHeader       = "HomeAffirmationsHeader"
    static let HomeAffirmationsAdvertisementCell       = "HomeAffirmationsAdvertisementCell"
    static let UnlockFeaturesTableView      = "UnlockFeaturesTableView"
    static let AffirmationsDetailsTblCel    = "AffirmationsDetailsTblCell"
    static let SpeakerCollCell              = "SpeakerCollCell"
    static let MusicSettingsColl            = "MusicSettingsColl"
    static let ThemeBgColorCollCell         = "ThemeBgColorCollCell"
    static let ThemeBgCollCell              = "ThemeBgCollCell"
    static let ExploreTblCell               = "ExploreTblCell"
    static let AffOTDCollCell               = "AffOTDCollCell"
    static let AffPlayCollCell              = "AffPlayCollCell"
    static let MusicSettingsTblHeader       = "MusicSettingsTblHeader"
    static let LoaderCollCell               = "LoaderCollCell"
    static let SeeAllMusicCollCell          = "SeeAllMusicCollCell"
}


enum Screen {
    case CategoryWarningPopUpVC
    case AffirmationsVC
    case none
}
