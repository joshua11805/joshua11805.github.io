//
//  SideMenuView.swift
//  HealthQuest
//
//  Created by JoshuaShin on 12/3/24.
//

//IGNORE chose a different UI for MainView
import SwiftUI
struct SideMenuView: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        ZStack{
            if isShowing{
                //greying out the mainView when side menu is open
                Rectangle()
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                HStack {
                    VStack(alignment: .leading, spacing: 32) {
                        SideMenuHeaderView()
                        Spacer()
                    }
                    .padding()
                    .frame(width: 270, alignment: .leading)
                    .background(.white)
                    
                    Spacer()
                }
            }
        }
    }
}

struct SideMenuHeaderView: View{
    var body: some View{
        HStack{
            Image(systemName: "person.circle.fill")
                .imageScale(.large)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.vertical)
            VStack(alignment: .leading, spacing: 6){
                Text("Username")
                    .font(.subheadline)
                Text("email")
                    .font(.footnote)
                    .tint(.gray)
            }
        }
    }
}

#Preview {
    SideMenuView(isShowing: .constant(false))
}
