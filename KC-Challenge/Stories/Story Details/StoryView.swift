//
//  StoryView.swift
//  KC-Challenge
//
//  Created by Nihed Majdoub on 03/05/2025.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

struct StoryView: View {
  
  let store: StoreOf<Story>
  
  var body: some View {
    ZStack {
      GeometryReader { geo in
        KFImage(store.story.imageURL)
          .resizable()
          .fade(duration: 0.2)
          .scaledToFill()
          .frame(width: geo.size.width)
          .clipped()
          .ignoresSafeArea()
      }
//      .overlay(alignment: .top) {
//        headerView
//      }
    }
//    .onAppear {
//      store.send(.setTimer)
//    }
//    .onDisappear {
//      store.send(.onDisappear)
//    }
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
  
  private var userView: some View {
    HStack {
      KFImage(store.story.user.avatarURL)
        .resizable()
        .fade(duration: 0.2)
        .scaledToFill()
        .frame(width: 40, height: 40)
        .clipShape(Circle())
      
      Text(store.story.user.name)
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
  StoryView(
    store: .init(
      initialState: Story.State(
        story: .mocks(count: 1).first!
      ),
      reducer: {
        Story()
      })
  )
}

