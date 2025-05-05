//
//  StoryView.swift
//  KC-Challenge
//
//  Created by Nihed Majdoub on 04/05/2025.
//

import SwiftUI
import Kingfisher

struct StoryView: View {
  
  let story: Story
  
  var body: some View {
    GeometryReader { geo in
      KFImage(story.imageURL)
        .resizable()
        .fade(duration: 0.2)
        .scaledToFill()
        .frame(width: geo.size.width)
        .ignoresSafeArea()
    }
  }
}
