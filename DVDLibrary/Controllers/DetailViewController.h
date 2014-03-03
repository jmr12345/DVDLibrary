//
//  DetailViewController.h
//  DVDLibrary
//
//  Created by Ming on 2/28/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface DetailViewController : UIViewController

@property (strong,nonatomic) Movie *movie;

@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
