// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation
import Foundation
import ArgumentParser

func timeCounterTitle () -> String {
    return
        #"""
 _   _                                      _
| |_(_)_ __ ___   ___  ___ ___  _   _ _ __ | |_ ___ _ __ _
| __| | '_ ` _ \ / _ \/ __/ _ \| | | | '_ \| __/ _ \ '__(_)
| |_| | | | | | |  __/ (_| (_) | |_| | | | | ||  __/ |   _
 \__|_|_| |_| |_|\___|\___\___/ \__,_|_| |_|\__\___|_|  (_)
                                                        

                            
"""#
}

enum WeekdayFlags: Int, EnumerableFlag {
    case sun, mon, tue, wed, thu, fri, sat
    case wknd, work
}

@main
struct Timecounter: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: #"""
 

              ████████╗██╗███╗   ███╗███████╗
              ╚══██╔══╝██║████╗ ████║██╔════╝
                 ██║   ██║██╔████╔██║█████╗
                 ██║   ██║██║╚██╔╝██║██╔══╝
                 ██║   ██║██║ ╚═╝ ██║███████╗
                 ╚═╝   ╚═╝╚═╝     ╚═╝╚══════╝
  ██████╗ ██████╗ ██╗   ██╗███╗   ██╗████████╗███████╗██████╗
 ██╔════╝██╔═══██╗██║   ██║████╗  ██║╚══██╔══╝██╔════╝██╔══██╗
 ██║     ██║   ██║██║   ██║██╔██╗ ██║   ██║   █████╗  ██████╔╝
 ██║     ██║   ██║██║   ██║██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗
 ╚██████╗╚██████╔╝╚██████╔╝██║ ╚████║   ██║   ███████╗██║  ██║
  ╚═════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝

 """#,
        usage: """
                timecounter --end <"end"> [OPTIONS]
                timecounter --start <"start"> --end <"end"> [OPTIONS]
                timecounter --add <add> [OPTIONS]
                timecounter --start <"start"> --add <add> [OPTIONS]
                """,
        discussion: """
                Designed to calculate and manipulate dates, the Time Counter 
                is able to calculate periods between two dates, with or without entering a 
                especific time; count the workdays and weekdays/weekends of a period and add
                days to a start date and generate the end date.
                """
    )
//    You can enter only an end date, counting by default from
//    from the current date or by also defining the start date. In addition,
//    you can, also enter the start and end time of the period to return the
//    calculation in hours.
    @Option(help: "Start date: dd/MM/yyyy.")
    var start: Date = .now
    @Option(help: "End date: dd/MM/yyyy.")
    var end: Date = .now
    @Option(help: "Number of days to add to a start date.")
    var add: Int?
    @Flag(help: "Returns info about the periods OR especific date.")
    var weekdayFlags: [WeekdayFlags] = []

    func add(_ days: Int, to date: Date) {
        var components = DateComponents()
        components.day = days
        let futureDate = Calendar.current.date(byAdding: components, to: date)
        printFormattedAdd(futureDate!)
    }
    mutating func run() throws {
        
        let titulo = timeCounterTitle()
        print(titulo)
        
        if let days = add {
            add(days, to: start)
        } else if start.distance(to: end) < 2 {
            print("Insert an time and date by using the --end option, or --add option")
        } else {
            printFormattedPeriod(start, end)
        }

        for flag in weekdayFlags {
            switch flag {
            case .wknd:
                let output = output(start, end, check: isWeekend(_:))
                print("\nFINAIS DE SEMANA: \(output.count)")
                output.forEach { print($0) }
                
            case .work:
                print("\nDIAS ÚTEIS: \(output(start, end, check: isWorkday(_:)))")
                output(start, end, check: isWorkday(_:))
            default:
                print("\n\(flag): \(output(start, end, check: { date in checkDate(date, weekday: flag)}))"
                    .uppercased())
                output(start, end, check: { date in
                    checkDate(date, weekday: flag)
                })
            }
        }
    }
}
