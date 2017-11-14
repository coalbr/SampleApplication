//
//  SAMainViewController.m
//  SampleApplication
//
//  Created by Austin Albrecht on 11/13/17.
//  Copyright © 2017 Austin Albrecht. All rights reserved.
//

#import "SAMainViewController.h"
#import "SAMainView.h"

static NSInteger const kMaximumValue = 7;
static NSInteger const kMinimumValue = 3;
static NSInteger const kNumberOfTrials = 5;

@interface SAMainViewController ()

@property (nonatomic) NSMutableArray<NSNumber *> *results;
@property (nonatomic) CFTimeInterval startTime;
@property (nonatomic) NSTimer *timer;
@property (nonatomic, weak) SAMainView *view;

@end

@implementation SAMainViewController

#pragma mark - Property methods
@dynamic view;

#pragma mark - UIViewController methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.results = [NSMutableArray arrayWithCapacity:kNumberOfTrials + 1];
    [self.view addLongPressGestureToTarget:self action:@selector(handleLongPressGesture:)];
}

#pragma mark - IBAction methods
- (IBAction)onCircleButtonTouchUpInside:(UIButton *)sender
{
    if (self.view.isValidToPress)
    {
        NSNumber *result = @(CACurrentMediaTime() - self.startTime);
        [self.results addObject:result];
        
        [self.view updateForCircleTouched];
        
        if (self.results.count == kNumberOfTrials)
        {
            [self.view updateForTrailsCompleted:[self generateResultsText]];
            [self.results removeAllObjects];
        }
    }
}

#pragma mark - UILongPressGestureRecognizer methods
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        NSInteger interval = [self randomNumberBetween:kMinimumValue and:kMaximumValue];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(onBeginTrialTimerCompleted) userInfo:nil repeats:NO];
    }
}

#pragma mark - Private methods
- (NSArray<NSString *> *)buildKeysArray
{
    NSMutableArray<NSString *> *keys = [NSMutableArray new];
    for (int i = 1; i < kNumberOfTrials + 1; i++)
    {
        [keys addObject:[NSString stringWithFormat:@"Trial %d Interval", i]];
    }
    
    [keys addObject:@"Average Interval"];
    
    return keys.copy;
}

- (NSNumber *)calculateAverage
{
    NSNumber *sum = [self.results valueForKeyPath:@"@sum.self"];
    return @(sum.floatValue / kNumberOfTrials);
}

- (NSString *)generateResultsText
{
    NSArray *keys = [self buildKeysArray];
    [self.results addObject:[self calculateAverage]];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:self.results forKeys:keys];
    NSData *json = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    return [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
}

- (void)onBeginTrialTimerCompleted
{
    self.timer = nil;
    [self.view updateForTrialStarted];
    self.startTime = CACurrentMediaTime();
}

- (NSInteger)randomNumberBetween:(NSInteger)minimum and:(NSInteger)maximum
{
    return arc4random_uniform((uint32_t)(maximum - minimum + 1)) + minimum;
}

@end
