//
//  LoadingPage.swift
//  HealthQuest
//
//  Created by JoshuaShin on 12/5/24.
//

import SwiftUI

//IGNORE for project
//I was setting up launch sequence to have a custom loading page since I wasn't sure how long it would take to load the data/assets. might be useful in the future if assets will be retrieved by the users from the cloud
struct LoadingView: View {
    
    var body: some View {
        VStack {
            //replace with another loading page
            Image("healthBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        }
        
    }
}

#Preview {
    LoadingView()
}
