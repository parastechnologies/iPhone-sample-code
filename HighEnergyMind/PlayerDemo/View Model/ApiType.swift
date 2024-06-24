//
//  ApiType.swift
//  Shipsy
//
//  Created by iOSTeam Macbook on 17/05/23.
//

import Foundation

enum ApiType{
    case logIn
    case loginFailed
    case signUp
    case emailVerify
    case resendOtp
    case PhoneVerify
    case phoneOtp
    case aboutYou
    case addReminder
    case getReminder
    case redeemCode
    
    case resetPassword
    case uploadProfile
    
    // categories
    case getCategories
    case getSubCategories
    case getChoices
    case personalDetails
    
    // settings
    case myProfile
    case editProfile
    case forgotPassword
    case logout
    case deleteAccount
    case contactUs
    case changePassowrd
    case getFaqList
    case favListing
    case favListingFailed
    case suggestAffirmation
    case deleteSubCategory
    case updateUserCategory
    case getPages
    case notifications
    case followUs
    
    // home
    case homeDashboard
    case markFav
    case getAffirmationDetails
    case exploreSection
    case search
    case getThemesImgs
    case getThemesAudios
    case seeAll
    case recentTrackList
    case scrollAff
    case changeAffDayBgImg
    case seeAllMusic
    case addSubscription
    case recentPlay
}
