//
//  ShakeEmCrapsApp.swift
//  ShakeEmCraps
//
//  Created by Tim Randall on 7/12/21.
//

import SwiftUI

@main
struct ShakeEmCrapsApp: App {
    @StateObject var viewChanger = ViewChanger()
    @StateObject var bet = IntOO()
    @StateObject var cash = IntOO2()
    @StateObject var pass = BoolOO()
    @StateObject var pointTotal = IntOO()
    @StateObject var shooterWins = BoolOO()
    @StateObject var winnings = IntOO()
    var body: some Scene {
        WindowGroup {
            BossView(viewChanger: viewChanger, bet: bet, cash: cash, pass: pass, pointTotal: pointTotal, shooterWins: shooterWins, winnings: winnings)
        }
    }
}

enum Page {
    case p1
    case p2
    case p3
    case p4
    case p5
}

enum EntryError: Error {
    case emptyField
    case notInt
}

class ViewChanger: ObservableObject {
    @Published var page: Page = .p1
}

class IntOO: ObservableObject {
    @Published var num: Int = 0
}

class IntOO2: ObservableObject {
    @Published var num: Int = 100
}

class BoolOO: ObservableObject {
    @Published var boo: Bool = false
}
