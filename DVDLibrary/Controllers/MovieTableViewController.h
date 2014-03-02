//
//  MovieTableViewController2.h
//  DVDLibrary
//
//  Created by Ming on 3/1/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray* allTableData;
@property (strong, nonatomic) NSMutableDictionary* filteredTableData;
@property (strong, nonatomic) NSMutableArray* sections;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) bool isFiltered;

- (IBAction)switchToTitles:(id)sender;
- (IBAction)switchToGenres:(id)sender;
@end
