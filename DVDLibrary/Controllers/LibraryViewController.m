//
//  LibraryViewController.m
//  DVDLibrary
//
//  Created by Ming on 3/2/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import "LibraryViewController.h"

@interface LibraryViewController ()

@end

@implementation LibraryViewController

- (void)viewDidLoad {
    NSLog(@"library viewdidload");
    [super viewDidLoad];
    // add viewController so you can switch them later.
    UIViewController *vc = [self getViewController:0];
    [self addChildViewController:vc];
    vc.view.frame = self.view.bounds;
    [self.view addSubview:vc.view];
    self.currentViewController = vc;
}


- (void)viewControllerForMovieLayout:(NSInteger)index {
    UIViewController *vc = [self getViewController:index];
    [self addChildViewController:vc];
    [self transitionFromViewController:self.currentViewController toViewController:vc duration:0.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        [self.currentViewController.view removeFromSuperview];
        vc.view.frame = self.view.bounds;
        [self.view addSubview:vc.view];
    } completion:^(BOOL finished) {
        [vc didMoveToParentViewController:self];
        [self.currentViewController removeFromParentViewController];
        self.currentViewController = vc;
    }];
    //self.navigationItem.title = vc.title;
}

- (UIViewController *)getViewController:(NSInteger)index {
    UIViewController *vc;
        switch (index) {
        case 0:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Nav1"];
            break;
        case 1:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MovieCollectionViewController2ID"];
            break;
    }
    return vc;
}

@end
