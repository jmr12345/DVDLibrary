//
//  LibraryViewController.h
//  DVDLibrary
//
//  Created by Ming on 3/2/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibraryViewController : UIViewController

@property (strong, nonatomic) UIViewController *currentViewController;
- (void)viewControllerForMovieLayout:(NSInteger)index;

@end
