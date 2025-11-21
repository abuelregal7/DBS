//
//  ContentView.swift
//  Reservations
//
//  Created by Ahmed Abo Al-Regal on 20/05/2024.
//

import SwiftUI

struct ContentView: View {
    let tables = [
        (x: CGFloat(0), y: CGFloat(0), width: CGFloat(200), height: CGFloat(200)),
        (x: CGFloat(300), y: CGFloat(-400), width: CGFloat(220), height: CGFloat(220)),
        (x: CGFloat(-200), y: CGFloat(300), width: CGFloat(250), height: CGFloat(250)),
        (x: CGFloat(320), y: CGFloat(300), width: CGFloat(230), height: CGFloat(400)),
        (x: CGFloat(800), y: CGFloat(300), width: CGFloat(400), height: CGFloat(400))
    ]
    
    @State private var startScroll = false
    @State private var zoomLevel: CGFloat = 0.5
    @State private var selectedTables: Set<Int> = []
    @State private var isSingleSelection = true
    @State private var isSingleChairSelectionList: [Bool] // Track the selection mode for chairs in each table
    
    init() {
        _isSingleChairSelectionList = State(initialValue: Array(repeating: false, count: tables.count))
    }
    
    var body: some View {
        ZStack {
            Color(.systemGray4)
            GeometryReader { geometry in
                HStack {
                    VStack {
                        ScrollViewReader { proxy in
                            ScrollView([.vertical, .horizontal]) {
                                ZStack {
                                    ForEach(0..<tables.count, id: \.self) { index in
                                        let table = tables[index]
                                        TableView(
                                            index: index,
                                            width: table.width,
                                            height: table.height,
                                            isSelected: selectedTables.contains(index),
                                            selectedTables: $selectedTables,
                                            isSingleSelection: $isSingleSelection,
                                            isSingleChairSelection: $isSingleChairSelectionList[index] // Pass the individual chair selection mode
                                        )
                                        .offset(x: table.x, y: table.y)
                                        .id(index)
                                        .onTapGesture {
                                            if isSingleSelection {
                                                if selectedTables.contains(index) {
                                                    selectedTables.remove(index)
                                                } else {
                                                    selectedTables = [index]
                                                }
                                            } else {
                                                if selectedTables.contains(index) {
                                                    selectedTables.remove(index)
                                                } else {
                                                    selectedTables.insert(index)
                                                }
                                            }
                                        }
                                    }
                                }
                                .frame(
                                    width: contentWidth(geometry: geometry),
                                    height: contentHeight(geometry: geometry)
                                )
                                .scaleEffect(zoomLevel)
                            }
                            .onAppear {
                                if !startScroll {
                                    proxy.scrollTo(tables.count - 1, anchor: .leading)
                                    startScroll = true
                                }
                            }
                            
                            HStack {
                                Button(action: {
                                    zoomLevel += 0.1
                                    zoomInOutWithCenterContentToView(proxy: proxy, zoomLevel: zoomLevel)
                                }) {
                                    Text("Zoom In")
                                        .font(.system(size: 20, weight: .bold))
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                
                                Button(action: {
                                    fitContentToView(geometry: geometry, proxy: proxy)
                                }) {
                                    Text("Fit")
                                        .font(.system(size: 20, weight: .bold))
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                
                                Button(action: {
                                    zoomLevel = max(zoomLevel - 0.1, 0.1)
                                    zoomInOutWithCenterContentToView(proxy: proxy, zoomLevel: zoomLevel)
                                }) {
                                    Text("Zoom Out")
                                        .font(.system(size: 20, weight: .bold))
                                        .padding()
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                
                                Button(action: {
                                    isSingleSelection.toggle()
                                }) {
                                    Text(isSingleSelection ? "Switch to Multi Selection" : "Switch to Single Selection")
                                        .font(.system(size: 20, weight: .bold))
                                        .padding()
                                        .background(Color.cyan)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                
                            }
                            .padding()
                        }
                    }
                    //.frame(width: geometry.size.width * 0.65)
                    .frame(width: geometry.size.width)
//                    ZStack(alignment: .center) {
//                        ZStack {
//                            Rectangle()
//                                .fill(Color.white)
//                                .frame(width: geometry.size.width * 0.35)
//                            
//                            VStack(alignment: .center, spacing: 5) {
//                                Text("Welcome To Complex Design Using:")
//                                    .font(.system(size: 65, weight: .bold))
//                                    .multilineTextAlignment(.center)
//                                    .padding(.bottom , 30)
//                                
//                                Text("SwiftUI")
//                                    .font(.system(size: 65, weight: .bold))
//                                    .multilineTextAlignment(.center)
//                            }
//                        }
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
        .ignoresSafeArea(.all)
    }
    
    func contentWidth(geometry: GeometryProxy) -> CGFloat {
        let maxX = tables.map { $0.x + $0.width }.max() ?? 0
        let minX = tables.map { $0.x }.min() ?? 0
        return (abs(maxX - minX) + geometry.size.width) * zoomLevel
    }
    
    func contentHeight(geometry: GeometryProxy) -> CGFloat {
        let maxY = tables.map { $0.y + $0.height }.max() ?? 0
        let minY = tables.map { $0.y }.min() ?? 0
        return (abs(maxY - minY) + geometry.size.height) * zoomLevel
    }
    
    func fitContentToView(geometry: GeometryProxy, proxy: ScrollViewProxy) {
        let maxX = tables.map { $0.x + $0.width }.max() ?? 0
        let minX = tables.map { $0.x }.min() ?? 0
        let contentWidth = abs(maxX - minX)
        
        let maxY = tables.map { $0.y + $0.height }.max() ?? 0
        let minY = tables.map { $0.y }.min() ?? 0
        let contentHeight = abs(maxY - minY)
        
        let zoomWidth = geometry.size.width / (contentWidth + geometry.size.width)
        let zoomHeight = geometry.size.height / (contentHeight + geometry.size.height)
        
        zoomLevel = 0.5
        
        DispatchQueue.main.async {
            proxy.scrollTo(tables.count - 1, anchor: .leading)
        }
    }
    
    func zoomInOutWithCenterContentToView(proxy: ScrollViewProxy, zoomLevel: CGFloat) {
        self.zoomLevel = zoomLevel
        
        DispatchQueue.main.async {
            proxy.scrollTo(tables.count - 1, anchor: .leading)
        }
    }
    
}

struct TableView: View {
    var index: Int
    var width: CGFloat
    var height: CGFloat
    var isSelected: Bool
    
    @Binding var selectedTables: Set<Int>
    @Binding var isSingleSelection: Bool
    @Binding var isSingleChairSelection: Bool // New binding property for chair selection mode
    @State private var selectedChairs: Set<Int> = []
    
    var canSelectChair: Bool {
        return selectedTables.contains(index)
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(isSelected ? Color.yellow : Color.white)
                .frame(width: width, height: height)
                .cornerRadius(10)
                .overlay(
                    ZStack {
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.green)
                            .clipShape(Circle())
                            .offset(x: -width / 2 + 30, y: -height / 2 + 30)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("D-4")
                                .padding([.bottom, .top, .trailing])
                            Text("Arrived")
                            Text("Ahmed abu elregal")
                            Text("01:30 PM")
                        }
                        .offset(x: -width / 2 + 85, y: -height / 2 + height - 85)
                    }
                )
            
            let seatWidthVertically: CGFloat = 20
            let seatHeightVertically: CGFloat = 60
            let seatWidthHorizontally: CGFloat = 60
            let seatHeightHorizontally: CGFloat = 20
            let widthProportion = width / seatWidthVertically
            let heightProportion = height / seatHeightVertically
            let seatOffsetX: CGFloat = (widthProportion + 2) * seatWidthVertically / 2
            let seatOffsetY: CGFloat = (heightProportion + 0.5) * seatHeightVertically / 2
            let maxSeatsHorizontally = Int(width / seatWidthHorizontally) - 1
            let maxSeatsVertically = Int(height / seatHeightVertically) - 1
            
            VStack {
                ForEach(0..<maxSeatsVertically, id: \.self) { index in
                    Rectangle()
                        .fill(selectedChairs.contains(index) ? Color.orange : Color.blue)
                        .frame(width: seatWidthVertically, height: seatHeightVertically)
                        .cornerRadius(5)
                        .offset(x: -seatOffsetX, y: 0)
                        .onTapGesture {
                            selectChair(index: index)
                        }
                }
            }
            
            VStack {
                ForEach(0..<maxSeatsVertically, id: \.self) { index in
                    Rectangle()
                        .fill(selectedChairs.contains(maxSeatsVertically + index) ? Color.orange : Color.blue)
                        .frame(width: seatWidthVertically, height: seatHeightVertically)
                        .cornerRadius(5)
                        .offset(x: seatOffsetX, y: 0)
                        .onTapGesture {
                            selectChair(index: maxSeatsVertically + index)
                        }
                }
            }
            
            HStack {
                ForEach(0..<maxSeatsHorizontally, id: \.self) { index in
                    Rectangle()
                        .fill(selectedChairs.contains(maxSeatsVertically * 2 + index) ? Color.orange : Color.blue)
                        .frame(width: seatWidthHorizontally, height: seatHeightHorizontally)
                        .cornerRadius(5)
                        .offset(x: 0, y: -seatOffsetY)
                        .onTapGesture {
                            selectChair(index: maxSeatsVertically * 2 + index)
                        }
                }
            }
            
            HStack {
                ForEach(0..<maxSeatsHorizontally, id: \.self) { index in
                    Rectangle()
                        .fill(selectedChairs.contains(maxSeatsVertically * 2 + maxSeatsHorizontally + index) ? Color.orange : Color.blue)
                        .frame(width: seatWidthHorizontally, height: seatHeightHorizontally)
                        .cornerRadius(5)
                        .offset(x: 0, y: seatOffsetY)
                        .onTapGesture {
                            selectChair(index: maxSeatsVertically * 2 + maxSeatsHorizontally + index)
                        }
                }
            }
        }
        .onChange(of: selectedTables) { _ in
            if !selectedTables.contains(index) {
                selectedChairs.removeAll()
            } else if isSingleSelection {
                selectedChairs.removeAll()
            }
        }
    }
    
    private func selectChair(index: Int) {
        guard canSelectChair else { return }
        
        if isSingleChairSelection {
            if selectedChairs.contains(index) {
                selectedChairs.removeAll()
            } else {
                selectedChairs = [index]
            }
        } else {
            if selectedChairs.contains(index) {
                selectedChairs.remove(index)
            } else {
                selectedChairs.insert(index)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
