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
  struct State: Equatable, Hashable {
    var stories: [StoryModel] = []
    var currentStory: StoryModel?
    var timeElapsed = 0.0
    var progress = 0.0
  }
  
  enum Action {
    case fetchStories
    case setStories([StoryModel])
    case setCurrentStory(StoryModel?)
    case setTimer
    case timerTicked
    case cancelTimer
    case closeButtonTapped
  }
  
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.storiesClient) var storiesClient
  @Dependency(\.continuousClock) var clock
  private enum CancelID { case timer }
  
  private let storiesCount = 5
  private let interval = 0.2

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        
      case .fetchStories:
        return .run { send in
          let stories = try await storiesClient.fetchStories(storiesCount)
          await send(.setStories(stories))
        }
        
      case .setStories(let stories):
        state.stories = stories
        return .run { send in
          await send(.setCurrentStory(stories.first))
        }
        
      case .setCurrentStory(let story):
        state.currentStory = story
        return .run { send in
          await send(.setTimer)
        }
        
      case .setTimer:
        state.timeElapsed = 0
        state.progress = 0
        
        return .run { send in
          for await _ in clock.timer(interval: .seconds(interval)) {
            await send(.timerTicked, animation: .smooth)
          }
        }
        .cancellable(id: CancelID.timer, cancelInFlight: true)
        
      case .timerTicked:
        guard let story = state.currentStory,
              story.duration >= state.timeElapsed else {
          return .run { await $0(.cancelTimer) }
        }
        state.timeElapsed += interval
        state.progress = state.timeElapsed / story.duration
        return .none
        
      case .cancelTimer:
        return .cancel(id: CancelID.timer)
        
      case .closeButtonTapped:
        return .run { _ in await dismiss() }
        
      }
    }
  }
}
