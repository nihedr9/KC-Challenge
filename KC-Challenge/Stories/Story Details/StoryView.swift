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
  
  let story: StoryModel

  var body: some View {
    ZStack {
      GeometryReader { geo in
        KFImage(story.imageURL)
          .resizable()
          .fade(duration: 0.2)
          .scaledToFill()
          .frame(width: geo.size.width)
          .clipped()
          .ignoresSafeArea()
      }
    }
  }
}
