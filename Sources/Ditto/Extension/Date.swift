import Foundation
import SwiftUI

// MARK: - SpanComponent
public enum SpanComponent {
    case year, month, day, hour, minute, second

    public var calendarComponent: Calendar.Component {
        switch self {
        case .year: return .year
        case .month: return .month
        case .day: return .day
        case .hour: return .hour
        case .minute: return .minute
        case .second: return .second
        }
    }
}

// MARK: - Date
extension Date {
    public init(_ year: Int, _ month: Int, _ day: Int, _ hour: Int, _ minute: Int, _ second: Int, locale: Locale? = nil) {
        var comp = DateComponents()
        comp.setValue(year, for: .year)
        comp.setValue(month, for: .month)
        comp.setValue(day, for: .day)
        comp.setValue(hour, for: .hour)
        comp.setValue(minute, for: .minute)
        comp.setValue(second, for: .second)
        comp.timeZone = locale?.timeZone
        self = Calendar.current.date(from: comp) ?? .zero
    }

    public init?(from date: String, _ layout: DateFormatLayout, _ timeZone: TimeZone? = nil) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = layout
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = timeZone
        guard let result = dateFormatter.date(from: date) else { return nil }
        self = result
    }
}

// MARK: Date Static
extension Date { 
    public static let zero = Date(timeIntervalSince1970: 0)
}

extension Date {
    public func replace(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil, locale: Locale? = nil) -> Date {
        return Date(year ?? self.year, month ?? self.month, day ?? self.day, hour ?? self.hour, minute ?? self.minute, second ?? self.second, locale: locale)
    }
    
    public func add(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil, locale: Locale? = nil) -> Date {
        return self.add(.year, year ?? 0)
            .add(.month, month ?? 0)
            .add(.day, day ?? 0)
            .add(.hour, hour ?? 0)
            .add(.minute, minute ?? 0)
            .add(.second, second ?? 0)
    }
}

extension Date {
    public var year: Int { Calendar.current.component(.year, from: self) }
    public var month: Int { Calendar.current.component(.month, from: self) }
    public var day: Int { Calendar.current.component(.day, from: self) }
    public var hour: Int { Calendar.current.component(.hour, from: self) }
    public var minute: Int { Calendar.current.component(.minute, from: self) }
    public var second: Int { Calendar.current.component(.second, from: self) }
    public var monthFirst: Date { Date(self.year, self.month, 1, 0, 0, 0) }
    public var monthLast: Date { monthFirst.addMonth(1).addDay(-1) }

    /** Return the second for 1970-01-01 00:00:00 UTC */
    public var unix: Int { self.timeIntervalSince1970.seconds }
    /** Return the day for 1970-01-01 UTC */
    public var unixDay: Int { self.timeIntervalSince1970.days }

    /** Return the day of the week
     0 = Sunday, 1 = Monday, ... 6 = Saturday
     */
    public var weekDay: Int { (self.unixDay + 5) % 7 }

    public var isToday: Bool { self.year == Date.now.year && self.month == Date.now.month && self.day == Date.now.day }

    /** Return the week's count of the month  */
    public var monthWeeks: Int {
        let first = self.monthFirst
        let firstWeekDay = (first.timeIntervalSince1970.days + 5) % 7
        let days = first.between(.day, first.addMonth(1))
        return (days + firstWeekDay + 6) / 7
    }

    /** Return the day's count of the month  */
    public var monthDays: Int {
        let first = Date(self.year, self.month, 1, 0, 0, 0)
        let next = Calendar.current.date(byAdding: .month, value: 1, to: first) ?? first
        let set = Set<Calendar.Component>([.day])
        return Calendar.current.dateComponents(set, from: first, to: next).day ?? 1
    }
}

// MARK: Date Function
extension Date {
    public func string(_ layout: DateFormatLayout = .Default, _ locale: Locale = .autoupdatingCurrent) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = layout
        dateFormatter.locale = locale
        dateFormatter.timeZone = locale.timeZone
        return dateFormatter.string(from: self)
    }

    public func addDay(_ day: Int) -> Date { return self.add(.day, day) }
    public func addMonth(_ month: Int) -> Date { return self.add(.month, month) }
    public func addYear(_ year: Int) -> Date { return self.add(.year, year) }
    public func addWeek(_ week: Int) -> Date { return self.add(.day, 7 * week) }
    public func add(_ unit: Calendar.Component, _ value: Int) -> Date { return Calendar.current.date(byAdding: unit, value: value, to: self) ?? self }
    public func add(_ span: DateSpan) -> Date? {
        switch span {
        case .none: return nil
        case .day: return self.addDay(1)
        case .week: return self.addWeek(1)
        case .month: return self.addMonth(1)
        case .year: return self.addYear(1)
        }
    }

    public func between(_ unit: SpanComponent, _ to: Date) -> Int {
        let sets = Set<Calendar.Component>([unit.calendarComponent])
        let comp = Calendar.current.dateComponents(sets, from: self, to: to)
        switch unit {
        case .year: return comp.year ?? 0
        case .month: return comp.month ?? 0
        case .day: return comp.day ?? 0
        case .hour: return comp.hour ?? 0
        case .minute: return comp.minute ?? 0
        case .second: return comp.second ?? 0
        }
    }
}

// MARK: - DateFormatLayout
public typealias DateFormatLayout = String

extension DateFormatLayout {
    public init(_ layout: String) { self = layout }
    /**
     2006-01-02 15:04:05 +0800
     */
    public static let Default: Self = "yyyy-MM-dd HH:mm:ss Z"
    /**
     Mon Jan 02 15:04:05 2006
     */
    public static let ANSIC: Self = "EE MMM dd HH:mm:ss yyyy"
    /**
     Mon Jan 02 15:04:05 +0800 2006
     */
    public static let UnixDate: Self = "EE MMM dd HH:mm:ss Z yyyy"
    /**
     02 Jan 06 15:04 +0800
     */
    public static let RFC822: Self = "dd MMM yy HH:mm Z"
    /**
     Mon, 02 Jan 2006 15:04:05 +0800
     */
    public static let RFC1123: Self = "EE, dd MMM yyyy HH:mm:ss Z"
    /**
     Jan 02 15:04:05
     */
    public static let Stamp: Self = "MMM dd HH:mm:ss"
    /**
     2006-01-02
     */
    public static let Date: Self = "yyyy-MM-dd"
    /**
     20060102
     */
    public static let Numeric: Self = "yyyyMMdd"
}

// MARK: - DateSpan
public enum DateSpan: Int, Identifiable, Hashable, CaseIterable, Codable {
    public var id: Int { self.rawValue }
    case none = 0
    case day = 1
    case week = 2
    case month = 3
    case year = 4

    init(_ int: Int) {
        switch int {
        case Self.day.rawValue: self = .day
        case Self.week.rawValue: self = .week
        case Self.month.rawValue: self = .month
        case Self.year.rawValue: self = .year
        default: self = .none
        }
    }
}

// MARK: - TimeInterval
extension TimeInterval {
    public var seconds: Int { return Int(self) }
    public var days: Int { return self.seconds / 86_400 }
    public var milliseconds: Int { return Int(self * 1_000) }
}
