import Foundation
import XCTest

extension ScrollingTests {

    override func measure(metrics: [XCTMetric], options: XCTMeasureOptions, block: () -> Void) {
        let measurements: [XCTMeasurement]
        if name == "-[ScrollingTests testFastScrolling]" {
            measurements = measurementsFast
        } else {
            measurements = measurementsSlow
        }

        for measurement in measurements {
            reportMetric(measurement, reportFailures: true)
        }
    }

    override func _recordValues(_ values: [Any],
                                forPerformanceMetricID performanceMetricID: String,
                                name: String,
                                unitsOfMeasurement: String,
                                baselineName: String?,
                                baselineAverage: NSNumber,
                                maxPercentRegression: NSNumber?,
                                maxPercentRelativeStandardDeviation: NSNumber?,
                                maxRegression: NSNumber?,
                                maxStandardDeviation: NSNumber?,
                                file: String,
                                line: UInt) {
        super._recordValues(values,
                            forPerformanceMetricID: performanceMetricID,
                            name: name,
                            unitsOfMeasurement: unitsOfMeasurement,
                            baselineName: baselineName,
                            baselineAverage: baselineAverage,
                            maxPercentRegression: maxPercentRegression,
                            maxPercentRelativeStandardDeviation: maxPercentRelativeStandardDeviation,
                            maxRegression: maxRegression,
                            maxStandardDeviation: maxStandardDeviation,
                            file: scrollingPerformanceTestFilePath,
                            line: performanceAnnotationLineForCurrentTest)
    }

    override func record(_ issue: XCTIssue) {
        var newIssue = issue
        let newLocation = XCTSourceCodeLocation(filePath: scrollingPerformanceTestFilePath, lineNumber: Int(testAnnotationLineForCurrentTest))
        newIssue.sourceCodeContext = XCTSourceCodeContext(location: newLocation)
        super.record(newIssue)
    }

    private var scrollingPerformanceTestFilePath: String {
        ((#file as NSString).deletingLastPathComponent as NSString).deletingLastPathComponent.appending("/ScrollingPerformance.swift")
    }

    private var performanceAnnotationLineForCurrentTest: UInt {
        let newLine: UInt
        if self.name == "-[ScrollingTests testSlowScrolling]" {
            newLine = 8
        } else {
            newLine = 14
        }
        return newLine
    }

    private var testAnnotationLineForCurrentTest: UInt {
        performanceAnnotationLineForCurrentTest - 1
    }
}

var measurementsSlow: [XCTMeasurement] {
    let measurement1 = XCTMeasurement()
    measurement1.identifier = "com.apple.dt.XCTMetric_OSSignpost-Scroll_Deceleration.animation.frame.rate"
    measurement1.units = "fps"
    measurement1.name = "Frame Rate (Scroll_Deceleration)"
    let measurement1Baseline: [String: Any] = ["baselineAverage": 55.651, "baselineIntegrationDisplayName": "Local Baseline"]
    measurement1.baseline = measurement1Baseline
    measurement1.measurements = [56.559521, 56.647957, 56.868507, 56.755806, 56.424782, 56.559521, 56.647957, 56.868507, 56.755806, 56.424782]

    let measurement2 = XCTMeasurement()
    measurement2.identifier = "com.apple.dt.XCTMetric_OSSignpost-Scroll_Deceleration.animation.hitches.total.duration"
    measurement2.units = "ms"
    measurement2.name = "Hitches Total Duration (Scroll_Deceleration)"
    let measurement2Baseline: [String: Any] = ["baselineAverage":  0, "baselineIntegrationDisplayName": "Local Baseline"]
    measurement2.baseline = measurement2Baseline
    measurement2.measurements = [66.282582, 66.372332, 66.344457, 99.541124, 33.202249, 66.282582, 66.372332, 66.344457, 99.541124, 33.202249]

    let measurement3 = XCTMeasurement()
    measurement3.identifier = "com.apple.dt.XCTMetric_OSSignpost-Scroll_Deceleration.duration"
    measurement3.units = "s"
    measurement3.name = "Duration (Scroll_Deceleration)"
    let measurement3Baseline: [String: Any] = ["baselineAverage": 2.408, "baselineIntegrationDisplayName": "Local Baseline"]
    measurement3.baseline = measurement3Baseline
    measurement3.measurements = [2.426460, 2.424568, 2.422519, 2.420826, 2.424949, 2.426460, 2.424568, 2.422519, 2.420826, 2.424949]

    let measurement4 = XCTMeasurement()
    measurement4.identifier = "com.apple.dt.XCTMetric_OSSignpost-Scroll_Deceleration.animation.hitch.time.ratio"
    measurement4.units = "ms per s"
    measurement4.name = "Hitch Time Ratio (Scroll_Deceleration)"
    let measurement4Baseline: [String: Any] = ["baselineAverage": 0, "baselineIntegrationDisplayName": "Local Baseline"]
    measurement4.baseline = measurement4Baseline
    measurement4.measurements = [27.316576, 27.374908, 27.386560, 41.118659, 13.691938, 27.316576, 27.374908, 27.386560, 41.118659, 13.691938]

    let measurement5 = XCTMeasurement()
    measurement5.identifier = "com.apple.dt.XCTMetric_OSSignpost-Scroll_Deceleration.animation.hitch.number"
    measurement5.units = "hitches"
    measurement5.name = "Number of Hitches (Scroll_Deceleration)"
    let measurement5Baseline: [String: Any] = ["baselineAverage": 0, "baselineIntegrationDisplayName": "Local Baseline"]
    measurement5.baseline = measurement5Baseline
    measurement5.measurements = [3.000000, 2.000000, 3.000000, 4.000000, 3.000000, 3.000000, 2.000000, 3.000000, 4.000000, 3.000000]

    let measurement6 = XCTMeasurement()
    measurement6.identifier = "com.apple.dt.XCTMetric_OSSignpost-Scroll_Deceleration.animation.frame.count"
    measurement6.units = "frames"
    measurement6.name = "Frame Count (Scroll_Deceleration)"
    let measurement6Baseline: [String: Any] = ["baselineAverage": 138.800, "baselineIntegrationDisplayName": "Local Baseline"]
    measurement6.baseline = measurement6Baseline
    measurement6.measurements = [138.809000, 138.809000, 138.809000, 138.809000, 138.809000, 138.809000, 138.809000, 138.809000, 138.809000, 138.809000]

    return [measurement1, measurement2, measurement3, measurement4, measurement5, measurement6]
}

var measurementsFast: [XCTMeasurement] {
    let measurement1 = XCTMeasurement()
    measurement1.identifier = "com.apple.dt.XCTMetric_OSSignpost-Scroll_Deceleration.animation.frame.rate"
    measurement1.units = "fps"
    measurement1.name = "Frame Rate (Scroll_Deceleration)"
    let measurement1Baseline: [String: Any] = ["baselineAverage": 57.651, "baselineIntegrationDisplayName": "Local Baseline"]
    measurement1.baseline = measurement1Baseline
    measurement1.measurements = [57.559521, 57.647957, 57.868507, 57.755806, 57.424782, 57.559521, 57.647957, 57.868507, 57.755806, 57.424782]

    let measurement2 = XCTMeasurement()
    measurement2.identifier = "com.apple.dt.XCTMetric_OSSignpost-Scroll_Deceleration.animation.hitches.total.duration"
    measurement2.units = "ms"
    measurement2.name = "Hitches Total Duration (Scroll_Deceleration)"
    let measurement2Baseline: [String: Any] = ["baselineAverage": 0, "baselineIntegrationDisplayName": "Local Baseline"]
    measurement2.baseline = measurement2Baseline
    measurement2.measurements = [0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000]

    let measurement3 = XCTMeasurement()
    measurement3.identifier = "com.apple.dt.XCTMetric_OSSignpost-Scroll_Deceleration.duration"
    measurement3.units = "s"
    measurement3.name = "Duration (Scroll_Deceleration)"
    let measurement3Baseline: [String: Any] = ["baselineAverage": 2.408, "baselineIntegrationDisplayName": "Local Baseline"]
    measurement3.baseline = measurement3Baseline
    measurement3.measurements = [2.414892, 2.411187, 2.401997, 2.406684, 2.403144, 2.414892, 2.411187, 2.401997, 2.406684, 2.403144]

    let measurement4 = XCTMeasurement()
    measurement4.identifier = "com.apple.dt.XCTMetric_OSSignpost-Scroll_Deceleration.animation.hitch.time.ratio"
    measurement4.units = "ms per s"
    measurement4.name = "Hitch Time Ratio (Scroll_Deceleration)"
    let measurement4Baseline: [String: Any] = ["baselineAverage": 0, "baselineIntegrationDisplayName": "Local Baseline"]
    measurement4.baseline = measurement4Baseline
    measurement4.measurements = [0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000]

    let measurement5 = XCTMeasurement()
    measurement5.identifier = "com.apple.dt.XCTMetric_OSSignpost-Scroll_Deceleration.animation.hitch.number"
    measurement5.units = "hitches"
    measurement5.name = "Number of Hitches (Scroll_Deceleration)"
    let measurement5Baseline: [String: Any] = ["baselineAverage": 0, "baselineIntegrationDisplayName": "Local Baseline"]
    measurement5.baseline = measurement5Baseline
    measurement5.measurements = [0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000]

    let measurement6 = XCTMeasurement()
    measurement6.identifier = "com.apple.dt.XCTMetric_OSSignpost-Scroll_Deceleration.animation.frame.count"
    measurement6.units = "frames"
    measurement6.name = "Frame Count (Scroll_Deceleration)"
    let measurement6Baseline: [String: Any] = ["baselineAverage": 138.800, "baselineIntegrationDisplayName": "Local Baseline"]
    measurement6.baseline = measurement6Baseline
    measurement6.measurements = [139.000000, 139.000000, 139.000000, 139.000000, 138.000000, 139.000000, 139.000000, 139.000000, 139.000000, 138.000000]

    return [measurement1, measurement2, measurement3, measurement4, measurement5, measurement6]
}
