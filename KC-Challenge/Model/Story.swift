//
//  Story.swift
//  KC-Challenge
//
//  Created by Nihed Majdoub on 04/05/2025.
//

import Foundation

struct Story: Identifiable, Equatable {
  let id: String
  let imageURL: URL
}

struct User: Identifiable, Equatable {
  let id: UUID
  let name: String
  let avatarURL: URL?
}
