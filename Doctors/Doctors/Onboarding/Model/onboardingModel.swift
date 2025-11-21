//
//  onboardingModel.swift
//  Doctors
//
//  Created by Ahmed Abo Al-Regal on 2023-10-27.
//

import Foundation
import SwiftUI

struct OnbordingModel: Identifiable {
    var id: Int
    let image: Image
    let title: String
    let descrption: String
}

extension OnbordingModel {
    static let onboardingData: [OnbordingModel] = [
        .init(id: 0,
              image: Images.onboarding1,
              title: "Who we are .",
              descrption: "You can search for doctors based on their specialization, ensuring that you find the right healthcare provider for your specific needs."),
        .init(id: 1,
              image: Images.onboarding2,
              title: "Our vision",
              descrption: "Is to empower users with personalized health management and seamless connectivity to healthcare providers for improved outcomes."),
        .init(id: 2,
              image: Images.onboarding3,
              title: "Why us",
              descrption: "Choose us for our commitment to user-centric design, innovative features tailored for optimal health management.")
    ]
}
