//
//  StoriesView.swift
//  KC-Challenge
//
//  Created by Nihed Majdoub on 05/05/2025.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

struct StoriesView: View {
  
  @Bindable var store: StoreOf<Stories>
  
  var body: some View {
    TabView(selection: $store.currentStory.sending(\.setCurrentStory)) {
      ForEach(store.stories) { story in
        StoryView(story: story)
          .tag(story)
      }
    }
    .overlay(alignment: .top) {
      headerView
        .tag(store.currentStory)
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
    .ignoresSafeArea(edges: [.bottom])
    .onAppear {
      store.send(.fetchStories)
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
    StoryBarView(progress: store.state.progress)
      .frame(height: 4)
  }
  
  @ViewBuilder
  private var userView: some View {
    if let story = store.state.currentStory {
      HStack {
        KFImage(story.user.avatarURL)
          .resizable()
          .fade(duration: 0.2)
          .scaledToFill()
          .frame(width: 40, height: 40)
          .clipShape(Circle())
        
        Text(story.user.name)
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
  }
  
  private func dismissView() {
    store.send(.closeButtonTapped)
  }
}

#Preview {
  StoriesView(
    store: .init(
      initialState: Stories.State(),
      reducer: {
        Stories()
      })
  )
}
