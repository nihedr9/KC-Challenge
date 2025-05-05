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
    var stories: [Story] = Story.mocks(count: 5)
    var selectedStory: Story?
    var timeElapsed = 0.0
    
    func progress(for index: Int) -> Double {
      guard let story = stories[safe: index] else { return 0 }
      guard selectedStory == story else { return 0 }
      
      return timeElapsed / story.duration
    }
  }
  
  enum Action {
    case fetchStories
    case setStories([Story])
    case nextImage
    case setTimer
    case timerTicked(Double)
    case cancelTimer
    case closeButtonTapped
    case onDisappear
  }
  
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.continuousClock) var clock
  private enum CancelID { case timer }
    
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        
      case .fetchStories:
        // we propably here have to fetch stories from an api but for now we will use a mock
        return .run { send in
          await send(.setStories(Story.mocks(count: 5)))
        }
        
      case .setStories(let stories):
        state.stories = stories
        state.selectedStory = stories.first
        
        return .run { send in
          await send(.setTimer)
        }
        
      case .setTimer:
        let interval = 0.3
        return .run { send in
          for await _ in clock.timer(interval: .seconds(interval)) {
            await send(.timerTicked(interval), animation: .smooth)
          }
        }
        .cancellable(id: CancelID.timer, cancelInFlight: true)
        
      case .timerTicked(let interval):
        guard let duration = state.selectedStory?.duration,
              duration >= state.timeElapsed else {
          return .run { await $0(.cancelTimer) }
        }
        state.timeElapsed += interval
        return .none
        
      case .cancelTimer:
        return .cancel(id: CancelID.timer)
    
      case .closeButtonTapped:
        return .run { _ in await dismiss() }
        
      case .nextImage:
        state.selectedStory = state.stories.randomElement()
        return .none
        
      case .onDisappear:
        return .run { send in
          await send(.cancelTimer)
        }
      }
    }
  }
}
