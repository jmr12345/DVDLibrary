//
//  MovieTableViewController.h
//  DVDLibrary
//
//  Created by Ming on 2/27/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewController : UITableViewController

@property (strong, nonatomic) NSArray* allTableData;
@property (strong, nonatomic) NSMutableDictionary* filteredTableData;
@property (strong, nonatomic) NSMutableArray* letters;
@property (strong, nonatomic) NSMutableArray* genres;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) bool isFiltered;

- (IBAction)switchToTitles:(id)sender;
- (IBAction)switchToGenres:(id)sender;

@end
