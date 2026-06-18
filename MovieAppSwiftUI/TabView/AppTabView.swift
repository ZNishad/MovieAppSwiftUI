//
//  AppTabView.swift
//  TestProject
//
//  Created by Nishad Zulfuqarli on 21.05.26.
//

import SwiftUI

struct AppTabView: View {
    var body: some View {
        TabView(selection: $selectedTab) {
            homeTab
            searchTab
            watchListTab
        }
        .tint(.strokeText)
        .colorScheme(.light)
        .background(Color.clear)
    }

    @State private var selectedTab: Int = 0

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

// MARK: - Views
extension AppTabView {

    @ViewBuilder
    private var homeTab: some View {
        NavigationStack {
            MainView(selectedTab: $selectedTab)
        }
        .tabItem {
            Image(systemName: "house.fill")
            Text("Home")
        }
        .tag(0)
    }

    @ViewBuilder
    private var searchTab: some View {
        NavigationStack {
            SearchView()
        }
        .tabItem {
            Image(systemName: "magnifyingglass")
            Text("Search")
        }
        .tag(1)
    }

    @ViewBuilder
    private var watchListTab: some View {
        NavigationStack {
            WatchListView()
        }
        .tabItem {
            Image(systemName: "bookmark")
            Text("Watch List")
        }
        .tag(2)
    }
}
