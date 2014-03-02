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
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *movieLayoutButton;

- (IBAction)changeSections:(id)sender;
- (IBAction)changeMovieLayout:(id)sender;
- (IBAction)search:(id)sender;

@end
