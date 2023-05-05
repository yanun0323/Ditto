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
        return first.distance(to: first.AddMonth(1)).days
    }
    
    public var weeksOfMonth: Int {
        guard let first = Self.init(from: "\(self.String("yyyyMM"))01", .Numeric) else { return -1 }
        let firstWeekDay = (first.timeIntervalSince1970.days + 5) % 7
        let days = first.distance(to: first.AddMonth(1)).days
        return (days + firstWeekDay + 6) / 7
    }
    
    public var firstDayOfMonth: Date {
        Self.init(from: "\(self.String("yyyyMM", .US))01", .Numeric)!
    }
    
    public var lastDayOfMonth: Date {
        self.firstDayOfMonth.AddMonth(1).AddDay(-1)
    }
}

// MARK: Date Function
@available(iOS 15, macOS 12.0, *)
extension Date {
    public func String(_ layout: DateFormatLayout = .Default, _ locale: Locale = .current, _ timezone: TimeZone? = nil) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = layout
        dateFormatter.locale = locale
        dateFormatter.timeZone = timezone
        return dateFormatter.string(from: self)
    }
    
    public func AddDay(_ day: Int) -> Date {
        return self.Add(.day, day)
    }
    
    public func AddMonth(_ month: Int) -> Date {
        return self.Add(.month, month)
    }
    
    public func AddYear(_ year: Int) -> Date {
        return self.Add(.year, year)
    }
    
    public func AddWeek(_ week: Int) -> Date {
        return self.Add(.day, 7 * week)
    }
    
    public func Add(_ unit: Calendar.Component, _ value: Int) -> Date {
        return Calendar.current.date(byAdding: unit, value: value, to: self) ?? self
    }
    
    public func Add(_ span: DateSpan) -> Date? {
        switch span {
            case .None:
                return nil
            case .Day:
                return self.AddDay(1)
            case .Week:
                return self.AddWeek(1)
            case .Month:
                return self.AddMonth(1)
            case .Year:
                return self.AddYear(1)
        }
    }
    
    public func DaysBetween(_ date: Date) -> Int {
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
    case None=0, Day=1, Week=2, Month=3, Year=4
    
    init(_ int: Int) {
        switch int {
            case Self.Day.rawValue:
                self = .Day
            case Self.Week.rawValue:
                self = .Week
            case Self.Month.rawValue:
                self = .Month
            case Self.Year.rawValue:
                self = .Year
            default:
                self = .None
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

