//
//  LibraryViewController.m
//  DVDLibrary
//
//  Created by Ming on 3/2/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import "LibraryViewController.h"
#import "MovieTableViewController.h"

@interface LibraryViewController ()

@property (strong,nonatomic) NSString *movieLayout;
@property (strong,nonatomic) NSString *category;

@end

@implementation LibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Shows tableView categorized by title
    self.movieLayout = @"Table";
    self.category = @"Titles";
    
    UIViewController *vc = [self getViewController];
    [self addChildViewController:vc];
    vc.view.frame = self.view.bounds;
    [self.view addSubview:vc.view];
    self.currentViewController = vc;
}

- (IBAction)changeSections:(id)sender {
    [(MovieTableViewController*)self.currentViewController changeSections];
    if ([self.category isEqual:@"Titles"]) {
        self.category = @"Genres";
        [self.categoryButton setTitle:@"By: Genres" forState:UIControlStateNormal];
    } else if ([self.category isEqual:@"Genres"]) {
        self.category = @"Titles";
        [self.categoryButton setTitle:@"By: Titles" forState:UIControlStateNormal];
    }
}

- (IBAction)changeMovieLayout:(id)sender {
    UIViewController *vc = [self switchViewController];
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
}

- (UIViewController *)switchViewController{
    UIViewController *vc;
    if ([self.movieLayout isEqual:@"Collection"]) {
        self.movieLayout = @"Table";
        vc = [self getViewController];
    } else if ([self.movieLayout isEqual:@"Table"]) {
        self.movieLayout = @"Collection";
        vc = [self getViewController];
    }
    return vc;
}

- (UIViewController *)getViewController{
    UIViewController *vc;
    if ([self.movieLayout isEqual:@"Table"]) {
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MovieTableViewControllerID"];
    } else if ([self.movieLayout isEqual:@"Collection"]) {
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MovieCollectionViewControllerID"];
    }
    return vc;
}


@end
