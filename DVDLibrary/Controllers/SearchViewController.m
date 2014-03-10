//
//  SearchViewController.m
//  DVDLibrary
//
//  Created by Amy Chiu on 3/2/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import "SearchViewController.h"
#import "Movie.h"
#import "Reachability.h"
#import "SearchResult.h"
#import "MovieLibraryManager.h"
#import "LibraryViewController.h"

@interface SearchViewController ()

@property (strong, nonatomic) NSBlockOperation *blockOperation;

@end

@implementation SearchViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"Movie Added"
                                               object:nil];
}

/********************************************************************************************
 * @method isReachable
 * @abstract checks to see if have wifi or 3G/LTE connection
 * @description Uses the Reachability classes
 ********************************************************************************************/
- (BOOL)isReachable
{
    Reachability *currentReachability = [Reachability reachabilityForInternetConnection];
    if(currentReachability.currentReachabilityStatus != NotReachable){
        NSLog(@"Connected to the internet!");
        return true;
    }
    NSLog(@"Not connected to the internet!");
    return false;
}

/********************************************************************************************
 * @method noInternetError
 * @abstract gives alert view error when not connected to internet to search
 * @description
 ********************************************************************************************/
- (void)noInternetError
{
    NSString *title = @"Sorry! Must be connected to the internet to search!";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    NSLog(@"Showing no internet connection error");
}

/********************************************************************************************
 * @method searchByTitleButton
 * @abstract finds movie by title input by user
 * @description
 ********************************************************************************************/
- (IBAction)searchByTitleButton:(id)sender {
    if ([self isReachable]) {
        self.titleSearch = self.inputMovieTItle.text;
        NSString *searchString = [self.titleSearch capitalizedString];
        NSLog(@"Searching for movie titled: %@", searchString);
        self.search = [[SearchResult alloc]initWithMovieTitle:searchString];
        [self.search titleSearch:searchString];
    }
    else{
        [self noInternetError];
        return;
    }
}

- (void)receivedNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"Movie Added"]) {
        [self movieAddCompleted];
//    } else if ([[notification name] isEqualToString:@"Not Found"]) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Results Found"
//                                                            message:nil delegate:self
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil, nil];
//        [alertView show];
   }
}

- (void)movieAddCompleted
{
    NSLog(@"Notification received");
    
    // Get the searchViewController
    LibraryViewController *lvc = (LibraryViewController *)[[self.tabBarController.viewControllers objectAtIndex:0] topViewController];
    
    MovieLibraryManager *plistManager = [MovieLibraryManager sharedInstance];
    lvc.allMovieData = [plistManager getMovieLibrary];
    
    [lvc updateDisplayedMovieData:(@"")];
    
    // Switch to search tab
    [self.tabBarController setSelectedIndex:0];}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}



@end
