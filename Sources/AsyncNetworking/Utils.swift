//
//  File.swift
//  
//
//  Created by tutuzhou on 2024/5/23.
//

import Foundation

public extension TimeInterval {
    var dateDesc: String? {
        var interval = self
        if interval > 16312039620 {
            interval = interval / 1000.0
        }
        let date = Date(timeIntervalSince1970: interval)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier:"Asia/Hong_Kong")!
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str = formatter.string(from: date)
        return str
    }
}

public extension Dictionary {
    var jsonString: String? {
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .sortedKeys),
           let str = String(data: data, encoding: .utf8) {
            return str
        }
        return nil
    }
}

public extension Array {
    var jsonString: String? {
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .sortedKeys),
           let str = String(data: data, encoding: .utf8) {
            return str
        }
        return nil
    }
}
