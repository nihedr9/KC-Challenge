//
//  Stories.swift
//  KC-Challenge
//
//  Created by Nihed Majdoub on 03/05/2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct Stories {
  
  @ObservableState
  struct State: Equatable {
    var user = User.mock
    var stories: [Story] = []
    var selectedStory: Story?
  }
  
  enum Action {
    case fetchStories
    case setStories([Story])
    case nextImage
    case closeButtonTapped
  }
  
  @Dependency(\.dismiss) var dismiss
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .fetchStories:
        // we propably here have to fetch stories from an api
        // but for now we will use a mock
        return .run { send in
          await send(.setStories(Story.mocks(count: 5)))
        }
      case .setStories(let stories):
        state.stories = stories
        state.selectedStory = stories.randomElement()
        return .none
      case .closeButtonTapped:
        return .run { _ in await dismiss() }
      case .nextImage:
        state.selectedStory = state.stories.randomElement()
        return .none
      }
    }
  }
}

extension Story {
  static func mocks(count: Int) -> [Story] {
    var stories = [Story]()
    for i in 0..<count {
      stories.append(.init(id: "\(i)", imageURL: .init(string: "https://picsum.photos/1920/1080?random=\(i)")!))
    }
    
    return stories
  }
}

extension User {
  static let mock = User(
    id: .init(),
    name: "John Doe",
    avatarURL: URL(string: "https://picsum.photos/200")
  )
}
