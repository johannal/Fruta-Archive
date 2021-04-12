# Fruta 2.0 

Fruta 2.0 is a multiplatform app which improves on last year's release by featuring Star and Sky APIs for use in the WWDC Keynote, State of the Union, and various sessions. A stripped down version will eventually be made available as an update to the [currently shipping sample code release](https://developer.apple.com/documentation/swiftui/fruta_building_a_feature-rich_app_with_swiftui).

## Project Architecture

This year's base version of Fruta will include simple iOS and macOS app targets without any submodules, packages, playgrounds, or associated targets (including tests). All extended functionality that introduce extra signing, entitlement, or capability requirements are moved to new "Extended" targets which include things like Apple Pay, Sign in with Apple, App Clip, Widgets, Tests, and some other features.

## WWDC 2021 Sessions

For use in WWDC sessions, feel free to branch off of `main` and modify Fruta to fit your project. Make sure you identify if you want to use the basic or extended targets, described above.

At this time there are no known configurations of Sunriver, Sky, and Star that fit every need. It's up to you to find a configuration that bests fits your needs. The good news is we aren't planning on adopting any bleeding edge SwiftUI APIs that are landing post M3 like we did last year, so if you're using a relatively recent Sunriver/Star/Sky you should be good to go.

Note that we are deferring adoption of the improved `NavigationView` APIs until the sample code release (maybe even after beta 1), so your demo must explicitely avoid showing off any `NavigationView` or `NavigationLink` API content. If you are required to show something navigation-related, please reach out to Jake Sawyer on Slack.

## Contributing

The Fruta project is meant to lead app developers by example, if you find anything worth improving in the project (even as the final output of a demo or session) please feel free to make a pull request.

## Known Issues

Star builds between Star21A214a and Star21A219b will brick prod-fused T2 Macs' bridgeOS. Upgrade with caution and double check livability when choosing a host OS.

Fruta running on builds of Star before 21A212 will not render any visual effect blurs. If you plan to show the macOS version of Fruta you must be on a (safe) recent version of Star, which at the time of writing there is no known recommendation (as 219b has issues with Xcode builds).

## Radar

Radar component: `DT Demo Apps | Fruta 2021`
