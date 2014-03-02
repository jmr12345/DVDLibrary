//
//  LibraryViewController.h
//  DVDLibrary
//
//  Created by Ming on 3/2/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibraryViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;
@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) UIViewController *currentViewController;

@end
