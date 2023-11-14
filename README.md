# Workouts App

<img width="200" src="https://github.com/MaurixFx/Workouts/assets/28694208/c6c704ad-170c-4213-9693-d3f2dafa85b6">

Explore a list of exercises where you can see the detail information. 
The detail view information displays: name, description, images section, variations section


<img width="200" src="https://github.com/MaurixFx/Workouts/assets/28694208/2eb9c757-cb52-474f-ac21-377c6b1bda90">
<img width="200" src="https://github.com/MaurixFx/Workouts/assets/28694208/81606fbf-169c-4c0f-9a2d-9dcb95a3650d">
<img width="200" src="https://github.com/MaurixFx/Workouts/assets/28694208/a0c67db1-6c7d-4336-a919-7675ab647026">

## Architecture: MVVM-C

<img width="1500" alt="architecture" src="https://github.com/MaurixFx/Workouts/assets/28694208/f31d0ab7-224a-4bb8-b71a-c2e008973c38">

## UI

UIKit base application which contains also SwiftUI components

## Third-party dependencies

- [SDWebImageSwiftUI](https://github.com/SDWebImage/SDWebImageSwiftUI) — A lightweight, pure-Swift library for downloading and caching images from the web.
- [SnapshotTesting](https://github.com/pointfreeco/swift-snapshot-testing) — Delightful Swift snapshot testing.

## Testing - Code coverage 89% (Please run tests on iPhone SE, since the snapshots were recorded with that device)
- Unit Tests using TDD methodology
- Integration tests (End to End): Testing Exercise list network call using a [Mock API](https://run.mocky.io/v3/ac5e05d3-470f-4a6a-a9dd-a5d23d760914)
- Snapshot tests (Recorded on iPhone SE 3rd generation)

## Future improvements (Modularizarion using SPM)
 - Create packages modules for reusable layers: Network, Models, Helpers, etc
 - Create Feature modules: Exercises Implementation can be a package, if there are other features like list of Muscles, Equipments, each feature should have its own package

