//
//  DataExtension.swift
//  WorkUp
//
//  Created by appsdeveloper Developer on 20/10/22.
//

import Foundation

extension Data {
    mutating func append(string: String) {
        let data = string.data(
            using: String.Encoding.utf8,
            allowLossyConversion: true)
        append(data!)
    }
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
    mutating func append(_ intValue: Int) {
        var value = intValue
        let data = Data(bytes: &value,count: MemoryLayout.size(ofValue: value))
        append(data)
    }
    func sizeString(units: ByteCountFormatter.Units = [.useAll], countStyle: ByteCountFormatter.CountStyle = .file) -> String {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = units
        bcf.countStyle = .file
        return bcf.string(fromByteCount: Int64(count))
     }
    
    var hexString: String {
            let hexString = map { String(format: "%02.2hhx", $0) }.joined()
            return hexString
        }

}
public extension RandomAccessCollection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    /// - complexity: O(1)
    subscript (safe index: Index) -> Element? {
        guard index >= startIndex, index < endIndex else {
            return nil
        }
        return self[index]
    }
    
}
