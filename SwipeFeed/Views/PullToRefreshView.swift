//
//  PullToRefreshView.swift
//  SwipeFeed
//
//  Created by iMac on 27/05/25.
//

import SwiftUI

struct PullToRefreshView<Content: View>: View {
    @Binding var isLoading: Bool
    let onRefresh: () -> Void
    let content: () -> Content

    @State private var isRefreshing = false

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                GeometryReader { geo in
                    Color.clear
                        .preference(key: ScrollOffsetPreferenceKey.self, value: geo.frame(in: .global).minY)
                }
                .frame(height: 0)
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                    triggerRefreshIfNeeded(offset: offset)
                }

                content()
                    .frame(maxWidth: .infinity, minHeight: 600)
            }
            .offset(y: isRefreshing ? 60 : 0)
            .animation(.easeOut(duration: 0.25), value: isRefreshing)

            if isRefreshing {
                ZStack {
                    Color.navyBlueColor
                        .frame(height: 100)

                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2)
                }
                .edgesIgnoringSafeArea(.top)
                .transition(.move(edge: .top))
            }
        }
        .background(Color.redColor.ignoresSafeArea())
        .onChange(of: isLoading) { _, newValue in
            if !newValue {
                withAnimation {
                    isRefreshing = false
                }
            }
        }
    }

    private func triggerRefreshIfNeeded(offset: CGFloat) {
        guard offset > 80 && !isRefreshing else { return }
        isRefreshing = true
        isLoading = true
        onRefresh()
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


#Preview {
    struct LoaderPreviewWrapper: View {
        @State private var isLoading = false
        
        var body: some View {
            PullToRefreshView(isLoading: $isLoading, onRefresh: {
                print("Refresh triggered")
            }) {
                VStack {
                    Spacer()
                    Image("img_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 132, height: 60)
                    Spacer()
                }
            }
        }
    }
    
    return LoaderPreviewWrapper()
}
