//
//  File.swift
//  
//
//  Created by User on 18/03/24.
//

import Foundation


func printFormattedPeriod(_ start: Date?, _ end: Date?) {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.year, .month, .day, .hour, .minute]
    formatter.unitsStyle = .full
    if let output = formatter.string(from: start!, to: end!) {
       print(output)
    }
}
func printFormattedAdd(_ futureDate: Date){
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .full
    dateFormatter.timeStyle = .short
    let output = dateFormatter.string(from: futureDate)
        print(output)
}
