//
//  LikeCollectionView.swift
//  Reservations
//
//  Created by Ahmed Abo Al-Regal on 22/07/2024.
//

import SwiftUI

struct CarouselItemLikeCollectionViewModel: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
}

struct CarouselItemLikeCollectionView: View {
    let item: CarouselItemLikeCollectionViewModel
    
    var body: some View {
        VStack {
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .clipped()
            
            Text(item.title)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.top, 10)
            
            Text(item.description)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing, .bottom], 10)
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding([.leading, .trailing], 5) // Add padding around each card
    }
}

struct GridView: View {
    let items: [CarouselItemLikeCollectionViewModel]
    
    let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var body: some View {
        List {
            LazyVGrid(columns: columns, spacing: 30) { // Increase spacing here
                ForEach(items) { item in
                    CarouselItemLikeCollectionView(item: item)
                }
            }
            .listRowInsets(EdgeInsets()) // Remove default list insets
            .listRowSeparator(.hidden)
            .padding(.all, 10) //.padding(.all, 15)
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
}

struct GridContentView: View {
    
    // Sample data for testing
    let sampleItems = [
        CarouselItemLikeCollectionViewModel(title: "Item 1", description: "Description for item 1", imageName: "CICD"),
        CarouselItemLikeCollectionViewModel(title: "Item 2", description: "Description for item 2", imageName: "CICD"),
        CarouselItemLikeCollectionViewModel(title: "Item 3", description: "Description for item 3", imageName: "CICD"),
        CarouselItemLikeCollectionViewModel(title: "Item 4", description: "Description for item 4", imageName: "CICD"),
        CarouselItemLikeCollectionViewModel(title: "Item 5", description: "Description for item 5", imageName: "CICD"),
        CarouselItemLikeCollectionViewModel(title: "Item 6", description: "Description for item 6", imageName: "CICD"),
        CarouselItemLikeCollectionViewModel(title: "Item 7", description: "Description for item 7", imageName: "CICD"),
        CarouselItemLikeCollectionViewModel(title: "Item 8", description: "Description for item 8", imageName: "CICD")
    ]
    
    var body: some View {
        GridView(items: sampleItems)
    }
}

struct LikeCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        GridContentView()
    }
}
