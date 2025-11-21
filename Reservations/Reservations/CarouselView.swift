//
//  CarouselView.swift
//  Reservations
//
//  Created by Ahmed Abo Al-Regal on 22/07/2024.
//

import SwiftUI

struct CarouselItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
}

struct CarouselItemView: View {
    let item: CarouselItem
    let scale: CGFloat
    
    var body: some View {
        VStack {
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 230, height: 180)
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
        .scaleEffect(scale)
    }
}

struct CarouselView: View {
    let items: [CarouselItem]
    @Binding var focusedIndex: Int
    
    var body: some View {
        GeometryReader { outerGeometry in
            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader { scrollViewProxy in
                    HStack(spacing: 20) {
                        ForEach(items.indices, id: \.self) { index in
                            GeometryReader { innerGeometry in
                                let scale = self.getScale(proxy: innerGeometry, outerProxy: outerGeometry)
                                CarouselItemView(item: items[index], scale: scale)
                                    .id(index)
                                    .onTapGesture {
                                        withAnimation {
                                            scrollViewProxy.scrollTo(index, anchor: .center)
                                            focusedIndex = index
                                        }
                                    }
                            }
                            .frame(width: 200, height: 250)
                        }
                    }
                }
                .padding()
            }
        }
        .frame(height: 270)
        // Adjust the height as needed
    }
    
    private func getScale(proxy: GeometryProxy, outerProxy: GeometryProxy) -> CGFloat {
        let _: CGFloat = 200 / 2 // midPoint
        let viewFrame = outerProxy.frame(in: .global)
        let viewMidX = viewFrame.midX
        let currentX = proxy.frame(in: .global).midX
        let distance = abs(viewMidX - currentX)
        let tolerance: CGFloat = 200
        let scale = max(1 - (distance / tolerance), 0.85)
        return scale
    }
}

struct CarouselContentView: View {
    
    // Sample data for testing
    let sampleItems = [
        CarouselItem(title: "Item 1", description: "Description for item 1", imageName: "CICD"),
        CarouselItem(title: "Item 2", description: "Description for item 2", imageName: "CICD"),
        CarouselItem(title: "Item 3", description: "Description for item 3", imageName: "CICD"),
        CarouselItem(title: "Item 4", description: "Description for item 4", imageName: "CICD"),
        CarouselItem(title: "Item 5", description: "Description for item 5", imageName: "CICD"),
        CarouselItem(title: "Item 6", description: "Description for item 6", imageName: "CICD"),
        CarouselItem(title: "Item 7", description: "Description for item 7", imageName: "CICD"),
        CarouselItem(title: "Item 8", description: "Description for item 8", imageName: "CICD")
    ]
    
    @State private var focusedIndex: Int = 0
    
    var body: some View {
        List {
            // Your existing carousel sections
            ForEach(0...9, id: \.self) { index in
                Section {
                    Text("Carousel Zooming Focus \(index + 1)")
                        .font(.largeTitle)
                        .multilineTextAlignment(.leading)
                        .padding([.leading, .trailing], 35)
                    
                    CarouselView(items: sampleItems, focusedIndex: $focusedIndex)
                }
                .padding([.leading, .trailing], -20)
                .listRowInsets(EdgeInsets()) // Remove default list insets
                .listRowSeparator(.hidden)
            }
            
            // Adding GridContentView
            Section {
                GridContentView()
                    .frame(height: calculateGridHeight(itemCount: sampleItems.count, columns: 2, itemHeight: 250))
            }
            //.padding([.leading, .trailing], -10)
            .listRowInsets(EdgeInsets()) // Remove default list insets
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
    
    // Calculate grid height based on number of items and columns
    private func calculateGridHeight(itemCount: Int, columns: Int, itemHeight: CGFloat) -> CGFloat {
        let rows = (itemCount + columns - 1) / columns
        return CGFloat(rows) * itemHeight + CGFloat(rows - 1) * 20 // 20 is the spacing between items
    }
}

struct CarouselViewList_Previews: PreviewProvider {
    static var previews: some View {
        CarouselContentView()
    }
}
