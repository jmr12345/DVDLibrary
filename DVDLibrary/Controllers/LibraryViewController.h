//
//  LibraryViewController.h
//  DVDLibrary
//
//  Created by Ming on 3/2/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibraryViewController : UIViewController <UISearchBarDelegate>

@property (strong, nonatomic) NSArray* allTableData;
@property (strong, nonatomic) NSMutableDictionary* groupedTableData;
@property (strong, nonatomic) NSMutableDictionary* filteredTableData;
@property (strong, nonatomic) NSMutableArray* sections;

@property (strong, nonatomic) UIViewController *currentViewController;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *movieLayoutButton;
@property (strong, nonatomic) UISearchBar *searchBar;

- (IBAction)changeSections:(id)sender;
- (IBAction)changeMovieLayout:(id)sender;
- (IBAction)search:(id)sender;

@end
