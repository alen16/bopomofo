//
//  bopomofoApp.swift
//  bopomofo
//
//  Created by ALLEN WU on 10/21/25.
//

import SwiftUI

@main
struct BopomofoDropGameApp: App {
    @StateObject private var viewModel = GameViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}

