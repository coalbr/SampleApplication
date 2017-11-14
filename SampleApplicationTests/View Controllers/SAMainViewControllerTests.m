//
//  SAMainViewControllerTests.m
//  SampleApplicationTests
//
//  Created by Austin Albrecht on 11/13/17.
//  Copyright © 2017 Austin Albrecht. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAMainView.h"
#import "SAMainViewController.h"
#import "UIColor+CustomColors.h"
#import <OCMock/OCMock.h>

@interface SAMainViewController(UnitTesting)

@property (nonatomic) NSMutableArray<NSNumber *> *results;
@property (nonatomic) CFTimeInterval startTime;
@property (nonatomic) NSTimer *timer;
@property (nonatomic, weak) SAMainView *view;

- (IBAction)onCircleButtonTouchUpInside:(UIButton *)sender;
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)recognizer;

- (NSArray<NSString *> *)buildKeysArray;
- (NSNumber *)calculateAverage;
- (NSString *)generateResultsText;
- (void)onBeginTrialTimerCompleted;
- (NSInteger)randomNumberBetween:(NSInteger)minimum and:(NSInteger)maximum;

@end

@interface SAMainViewControllerTests : XCTestCase

@property (nonatomic) id viewMock;

@end

@implementation SAMainViewControllerTests

#pragma mark - Helper methods
- (void)setUp
{
    [super setUp];
    self.viewMock = OCMClassMock([SAMainView class]);
}

- (SAMainViewController *)viewControllerForTesting
{
    SAMainViewController *viewController = [SAMainViewController new];
    viewController.view = self.viewMock;
    
    return viewController;
}

#pragma mark - Test methods
- (void)testViewDidLoadDoesCorrectSetup
{
    SAMainViewController *viewController = [self viewControllerForTesting];
    
    [viewController viewDidLoad];
    
    XCTAssertNotNil(viewController.results);
}

- (void)testBuildKeysArrayReturnsCorrectArray
{
    SAMainViewController *viewController = [self viewControllerForTesting];
    NSArray <NSString *> *expectResult = @[@"Trial 1 Interval",
                                           @"Trial 2 Interval",
                                           @"Trial 3 Interval",
                                           @"Trial 4 Interval",
                                           @"Trial 5 Interval",
                                           @"Average Interval"];
    
    NSArray<NSString *> *keys = [viewController buildKeysArray];
    
    
    XCTAssertEqualObjects(keys, expectResult);
}

- (void)testCalculateAverageReturnsCorrectValue
{
    SAMainViewController *viewController = [self viewControllerForTesting];
    viewController.results = @[@2, @4, @4, @1, @6].mutableCopy;
    
    NSNumber *average = [viewController calculateAverage];
    
    XCTAssertEqualWithAccuracy(average.floatValue, 3.4, 0.01);
}

- (void)testGenerateResultsTextReturnsCorrectString
{
    SAMainViewController *viewController = [self viewControllerForTesting];
    viewController.results = @[@2, @4, @4, @1, @6].mutableCopy;
    
    NSString *resultsText = [viewController generateResultsText];
    
    XCTAssertEqualObjects(resultsText, @"{\n  \"Trial 2 Interval\" : 4,\n  \"Trial 3 Interval\" : 4,\n  \"Trial 1 Interval\" : 2,\n  \"Average Interval\" : 3.4000000953674316,\n  \"Trial 4 Interval\" : 1,\n  \"Trial 5 Interval\" : 6\n}");
}

- (void)testOnBeginTrialTimerCompletedCallsCorrectMethods
{
    SAMainViewController *viewController = [self viewControllerForTesting];
    OCMExpect([self.viewMock updateForTrialStarted]);
    
    [viewController onBeginTrialTimerCompleted];
    
    XCTAssertNil(viewController.timer);
    OCMVerifyAll(self.viewMock);
}

- (void)testRandomNumberGeneratedIsBetweenLimits
{
    SAMainViewController *viewController = [self viewControllerForTesting];
    
    NSInteger value = [viewController randomNumberBetween:1 and:3];
    
    XCTAssertTrue(value >= 1);
    XCTAssertTrue(value <= 3);
}

- (void)testOnCircleButtonTouchUpInsideSavesResultWhenValid
{
    SAMainViewController *viewController = [self viewControllerForTesting];
    viewController.results = @[].mutableCopy;
    OCMExpect([self.viewMock isValidToPress]).andReturn(YES);
    OCMExpect([self.viewMock updateForCircleTouched]);
    
    [viewController onCircleButtonTouchUpInside:nil];
    
    XCTAssertEqual(viewController.results.count, 1);
    OCMVerifyAll(self.viewMock);
}

- (void)testOnCircleButtonTouchUpInsideHandlesWhenTrialLimitReached
{
    SAMainViewController *viewController = [self viewControllerForTesting];
    viewController.results = @[@1, @1, @1, @1].mutableCopy;
    OCMExpect([self.viewMock isValidToPress]).andReturn(YES);
    OCMExpect([self.viewMock updateForCircleTouched]);
    OCMExpect([self.viewMock updateForTrailsCompleted:[OCMArg isNotNil]]);
    
    [viewController onCircleButtonTouchUpInside:nil];
    
    XCTAssertEqual(viewController.results.count, 0);
    OCMVerifyAll(self.viewMock);
}

- (void)testHandleLongPressGestureCreatesTimerWhenGestureStateBegan
{
    SAMainViewController *viewController = [self viewControllerForTesting];
    id gestureMock = OCMClassMock([UILongPressGestureRecognizer class]);
    OCMExpect([gestureMock state]).andReturn(UIGestureRecognizerStateBegan);
    
    [viewController handleLongPressGesture:gestureMock];
    
    XCTAssertNotNil(viewController.timer);
}

@end
