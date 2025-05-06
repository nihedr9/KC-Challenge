# Kompanion Care Challenge

# Overview
This is my humble take on the **Kompanion Care iOS Assignment** using **SwiftUI and TCA**.
This app is composed of two main features:
- *Weather*: User can fetch weather forecast based on their location
- *Stories*: User can browse different stories in an Instagram-like manner

# Architecture
This app uses **TCA** as the architecture pattern following the **Clean Architecture principles**.
It separates the code into different modules (using **SPM**) for better testability, scalability, and maintainability.

## The **Weather** Feature

It uses two services to fetch *user location* and *weather forecast*:
- The user location service is responsible for requesting location permission and fetching location service
- The weather service uses *Swift Open API* library to create the networking stack

On each app launch, we check the location permission on the device:
- If it's the first launch, we present a "request permission" button to let the user request location permission
- If the user denies location permission request, we show an error view to let them change location authorization in app settings
- If the location permission is authorized, we proceed to fetch both user location and weather forecast

## The **Stories** Feature

- It uses a *stories client* to fetch stories. For the sake of this test, we use mocks but in a real-world app we would probably use an API
- We use a *Continuous Clock* to represent the progress of each story
- To implement the swiping effect between stories, I chose to use *TabView* with a paging style along with a binding (offered by *TCA*) to control the selection of current story

*PS*: The images presented in the stories are courtesy of *https://picsum.photos*

## What Could Be Improved

- We should add a *Design System* package
- *Model* structs should be added in a separate package for the sake of reusability
- We could create separate packages for the *weather* and *stories* features
- We definitely should write more tests

## Last Words

I tried to use the recent APIs and best practices described in the documentation of the *TCA* framework, but my logic could definitely be improved.

It was a fun journey learning and using *TCA* for this Challenge. I had previous experience with this framework in its early versions (before the 1.0.0 release).
I was pleasantly surprised by the evolution of this library and the effort spent to work seamlessly with the SwiftUI framework.
