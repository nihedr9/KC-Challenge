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
    var stories: [StoryModel] = StoryModel.mocks(count: 5)
    var currentStory: StoryModel?
    var timeElapsed = 0.0
    var progress = 0.0
  }
  
  enum Action {
    case fetchStories
    case setStories([StoryModel])
    case setCurrentStory(StoryModel?)
    case nextImage
    case setTimer
    case timerTicked(Double)
    case cancelTimer
    case closeButtonTapped
  }
  
  @Dependency(\.dismiss) var dismiss
  @Dependency(StoriesClient.self) var storiesClient
  @Dependency(\.continuousClock) var clock
  private enum CancelID { case timer }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        
      case .fetchStories:
        return .run { send in
          let stories = try await storiesClient.fetchStories(5)
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
        
      case .nextImage:
        return .run { [stories = state.stories] send in
          await send(.setCurrentStory(stories.randomElement()))
        }
        
      case .setTimer:
        let interval = 0.2
        state.timeElapsed = 0
        state.progress = 0
        return .run { send in
          for await _ in clock.timer(interval: .seconds(interval)) {
            await send(.timerTicked(interval), animation: .smooth)
          }
        }
        .cancellable(id: CancelID.timer, cancelInFlight: true)
        
      case .timerTicked(let interval):
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
