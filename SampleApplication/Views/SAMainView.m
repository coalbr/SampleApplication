//
//  SAMainView.m
//  SampleApplication
//
//  Created by Austin Albrecht on 11/13/17.
//  Copyright © 2017 Austin Albrecht. All rights reserved.
//

#import "SAMainView.h"
#import "UIColor+CustomColors.h"

@interface SAMainView()

@property (nonatomic, readwrite) BOOL isValidToPress;

@property (nonatomic, weak) IBOutlet UIButton *beginTrialButton;
@property (nonatomic, weak) IBOutlet UIButton *circleButton;
@property (nonatomic, weak) IBOutlet UILabel *outputLabel;

@end

@implementation SAMainView

#pragma mark - Public methops
- (void)addLongPressGestureToTarget:(id)target action:(SEL)action
{
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:action];
    [self.beginTrialButton addGestureRecognizer:gesture];
}

- (void)updateForCircleTouched
{
    [self.circleButton setBackgroundColor:[UIColor mediumBlueColor]];
    self.outputLabel.text = @"Please repeat the trial";
    self.isValidToPress = NO;
}

- (void)updateForTrialStarted
{
    [self.circleButton setBackgroundColor:[UIColor mediumGreenColor]];
    self.outputLabel.text = @"Tap the green circle";
    self.isValidToPress = YES;
}

- (void)updateForTrailsCompleted:(NSString *)resultsText
{
    self.outputLabel.text = resultsText;
}

@end
