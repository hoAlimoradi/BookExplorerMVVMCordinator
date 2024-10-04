//
//  LoggingAPI.swift
 
import Foundation

/// Enum representing different log levels with associated emojis.
public enum LogLevel: String {
    case error = "❌"
    case warning = "⚠️"
    case info = "ℹ️"
}

/// Enum representing the mode of the logger.
public enum Mode {
    case debug
    case release
}
/// A singleton class that provides logging functionality with different log levels.
public final class LoggingAPI {
    /// The shared instance of the `LoggingAPI` class.
    public static let shared = LoggingAPI()

    /// Private initializer to enforce singleton pattern.
    private init() {}
  
    /// The current mode of the logger.
    ///
    /// The mode is determined based on the build configuration. It is set to `.debug` if the build
    /// configuration is debug, otherwise it is set to `.release`.
    public var mode: Mode = {
        #if DEBUG
        return .debug
        #else
        return .release
        #endif
    }()

    /// Logs a message with the specified log level.
    ///
    /// This method will log the message only if the current mode is `.debug`. The log message will include
    /// an emoji representing the log level, the current time formatted as "yyyy-MM-dd HH:mm:ss", and the input message.
    ///
    /// - Parameters:
    ///   - message: The message to log.
    ///   - level: The log level of the message.
    @inlinable
    public func log(_ message: String, level: LogLevel) {
        guard mode == .debug else { return }

        let currentTime = getCurrentFormattedTime()
        let logMessage = "\(level.rawValue) \(currentTime) 🕒 \(message)"
        print(logMessage)
    }

    /// Returns the current local time formatted as "yyyy-MM-dd HH:mm:ss".
    ///
    /// This method is used to get the current time for logging purposes.
    ///
    /// - Returns: A string representing the current local time.
    @inlinable
    func getCurrentFormattedTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
}
