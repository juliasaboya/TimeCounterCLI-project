//
//  drdtrrdydyr.swift
//
//
//  Created by User on 20/03/24.
//

import Foundation

func iterableDates(from fromDate: Date, to toDate: Date) -> [Date] {
    var dates: [Date] = []
    var date = fromDate
    
    while date <= toDate {
        dates.append(date)
        guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
        date = newDate
    }
    return dates
}

// TODO: Estudar primeiro testes unitários
// depois... boas praticas de Programação: Codigo Limpo, Arquitetura Limpa, Principios SOLID
/*
 let start = "13/04/2024"
 let end = "27/04/2024"
 
 let workdays = output(start, end, check: workday)
 
 assertEqual(workdays, 10)
 */

func output(_ start: Date, _ end: Date, check: (Date) -> Bool) {
    let dates = iterableDates(from: start, to: end)
    var res: [Date] = []
    for date in dates {
        if check(date) {
            res.append(date)
        }
    }
    print("Quantidade de datas: \(res.count)")
}

func checkDate(_ date: Date, weekday: WeekdayFlags) -> Bool {
    let defaultCalendar = Calendar.current
    let weekdaycomp = defaultCalendar.component(.weekday, from: date)
    return weekdaycomp == (weekday.rawValue + 1)
}

func isWorkday(_ date: Date) -> Bool {
    let defaultCalendar = Calendar.current
    let weekday = defaultCalendar.component(.weekday, from: date)
    let weekdayEnum = WeekdayFlags(rawValue: weekday - 1)
    return weekdayEnum != .sun && weekdayEnum != .sat
}

func isWeekend(_ date: Date) -> Bool {
    let defaultCalendar = Calendar.current
    let weekday = defaultCalendar.component(.weekday, from: date)
    return weekday == 7 || weekday == 1
}
