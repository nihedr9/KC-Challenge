//
//  StoriesView.swift
//  KC-Challenge
//
//  Created by Nihed Majdoub on 03/05/2025.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

struct StoriesView: View {
  
  let store: StoreOf<Stories>
  
  var body: some View {
    ZStack {
      if let  story = store.selectedStory {
        StoryView(story: story)
          .overlay(alignment: .top) {
            headerView
          }
          .onTapGesture {
            store.send(.nextImage)
          }
      } else {
        ProgressView()
      }
    }
    .onAppear {
      store.send(.fetchStories)
    }
    .onDisappear {
      store.send(.onDisappear)
    }
  }
  
  private var headerView: some View {
    ZStack {
      Color.black.opacity(0.4)
        .background(.ultraThinMaterial)
      VStack(alignment: .leading, spacing: 8) {
        progressView
        userView
      }
      .padding()
    }
    .frame(height: 80)
  }
  
  private var progressView: some View {
    HStack(spacing: 4) {
      ForEach(0..<store.stories.count, id: \.self) { index in
        StoryBarView(progress: store.state.progress(for: index))
          .frame(height: 4)
      }
    }
  }
  
  private var userView: some View {
    HStack {
      KFImage(store.user.avatarURL)
        .resizable()
        .fade(duration: 0.2)
        .scaledToFill()
        .frame(width: 40, height: 40)
        .clipShape(Circle())
      
      Text(store.user.name)
        .font(.callout)
      
      Spacer()
      
      Button {
        dismissView()
      } label: {
        Image(systemName: "xmark")
          .font(.title)
      }
    }
    .foregroundStyle(.white)
  }
  
  private func dismissView() {
    store.send(.closeButtonTapped)
  }
}

#Preview {
  StoriesView(store: .init(initialState: Stories.State(), reducer: {
    Stories()
  }))
}

