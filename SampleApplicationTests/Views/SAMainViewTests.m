//
//  SAMainViewTests.m
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

@interface SAMainView(UnitTesting)

@property (nonatomic, weak) IBOutlet UIButton *beginTrialButton;
@property (nonatomic, weak) IBOutlet UIButton *circleButton;
@property (nonatomic, weak) IBOutlet UILabel *outputLabel;

@end

@interface SAMainViewTests : XCTestCase

@property (nonatomic) id beginTrialButtonMock;
@property (nonatomic) id circleButtonMock;
@property (nonatomic) id outputLabelMock;
@property (nonatomic) id viewControllerMock;

@end

@implementation SAMainViewTests

#pragma mark - Helper methods
- (void)setUp
{
    [super setUp];
    self.beginTrialButtonMock = OCMClassMock([UIButton class]);
    self.circleButtonMock = OCMClassMock([UIButton class]);
    self.outputLabelMock = OCMClassMock([UILabel class]);
    self.viewControllerMock = OCMClassMock([SAMainViewController class]);
}

- (SAMainView *)viewForTesting
{
    SAMainView *view = [SAMainView new];
    view.beginTrialButton = self.beginTrialButtonMock;
    view.circleButton = self.circleButtonMock;
    view.outputLabel = self.outputLabelMock;
    
    return view;
}

#pragma mark - Test methods
- (void)testAddLongPressGestureToTargetAddsGestureCorrectly
{
    SAMainView *view = [self viewForTesting];
    OCMExpect([self.beginTrialButtonMock addGestureRecognizer:[OCMArg isNotNil]]);
    
    [view addLongPressGestureToTarget:self.viewControllerMock action:@selector(endEditing)];
    
    OCMVerifyAll(self.beginTrialButtonMock);
}

- (void)testUpdateForCircleTouchedUpdatesViewCorrectly
{
    SAMainView *view = [self viewForTesting];
    OCMExpect([self.circleButtonMock setBackgroundColor:[OCMArg isEqual:[UIColor mediumBlueColor]]]);
    OCMExpect([self.outputLabelMock setText:[OCMArg isEqual:@"Please repeat the trial"]]);
    
    [view updateForCircleTouched];
    
    OCMVerifyAll(self.circleButtonMock);
    OCMVerifyAll(self.outputLabelMock);
    XCTAssertFalse(view.isValidToPress);
}

- (void)testUpdateForTrailStartedUpdatesViewCorrectly
{
    SAMainView *view = [self viewForTesting];
    OCMExpect([self.circleButtonMock setBackgroundColor:[OCMArg isEqual:[UIColor mediumGreenColor]]]);
    OCMExpect([self.outputLabelMock setText:[OCMArg isEqual:@"Tap the green circle"]]);
    
    [view updateForTrialStarted];
    
    OCMVerifyAll(self.circleButtonMock);
    OCMVerifyAll(self.outputLabelMock);
    XCTAssertTrue(view.isValidToPress);
}

- (void)testUpdateForTrailsCompletedUpdatesViewCorrectly
{
    NSString *resultText = @"Some result text.";
    SAMainView *view = [self viewForTesting];
    OCMExpect([self.outputLabelMock setText:[OCMArg isEqual:resultText]]);
    
    [view updateForTrailsCompleted:resultText];
    
    OCMVerifyAll(self.outputLabelMock);
}

@end
