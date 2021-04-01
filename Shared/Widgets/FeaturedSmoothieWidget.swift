//
//  FeaturedSmoothieWidget
//  Fruta Widgets
//

import WidgetKit
import SwiftUI
import Intents

struct FeaturedSmoothieWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "FeaturedSmoothie", provider: Provider()) { entry in
            FeaturedSmoothieEntryView(entry: entry)
        }
        .configurationDisplayName("Featured Smoothie")
        .description("Displays the latest featured smoothie!")
    }
}

extension FeaturedSmoothieWidget {
    struct Provider: TimelineProvider {
        typealias Entry = FeaturedSmoothieWidget.Entry
       
        func placeholder(in context: Context) -> Entry {
            Entry(date: Date(), smoothie: .berryBlue)
        }
    
        func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
            let entry = Entry(date: Date(), smoothie: .berryBlue)
            completion(entry)
        }
        
        func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
            var entries: [Entry] = []

            let currentDate = Date()
            let smoothies = [Smoothie.berryBlue, .kiwiCutie, .hulkingLemonade, .lemonberry, .mangoJambo, .tropicalBlue]
            for index in 0..<smoothies.count {
                let entryDate = Calendar.current.date(byAdding: .hour, value: index, to: currentDate)!
                let entry = Entry(date: entryDate, smoothie: smoothies[index])
                entries.append(entry)
            }

            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

extension FeaturedSmoothieWidget {
    struct Entry: TimelineEntry {
        var date: Date
        var smoothie: Smoothie
    }
}

struct FeaturedSmoothieEntryView: View {
    var entry: FeaturedSmoothieWidget.Provider.Entry
    
    @Environment(\.widgetFamily) private var widgetFamily
    
    var title: some View {
        Text(entry.smoothie.title)
            .font(widgetFamily == .systemSmall ? Font.body.bold() : Font.title3.bold())
            .lineLimit(1)
            .minimumScaleFactor(0.1)
    }
    
    var description: some View {
        Text(entry.smoothie.description)
            .font(.subheadline)
    }
    
    var calories: some View {
        Text("\(entry.smoothie.kilocalories) Calories")
            .foregroundColor(.secondary)
            .font(.subheadline)
    }
    
    var image: some View {
        Rectangle()
            .overlay(
                entry.smoothie.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
            .aspectRatio(1, contentMode: .fit)
            .clipShape(ContainerRelativeShape())
    }
    
    var body: some View {
        ZStack {
            if widgetFamily == .systemMedium {
                HStack(alignment: .top, spacing: 20) {
                    VStack(alignment: .leading) {
                        title
                        description
                        calories
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityElement(children: .combine)
                    
                    image
                }
                .padding()
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading) {
                        title
                        if widgetFamily == .systemLarge {
                            description
                            calories
                        }
                    }
                    .accessibilityElement(children: .combine)
                    
                    image
                        .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BubbleBackground())
    }
}

struct FeaturedSmoothieWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FeaturedSmoothieEntryView(entry: FeaturedSmoothieWidget.Entry(date: Date(), smoothie: .berryBlue))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .redacted(reason: .placeholder)
            FeaturedSmoothieEntryView(entry: FeaturedSmoothieWidget.Entry(date: Date(), smoothie: .kiwiCutie))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            FeaturedSmoothieEntryView(entry: FeaturedSmoothieWidget.Entry(date: Date(), smoothie: .thatsBerryBananas))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
