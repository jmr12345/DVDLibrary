//
//  SearchViewController.h
//  DVDLibrary
//
//  Created by Amy Chiu on 3/4/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "SearchResult.h"

@interface SearchViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSString *titleSearch;

@property (strong, nonatomic) SearchResult *search;
@property (strong, nonatomic) Reachability *reachability;

//for the title search
@property (weak, nonatomic) IBOutlet UITextField *titleSearchTextField;
- (IBAction)searchByTitleButton:(id)sender;

@end
