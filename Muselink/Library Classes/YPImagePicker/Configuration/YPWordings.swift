//
//  YPWordings.swift
//  YPImagePicker
//
//  Created by Sacha DSO on 12/03/2018.
//  Copyright © 2018 Yummypets. All rights reserved.
//

import Foundation

public struct YPWordings {
    
    public var permissionPopup = PermissionPopup()
    public var videoDurationPopup = VideoDurationPopup()

    public struct PermissionPopup {
        public var title = ypLocalized("PermissionDeniedPopupTitle")
        public var message = ypLocalized("PermissionDeniedPopupMessage")
        public var cancel = ypLocalized("PermissionDeniedPopupCancel")
        public var grantPermission = ypLocalized("PermissionDeniedPopupGrantPermission")
    }
    
    public struct VideoDurationPopup {
        public var title = ypLocalized("VideoDurationTitle")
        public var tooShortMessage = ypLocalized("VideoTooShort")
        public var tooLongMessage = ypLocalized("VideoTooLong")
    }
    
    public var ok = ypLocalized("Ok")
    public var done = ypLocalized("Done")
    public var cancel = ypLocalized("Cancel")
    public var save = ypLocalized("Save")
    public var processing = ypLocalized("Processing")
    public var trim = ypLocalized("Trim")
    public var cover = ypLocalized("Cover")
    public var albumsTitle = ypLocalized("Albums")
    public var libraryTitle = ypLocalized("Library")
    public var cameraTitle = ypLocalized("Camera")
    public var videoTitle = ypLocalized("Video")
    public var next = ypLocalized("Next")
    public var filter = ypLocalized("Filter")
    public var crop = ypLocalized("Crop")
    public var warningMaxItemsLimit = ypLocalized("WarningItemsLimit")
}
