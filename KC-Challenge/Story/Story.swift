//
//  Story.swift
//  KC-Challenge
//
//  Created by Nihed Majdoub on 03/05/2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct Story {
  
  @ObservableState
  struct State: Equatable {
    var story: StoryModel?
  }
  
  enum Action {
    case fetchStory
    case setStory(StoryModel)
    case closeButtonTapped
  }
  
  @Dependency(\.dismiss) var dismiss
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .fetchStory:
        // we propably here have to fetch stories from an api
        // but for now we will use a mock
        return .run { send in
          await send(.setStory(.mock(id: UUID())))
        }
      case .setStory(let story):
        state.story = story
        return .none
      case .closeButtonTapped:
        return .run { _ in await dismiss() }
      }
    }
  }
}

extension StoryModel {
  static func mock(id: UUID) -> StoryModel {
    StoryModel(
      id: id,
      user: .mock,
      imagesURL: [
        URL(string: "https://picsum.photos/1920/1080?random=\(id.uuidString)")!,
        URL(string: "https://picsum.photos/1920?random=\(id.uuidString)")!,
        URL(string: "https://picsum.photos/1080?random=\(id.uuidString)")!
      ]
    )
  }
}

extension User {
  static let mock = User(
    id: .init(),
    name: "John Doe",
    avatarURL: URL(string: "https://picsum.photos/200")
  )
}
