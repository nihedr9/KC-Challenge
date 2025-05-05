//
//  Stories+Dependencies.swift
//  KC-Challenge
//
//  Created by Nihed Majdoub on 05/05/2025.
//

import ComposableArchitecture

@DependencyClient
struct StoriesClient {
  var fetchStories: @Sendable (Int) async throws -> [StoryModel]
}

extension StoriesClient: DependencyKey {
  // we propably here have to fetch stories from an api but for now we will use a mock
  static let liveValue = Self { count in
    StoryModel.mocks(count: count)
  }
}

extension StoriesClient: TestDependencyKey {
  static let previewValue = Self { count in
    StoryModel.mocks(count: count)
  }
  
  static let testValue = Self { count in
    StoryModel.mocks(count: count)
  }
}

extension DependencyValues {
  var storiesClient: StoriesClient {
    get { self[StoriesClient.self] }
    set { self[StoriesClient.self] = newValue }
  }
}
