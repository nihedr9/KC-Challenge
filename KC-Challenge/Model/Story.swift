//
//  Story.swift
//  KC-Challenge
//
//  Created by Nihed Majdoub on 04/05/2025.
//

import Foundation

// MARK : - Story

struct Story: Identifiable, Equatable {
  let id: String
  let imageURL: URL
  let duration: Double
  let hasBeenSeen: Bool
}


extension Story {
  static func mocks(count: Int) -> [Story] {
    var stories = [Story]()
    for i in 0..<count {
      stories.append(
        .init(
          id: "\(i)",
          imageURL: .init(string: "https://picsum.photos/1920/1080?random=\(i)")!,
          duration: 5,
          hasBeenSeen: false
        )
      )
    }
    
    return stories
  }
}

// MARK : - User

struct User: Identifiable, Equatable {
  let id: UUID
  let name: String
  let avatarURL: URL?
}


extension User {
  static let mock = User(
    id: .init(),
    name: "John Doe",
    avatarURL: URL(string: "https://picsum.photos/200")
  )
}
