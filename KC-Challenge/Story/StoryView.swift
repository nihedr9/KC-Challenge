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
        
        KFImage(store.story?.imagesURL.first)
          .resizable()
          .fade(duration: 0.2)
          .aspectRatio(contentMode: .fill)
          .frame(width: geo.size.width)
          .ignoresSafeArea()
          .overlay(alignment: .top) {
            headerView
          }
        
      }
    }
    .onAppear {
//      viewModel.scheduleTimer(action: dismissView)
      store.send(.fetchStory)
    }
//    .onDisappear { viewModel.invalidateTimer() }
  }
  
  private var headerView: some View {
    VStack(alignment: .leading, spacing: 8) {
      
      progressView
      
      userView
    }
    .padding()
  }
  
  private var progressView: some View {
    ProgressView(
      timerInterval: Date()...Date().addingTimeInterval(5),
      countsDown: false,
      label: EmptyView.init,
      currentValueLabel: EmptyView.init
    )
    .tint(.white)
    .progressViewStyle(.linear)
  }
  
  private var userView: some View {
    HStack {
      KFImage(store.story?.user.avatarURL)
        .resizable()
        .fade(duration: 0.2)
        .scaledToFill()
        .frame(width: 40, height: 40)
        .clipShape(Circle())
      
      Text(store.story?.user.name ?? "")
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

//#Preview {
//  StoriesView()
//}
