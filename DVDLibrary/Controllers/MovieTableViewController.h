//
//  MovieTableViewController.h
//  DVDLibrary
//
//  Created by Ming on 3/1/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LibraryViewController.h"

@interface MovieTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) LibraryViewController *lvc;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
