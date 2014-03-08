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

@interface SearchViewController : UIViewController


@property (strong, nonatomic) Movie *foundMovie;

@property (strong, nonatomic) NSString *roviApiKey;
@property (strong, nonatomic) NSString *sig;

@property (strong, nonatomic) NSString *movieDbApiKey;

@property (strong, nonatomic) Reachability *reachability;

@end
