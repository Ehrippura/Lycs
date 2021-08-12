//
//  App.swift
//  Lycs
//
//  Created byTzu-Yi Lin on 2021/8/12.
//  Copyright © 2021Tzu-Yi Lin. All rights reserved.
//

import SwiftUI

@main
struct LycsApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            SidebarCommands()
        }
    }
}
