//
//  SearchViewController.h
//  DVDLibrary
//
//  Created by Amy Chiu on 3/4/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "Reachability.h"
#import "SearchResult.h"

@interface SearchViewController : UIViewController

@property (strong, nonatomic) SearchResult *search;
@property (strong, nonatomic) SearchResult *search2;
@property (strong, nonatomic) Movie *foundMovie;
@property (strong, nonatomic) Reachability *reachability;

@property (weak, nonatomic) IBOutlet UITextField *inputMovieTItle;
- (IBAction)searchByTitleButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *cameraView;


@end
