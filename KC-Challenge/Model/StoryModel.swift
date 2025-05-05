//
//  StoryModel.swift
//  KC-Challenge
//
//  Created by Nihed Majdoub on 04/05/2025.
//

import Foundation

// MARK : - StoryModel

struct StoryModel: Identifiable, Equatable, Hashable {
  
  let id: String
  let user: User
  let imageURL: URL
  let duration: Double
}


extension StoryModel {
  
  static func mock(index: Int) -> StoryModel {
    .init(
      id: "\(index)",
      user: .mock(index: index),
      imageURL: URL(string: "https://picsum.photos/1920/1080?random=\(index)")!,
      duration: 5,
    )
  }
  
  static func mocks(count: Int) -> [StoryModel] {
    var stories = [StoryModel]()
    for i in 0..<count {
      stories.append(.mock(index: i))
    }
    
    return stories
  }
}

// MARK : - User

struct User: Identifiable, Equatable, Hashable {
  let id: String
  let name: String
  let avatarURL: URL?
}


extension User {
  static func mock(index: Int) -> User {
    User(
      id: "\(index)",
      name: "John Doe \(index)",
      avatarURL: URL(string: "https://picsum.photos/200?random=\(index)")
    )
  }
}
