import Foundation
import SwiftUI

// MARK: Date Static function
@available(iOS 15, macOS 12.0, *)
extension Date {
    public init?(from date: String, _ layout: DateFormatLayout, _ locale: Locale = Locale.current, _ timezone: TimeZone? = nil) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = layout
        dateFormatter.locale = locale
        dateFormatter.timeZone = timezone
        guard let result = dateFormatter.date(from: date) else { return nil }
        self = result
    }
    
    public init(_ unixDay: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(unixDay * 86_400))
    }
}

// MARK: Date Property
@available(iOS 15, macOS 12.0, *)
extension Date {
    /** Return the second for 1970-01-01 00:00:00 UTC*/
    public var unix: Int {
        self.timeIntervalSince1970.seconds
    }
    
    /** Return the day for 1970-01-01 UTC*/
    public var unixDay: Int {
        self.timeIntervalSince1970.days
    }
    
    /** Return the day of the week
     
     0 = Sunday, 1 = Monday, ... 6 = Saturday
     */
    public var dayOfWeekDay: Int {
        (self.unixDay + 5) % 7
    }
    
    public var isToday: Bool {
        self.unixDay == Date.now.unixDay
    }
    
    public var daysOfMonth: Int {
        let first = self.firstDayOfMonth
        return first.distance(to: first.addMonth(1)).days
    }
    
    public var weeksOfMonth: Int {
        guard let first = Self.init(from: "\(self.string("yyyyMM"))01", .Numeric) else { return -1 }
        let firstWeekDay = (first.timeIntervalSince1970.days + 5) % 7
        let days = first.distance(to: first.addMonth(1)).days
        return (days + firstWeekDay + 6) / 7
    }
    
    public var firstDayOfMonth: Date {
        Self.init(from: "\(self.string("yyyyMM", .us))01", .Numeric)!
    }
    
    public var lastDayOfMonth: Date {
        self.firstDayOfMonth.addMonth(1).addDay(-1)
    }
}

// MARK: Date Function
@available(iOS 15, macOS 12.0, *)
extension Date {
    public func string(_ layout: DateFormatLayout = .Default, _ locale: Locale = .current, _ timezone: TimeZone? = nil) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = layout
        dateFormatter.locale = locale
        dateFormatter.timeZone = timezone
        return dateFormatter.string(from: self)
    }
    
    public func addDay(_ day: Int) -> Date {
        return self.add(.day, day)
    }
    
    public func addMonth(_ month: Int) -> Date {
        return self.add(.month, month)
    }
    
    public func addYear(_ year: Int) -> Date {
        return self.add(.year, year)
    }
    
    public func addWeek(_ week: Int) -> Date {
        return self.add(.day, 7 * week)
    }
    
    public func add(_ unit: Calendar.Component, _ value: Int) -> Date {
        return Calendar.current.date(byAdding: unit, value: value, to: self) ?? self
    }
    
    public func add(_ span: DateSpan) -> Date? {
        switch span {
            case .none:
                return nil
            case .day:
                return self.addDay(1)
            case .week:
                return self.addWeek(1)
            case .month:
                return self.addMonth(1)
            case .year:
                return self.addYear(1)
        }
    }
    
    public func daysBetween(_ date: Date) -> Int {
        return self.distance(to: date).days
    }
}

// MARK: - DateFormatLayout
@available(iOS 15, macOS 12.0, *)
public typealias DateFormatLayout = String

@available(iOS 15, macOS 12.0, *)
public extension DateFormatLayout {
    init(_ layout: String) {
        self = layout
    }
    /**
     2006-01-02 15:04:05 +0800
     */
    static let Default: Self = "yyyy-MM-dd HH:mm:ss Z"
    /**
     Mon Jan 02 15:04:05 2006
     */
    static let ANSIC: Self = "EE MMM dd HH:mm:ss yyyy"
    /**
     Mon Jan 02 15:04:05 +0800 2006
     */
    static let UnixDate: Self = "EE MMM dd HH:mm:ss Z yyyy"
    /**
     02 Jan 06 15:04 +0800
     */
    static let RFC822: Self = "dd MMM yy HH:mm Z"
    /**
     Mon, 02 Jan 2006 15:04:05 +0800
     */
    static let RFC1123: Self = "EE, dd MMM yyyy HH:mm:ss Z"
    /**
     Jan 02 15:04:05
     */
    static let Stamp: Self = "MMM dd HH:mm:ss"
    /**
     2006-01-02
     */
    static let Date: Self = "yyyy-MM-dd"
    /**
     20060102
     */
    static let Numeric: Self = "yyyyMMdd"
}

@available(iOS 15, macOS 12.0, *)
public enum DateSpan: Int, Identifiable, Hashable, CaseIterable, Codable {
    public var id: Int { self.rawValue }
    case none=0, day=1, week=2, month=3, year=4
    
    init(_ int: Int) {
        switch int {
            case Self.day.rawValue:
                self = .day
            case Self.week.rawValue:
                self = .week
            case Self.month.rawValue:
                self = .month
            case Self.year.rawValue:
                self = .year
            default:
                self = .none
        }
    }
}

// MARK: - TimeInterval
@available(iOS 15, macOS 12.0, *)
extension TimeInterval {
    
    public var seconds: Int {
        return Int(self)
    }
    
    public var days: Int {
        return self.seconds/86_400
    }
    
    public var milliseconds: Int {
        return Int(self * 1_000)
    }
}

