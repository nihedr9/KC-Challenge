//
//  StoryBarView.swift
//  KC-Challenge
//
//  Created by Nihed Majdoub on 04/05/2025.
//

import SwiftUI

struct StoryBarView: View {
  
  var progress: Double
  
  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        Rectangle()
          .foregroundColor(Color.white.opacity(0.3))
          .cornerRadius(5)
        Rectangle()
          .frame(width: geometry.size.width * self.progress, height: nil, alignment: .leading)
          .foregroundColor(Color.white.opacity(0.9))
          .cornerRadius(5)
      }
    }
  }
}
