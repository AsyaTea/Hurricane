//
//  SwiftUIView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 05/05/22.
//

import SwiftUI
import UIKit

struct TabBarView: View {
    
    var body: some View {
        TabView{
            MainView()
                .tabItem {
                    Image("carIcon")
                        .renderingMode(.template)
                }
            
            MainView()
                .tabItem {
                    Image("chartIcon")
                        .renderingMode(.template)
                }
            MainView()
                .tabItem {
                    Image("settingsIcon")
                        .renderingMode(.template)
                }
        }
        .accentColor(Palette.black)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}


