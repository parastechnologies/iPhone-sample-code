//
//  HomeMode.swift
//  HighEnergyMind
//
//  Created by iOS TL on 29/03/24.
//

import Foundation

// MARK: - FavModel
struct FavModel: APIModel {
    var errorMessage: String?
    var success: Bool?
    var message: String?
    var data: FavData?
    var code: Int?
}

// MARK: - FavData
struct FavData: Codable {
    var id, defID, userID: Int?
    var favType: String?
    var isFavourite: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case defID = "def_id"
        case userID = "user_id"
        case favType = "fav_type"
        case isFavourite = "is_favourite"
    }
}

// MARK: - AffirmationDetailsModel
struct AffirmationDetailsModel: Codable {
    var errorMessage: String?
    var success: Bool?
    var message: String?
    var data: [AffirmationDetailsData]?
    var trackDetails: LastTrack?
    var code: Int?
}

// MARK: - AffirmationDetailsData
struct AffirmationDetailsData: Codable {
    var id: Int?
    var affirmationID, affirmationTextGerman, affirmationTextEnglish, createdAt: String?
    var audioFiles: [AudioFile]?

    enum CodingKeys: String, CodingKey {
        case id
        case affirmationID = "affirmation_id"
        case affirmationTextGerman = "affirmation_text_german"
        case affirmationTextEnglish = "affirmation_text_english"
        case createdAt = "created_at"
        case audioFiles
    }
}

// MARK: - AudioFile
struct AudioFile: Codable {
    var id, affID: Int?
    var affEnglish, affGerman, affDurationEnglish, affDurationGerman: String?
    var speakerName: String?
    var speakerImg: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case affID = "aff_id"
        case affEnglish = "aff_english"
        case affGerman = "aff_german"
        case affDurationEnglish = "aff_duration_english"
        case affDurationGerman = "aff_duration_german"
        case speakerName = "speaker_name"
        case speakerImg = "speaker_img"
    }
}


// MARK: - LastTrack
struct LastTrack: Codable {
    
    var id: Int?
    var trackThumbnail: String?
    var categoryName: String?
    var backgroundTrackImg: String?
    var backgroundTrackMusic: String?
    var trackTitle, trackDesc: String?
    var totalTrackDuration, backgroundMusicID, backgroundImgID, isFavourite: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case trackThumbnail = "track_thumbnail"
        case categoryName = "category_name"
        case backgroundTrackImg = "background_track_img"
        case backgroundTrackMusic = "background_track_music"
        case trackTitle = "track_title"
        case trackDesc = "track_desc"
        case totalTrackDuration = "total_track_duration"
        case backgroundMusicID = "background_music_id"
        case backgroundImgID = "background_img_id"
        case isFavourite = "is_favourite"
    }
}
