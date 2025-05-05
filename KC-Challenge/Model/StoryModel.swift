//
//  StoryModel.swift
//  KC-Challenge
//
//  Created by Nihed Majdoub on 04/05/2025.
//

import Foundation

// MARK : - StoryModel

struct StoryModel: Identifiable, Equatable, Hashable {
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  let id: String
  let user: User
  let imageURL: URL
  let duration: Double
}


extension StoryModel {
  static func mocks(count: Int) -> [StoryModel] {
    var stories = [StoryModel]()
    for i in 0..<count {
      stories.append(
        .init(
          id: "\(i)",
          user: .mock(index: i),
          imageURL: .init(string: "https://picsum.photos/1920/1080?random=\(i)")!,
          duration: 5,
        )
      )
    }
    
    return stories
  }
}

// MARK : - User

struct User: Identifiable, Equatable {
  let id: String
  let name: String
  let avatarURL: URL?
}


extension User {
  static func mock(index: Int) -> User {
    User(
      id: "\(index)",
      name: "John Doe \(index)",
      avatarURL: URL(string: "https://picsum.photos/200?randowom=\(index)")
    )
  }
}
