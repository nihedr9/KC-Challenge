//
//  StoriesTests.swift
//  KC-Challenge
//
//  Created by Nihed Majdoub on 05/05/2025.
//

import ComposableArchitecture
import CoreLocation
import Testing

@testable import KC_Challenge

@MainActor
struct StoriesTests {
  
  @Test
  func fetchStories() async throws {
    let store = TestStore(initialState: Stories.State()) {
      Stories()
    } withDependencies: {
      $0.continuousClock = ImmediateClock()
    }
    store.exhaustivity = .off
    
    await store.send(.fetchStories)
    
    await store.receive(\.setTimer) {
      $0.stories = StoryModel.mocks(count: 5)
      $0.currentStory = $0.stories.first
      $0.progress = 0
    }
  }
  
  @Test
  func checkProgress() async throws {
    let store = TestStore(initialState: Stories.State()) {
      Stories()
    } withDependencies: {
      $0.continuousClock = ImmediateClock()
    }
    store.exhaustivity = .off
    
    await store.send(.fetchStories)
    
    await store.receive(\.timerTicked) {
      $0.progress = $0.timeElapsed / $0.currentStory!.duration
    }
  }
  
  @Test
  func setCurrentStory() async throws {
    let store = TestStore(initialState: Stories.State()) {
      Stories()
    } withDependencies: {
      $0.continuousClock = ImmediateClock()
    }
    store.exhaustivity = .off
    let stories = StoryModel.mocks(count: 5)
    await store.send(.setCurrentStory(stories.last))
    
    await store.receive(\.setTimer) {
      $0.currentStory = stories.last
    }
  }
}
