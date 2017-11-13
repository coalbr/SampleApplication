//
//  SAMainViewController.m
//  SampleApplication
//
//  Created by Austin Albrecht on 11/13/17.
//  Copyright © 2017 Austin Albrecht. All rights reserved.
//

#import "SAMainViewController.h"
#import "SAMainView.h"

@interface SAMainViewController ()

@property (nonatomic, weak) SAMainView *view;

@end

@implementation SAMainViewController

#pragma mark - Property methods
@dynamic view;

#pragma mark - UIViewController methods
- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
