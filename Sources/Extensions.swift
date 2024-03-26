//
//  Extensions.swift
//
//
//  Created by User on 13/03/24.
//

import Foundation
import ArgumentParser

// cp -f timecounter /usr/local/bin/timecounter

extension Date: ExpressibleByArgument {
    public init?(argument: String) {
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "dd/MM/yyyy"
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "dd/MM/yyyy HH:mm"
        if let date = formatter1.date(from: argument) ?? formatter2.date(from: argument) {
            self = date
        } else {
            return nil
        }
    }
}

