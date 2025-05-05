//
//  Story.swift
//  KC-Challenge
//
//  Created by Nihed Majdoub on 05/05/2025.
//

import ComposableArchitecture

@Reducer
struct Story {
  
  @ObservableState
  struct State: Equatable, Hashable {
    let story: StoryModel
    var timeElapsed = 0.0
    var progress = 0.0
    
//    var progress: Double {
//      return timeElapsed / story.duration
//    }
  }
  
  enum Action {
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
        
      case .setTimer:
        let interval = 0.3
        return .run { send in
          for await _ in clock.timer(interval: .seconds(interval)) {
            await send(.timerTicked(interval), animation: .smooth)
          }
        }
        .cancellable(id: CancelID.timer, cancelInFlight: true)
        
      case .timerTicked(let interval):
        guard state.story.duration >= state.timeElapsed else {
          return .run { await $0(.cancelTimer) }
        }
        state.timeElapsed += interval
        state.progress = state.timeElapsed / state.story.duration
        return .none
        
      case .cancelTimer:
        return .cancel(id: CancelID.timer)
        
      case .closeButtonTapped:
        return .run { _ in await dismiss() }
        
      case .onDisappear:
        return .run { send in
          await send(.cancelTimer)
        }
      }
    }
  }
}
