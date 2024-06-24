//
//  Ext-String.swift
//  HighEnergyMind
//
//  Created by iOS TL on 22/02/24.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localizeString(string: String) -> String {
        let path = Bundle.main.path(forResource: string, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!,
                                 value: "", comment: "")
    }
}
