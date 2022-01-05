//
//  SetApp.swift
//  Set
//
//  Created by Esdras Forch on 10/29/21.
// Extra Credit:
// Peak Button that will reveal a set to us
// Keep score of the game and penalize for peaks and miselecting a set
// Keep track of time and reward players who get a match under the time limit

import SwiftUI

@main
struct SetApp: App {
    var body: some Scene {
        WindowGroup {
            SetGameView()
        }
    }
}
