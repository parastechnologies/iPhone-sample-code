//
//  MPMediaitemExtension.swift
//  Muselink
//
//  Created by iOS TL on 07/09/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import MediaPlayer

extension MPMediaItem{
    
    // Value is in Bytes
    var fileSize: Int{
        get{
            if let size = self.value(forProperty: "fileSize") as? Int{
                return size
            }
            return 0
        }
    }
    
    var fileSizeString: String{
        let formatter = Foundation.NumberFormatter()
        formatter.maximumFractionDigits = 2
        
        //Byte to MB conversion using 1024*1024 = 1,048,567
        return (formatter.string(from: NSNumber(value: Float(self.fileSize)/1048567.0)) ?? "0") + " MB"
    }
    
}
