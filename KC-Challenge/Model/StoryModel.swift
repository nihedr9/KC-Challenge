//
//  StoryModel.swift
//  KC-Challenge
//
//  Created by Nihed Majdoub on 04/05/2025.
//

import Foundation

struct StoryModel: Identifiable, Equatable {
  let id: UUID
  let user: User
  let imagesURL: [URL]
}

struct User: Identifiable, Equatable {
  let id: UUID
  let name: String
  let avatarURL: URL?
}
