#  Fruta

## Introduction

Fruta is an app for iPhone, iPad, and Mac — built on top of the SwiftUI app life cycle. 

## Project Structure

This project has several primary groups: a `Shared` group for SwiftUI views that need to handle being deployed on any OS, and a group for `iOS` and `macOS` individually, as well as a group for `Widgets`. The OS-specific groups may include platform-dependent functionality or wrap UIKit or AppKit views for convienence for working in SwiftUI. 

## So I can just deploy a single user interface everywhere?

*No!*

While this app can deploy to both iOS and macOS, this project is _intentionally not_ write-once-and-deploy-everywhere. SwiftUI allows for a consistent language and API while we lay out our user interface and app structure, but different platforms have different interface guidelines. We must ensure the app is an excellent platform citizen with a great _look and feel_ on all the platforms on which it gets deployed. 

A simple example of this is the `SmoothieRowView` which changes its image's corner radii and padding based on OS. The `SmoothieHeaderView`  changes its layout based on horizontal size class on iOS, and utilizes the regular size class layout on macOS. As a more involved example, `AppSidebarNavigation` is in the `Shared` group, but can be swapped out when in compact size classes on iOS to the `AppTabNavigation` view that exists solely in the `iOS` group. 

## Style Guide

We follow the common [Swift Style Guide](https://google.github.io/swift/) with some minor modifications. Some important tips are to reduce extra spaces befor colons when declaring conformances or dictionaries. 

Correct:
- `func modify<Content: View>() -> some View`
- `init<Content>() where Content: View`
- `smoothieValues = [Smoothie.ID: Double]()`

Incorrect:
- `func modify<Content : View>() -> some View`
- `init<Content>() where Content : View`
- `smoothieValues = [Smoothie.ID : Double]()`
