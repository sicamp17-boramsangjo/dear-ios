//
//  DateExtension.swift
//  dear
//
//  Created by kyungtaek on 2017. 2. 13..
//  Copyright © 2017년 sicamp. All rights reserved.
//

import Foundation

extension Date {

    func getBirthdayElements() -> (year: Int?, month: Int?, day: Int?) {
        let calendar = Calendar(identifier: .gregorian)
        let dateComponent = calendar.dateComponents([.day, .month, .year], from: self)
        return (year:dateComponent.year, month:dateComponent.month, day:dateComponent.day)
    }

    func getBirthdayString() -> String {
        let elements = self.getBirthdayElements()
        return "\(elements.year)-\(elements.month)-\(elements.day)"
    }


    func format(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    func timeAgoSinceDate(numericDates: Bool = false) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < self ? now : self
        let latest = (earliest == now) ? self : now
        let components = calendar.dateComponents(unitFlags, from: earliest, to: latest)

        if (components.year! >= 2) {
            return self.format(format: "yyyy-MM-dd")
        } else if (components.year! >= 1) {
            if (numericDates) {
                return "1년 전"
            } else {
                return "작년"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!)달 전"
        } else if (components.month! >= 1) {
            if (numericDates) {
                return "1달 전"
            } else {
                return "한달 전"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!)주 전"
        } else if (components.weekOfYear! >= 1) {
            if (numericDates) {
                return "1주 전"
            } else {
                return "지난 주"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!)일 전"
        } else if (components.day! >= 1) {
            if (numericDates) {
                return "1일 전"
            } else {
                return "어제"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!)시간 전"
        } else if (components.hour! >= 1) {
            if (numericDates) {
                return "1시간 전"
            } else {
                return "한시간 전"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!)분 전"
        } else if (components.minute! >= 1) {
            if (numericDates) {
                return "1분 전"
            } else {
                return "일분 전"
            }
        } else if (components.second! >= 3) {
            return "지금 막"
        } else {
            return "지금 막"
        }

    }
}
