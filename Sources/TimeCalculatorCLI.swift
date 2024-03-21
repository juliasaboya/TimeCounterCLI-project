// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation
import Foundation
import ArgumentParser

func timeCountTitle () -> String {
    return
        #"""
 _____  _  _      _____   ____  ____  _     _      _____
/__ __\/ \/ \__/|/  __/  /   _\/  _ \/ \ /\/ \  /|/__ __\
  / \  | || |\/|||  \    |  /  | / \|| | ||| |\ ||  / \
  | |  | || |  |||  /_   |  \__| \_/|| \_/|| | \||  | |
  \_/  \_/\_/  \|\____\  \____/\____/\____/\_/  \|  \_/
                                                         

"""#
}

enum WeekdayFlags: Int, EnumerableFlag {
    case sun, mon, tue, wed, thu, fri, sat
    case weekend, work
}

@main
struct Timecount: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: """
        
                         _____ _ __ __ ___
                        |_   _| |  V  | __|
                          | | | | |_| | _|
                          |_| |_|_| |_|___|
        
         ::::::::   ::::::::  :::    ::: ::::    ::: :::::::::::
        :+:    :+: :+:    :+: :+:    :+: :+:+:   :+:     :+:
        +:+        +:+    +:+ +:+    +:+ :+:+:+  +:+     +:+
        +#+        +#+    +:+ +#+    +:+ +#+ +:+ +#+     +#+
        +#+        +#+    +#+ +#+    +#+ +#+  +#+#+#     +#+
        #+#    #+# #+#    #+# #+#    #+# #+#   #+#+#     #+#
         ########   ########   ########  ###    ####     ###
        """,
        usage: """
                timecount --end <"end"> [OPTIONS]
                timecount --start <"start"> --end <"end"> [OPTIONS]
                timecount --add <add> [OPTIONS]
                timecount --start <"start"> --add <add> [OPTIONS]
                """,
        discussion: """
                This tool is designed to calculate the period between two dates.
                You can enter only an end date, counting by default from
                from the current date or by also defining the start date. In addition,
                you can, also enter the start and end time of the period to return the
                calculation in hours.
                """
    )
    @Option(help: "Start date: dd/MM/yyyy.")
    var start: Date?
    @Option(help: "End date: dd/MM/yyyy.")
    var end: Date?
    @Option(help: "Number of days to add to the start date")
    var add: Int?
    @Flag(help: "Filter by day")
    var weekdayFlags: [WeekdayFlags] = []

    func add(_ days: Int, to date: Date) {
        var components = DateComponents()
        components.day = days
        let futureDate = Calendar.current.date(byAdding: components, to: date)
        printFormattedAdd(futureDate!)
    }

    mutating func run() throws {
        //
        //
        // OPTIONS
        //
        //
        let titulo = timeCountTitle()
        print(titulo)
        if let end {
            printFormattedPeriod(start ?? .now, end)
        } else if let days = add {
            add(days, to: start ?? .now)
        } else {
            print("Insert an end date by using the --end option, or --add option")
        }

        if let start, let end {
            for flag in weekdayFlags {
                switch flag {
                case .weekend:
                    print("WEEKEND")
                    output(start, end, check: isWeekend(_:))
                case .work:
                    print("WORK DAYS")
                    output(start, end, check: isWorkday(_:))
                default:
                    print("\(flag)".uppercased())
                    output(start, end, check: { date in
                        checkDate(date, weekday: flag)
                    })
                }
            }
        }
    }
}
