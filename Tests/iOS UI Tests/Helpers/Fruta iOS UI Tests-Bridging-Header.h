//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XCTMeasurement : NSObject

@property (copy) NSString *identifier;
@property (copy) NSString *units;
@property (copy) NSString *name;
@property (copy) NSDictionary *baseline;
@property (copy) NSDictionary *defaultBaseline;
@property (copy) NSArray<NSNumber *> *measurements;

@end

@interface XCTestCase (RedeclareForTestMocking)

- (void)reportMetric:(XCTMeasurement *)perfMetric reportFailures:(BOOL)reportPerfMetricFailures;


- (void)_recordValues:(NSArray *)values
forPerformanceMetricID:(NSString *)performanceMetricID
                 name:(NSString *)name
   unitsOfMeasurement:(NSString *)unitsOfMeasurement
         baselineName:(nullable NSString *)baselineName
      baselineAverage:(NSNumber *)baselineAverage
 maxPercentRegression:(nullable NSNumber *)maxPercentRegression
maxPercentRelativeStandardDeviation:(nullable NSNumber *)maxPercentRelativeStandardDeviation
        maxRegression:(nullable NSNumber *)maxRegression
 maxStandardDeviation:(nullable NSNumber *)maxStandardDeviation
                 file:(NSString *)file
                 line:(NSUInteger)line;

@end

NS_ASSUME_NONNULL_END
