//
//  DateController.swift
//  Hinami
//
//  Created by Ryusei Wada on 2021/11/28.
//

import Foundation

/**
 日付情報を管理するための構造体
 
 Date->String と String->Dateの相互変換をする
 */
struct DateController {
    func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }
    
    func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
