//
//  MenuSide.swift
//  Doctors
//
//  Created by Ahmed Abo Al-Regal on 23/03/2024.
//

import SwiftUI

struct MenuSide: View {
    // MARK: - PROPERTYS
    @Binding var selectedTab : String
    var animation: Namespace.ID
    @Binding var showMenue: Bool
    @AppStorage("isLogin") var isLogin: Bool = false

    
    // MARK: - Body
    var body: some View {
        VStack(alignment:.leading,spacing: 15) {
            Circle()
                .stroke(Color.white, lineWidth: 5)
                .frame(width: 70, height: 70) // Adjust size as needed
                .overlay(
                    Image("user")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                )
                .padding(.top, 50) // Adjust top padding
            
            //Profile
            
            VStack(alignment:.leading,spacing: 8){
                if let user: UserModel = UserDefaults.standard.getUser(forKey: "cachedUser") {
                    Text("Hi \(user.data.user.name)")
                        .font(.custom(GFFonts.SeguiBold, size: 20))
                        .foregroundColor(.white)
                    
                    Text("\(user.data.user.email)")
                        .font(.custom(GFFonts.SeguiBold, size: 8))
                        .foregroundColor(Color(.secondaryLabel))
                }
            }
            
            VStack{
                VStack(alignment:.leading,spacing:10){
                    
                    TabButton(image: "person", title: "Profile", selectedTab: $selectedTab, animation: animation)
                    
                    TabButton(image: "house", title: "Home", selectedTab: $selectedTab, animation: animation)
                    
                    
                    TabButton(image: "calendar", title: "Reservation", selectedTab: $selectedTab, animation: animation)
                    
                    TabButton(image: "qrcode.viewfinder", title: "Scanner", selectedTab: $selectedTab, animation: animation)
                    
                    TabButton(image: "bookmark.fill", title: "Saved", selectedTab: $selectedTab, animation: animation)
                    
//                    TabButton(image: "gearshape.fill", title: "Setting", selectedTab: $selectedTab, animation: animation)
                }
                .padding(.leading,-20)
                .padding(.top,50)
                
                Spacer()
            }
            
            //SignOut
            Button(action: {
                print("Login out")
                isLogin = false
            }, label: {
                HStack(spacing:15){
                    Image(systemName: "iphone.and.arrow.forward")
                        .font(.title2)
                        .frame(width: 30)
                        .foregroundColor(.white)
                    
                    Text("Logout")
                        .font(.custom(GFFonts.SeguiSemiBold, size: 16))
                        .foregroundColor(.white)
                }
                .foregroundColor(.white)
                .padding(.vertical,12)
                .padding(.horizontal,20)
            })

//            TabButton(image: "iphone.and.arrow.forward", title: "Logout", selectedTab: .constant(""), animation: animation)
//                .padding(.leading, -20)
        }
        .overlay {
            Button {
                showMenue.toggle()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .padding()
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .topLeading)
    }
    
}

struct UserModel: Codable {
    let status: String
    let data: UserDetails
}

struct UserDetails: Codable {
    let token: String
    let user: UserData
}

struct UserData: Codable {
    let name: String
    let email: String
    let MedicalHistory: MedicalHistoryResponseModel?
    let id: String
}

struct MedicalHistoryResponseModel: Codable {
    var gender: Int?
    var dateOfBirth: String?
    var countryId: Int?
    var cityId: Int?
    var height: Float?
    var weight: Float?
    var isExerciseAvilable: Bool?
    var exerciseType: Int?
    var isAnyHealthProblem: Bool?
    var medicine: [String]?
    var isPregnant: Bool?
    var isSmoker: Bool?
}

extension UserDefaults {
    func setUser(_ user: UserModel, forKey key: String) {
        if let encoded = try? JSONEncoder().encode(user) {
            self.set(encoded, forKey: key)
        }
    }
    
    func getUser(forKey key: String) -> UserModel? {
        if let data = self.data(forKey: key),
           let user = try? JSONDecoder().decode(UserModel.self, from: data) {
            return user
        }
        return nil
    }
}

//#Preview {
//    /*MenuSide*/()
//}
