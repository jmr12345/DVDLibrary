//
//  DetailViewController.h
//  DVDLibrary
//
//  Created by Ming on 2/28/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "Reachability.h"

@interface DetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate>

@property (strong, nonatomic) Reachability *reachability;

@property (strong,nonatomic) Movie *movie;
@property (strong,nonatomic) NSMutableArray *allMovieData;
@property (strong, nonatomic) NSMutableArray* sections;
@property (strong, nonatomic) NSMutableDictionary* sectionedData;

@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *trailerButton;
- (IBAction)watchTrailer:(id)sender;
- (IBAction)deleteMovie:(UIBarButtonItem *)sender;

@end
