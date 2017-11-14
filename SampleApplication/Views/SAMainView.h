//
//  SAMainView.h
//  SampleApplication
//
//  Created by Austin Albrecht on 11/13/17.
//  Copyright © 2017 Austin Albrecht. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAMainView : UIView

@property (nonatomic, readonly) BOOL isValidToPress;

- (void)addLongPressGestureToTarget:(nullable id)target action:(nullable SEL)action;
- (void)updateForCircleTouched;
- (void)updateForTrialStarted;
- (void)updateForTrailsCompleted:(nonnull NSString *)resultsText;

@end
