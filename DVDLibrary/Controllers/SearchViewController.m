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
                                                 name:@"Library written to pList"
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
 * @abstract Action activated when user clicks on search button. Then finds movie by 
            title input by user
 * @description
 ********************************************************************************************/
- (IBAction)searchByTitleButton:(id)sender
{
    [self searchByTitle];
}

/********************************************************************************************
 * @method searchByTitle
 * @abstract Starts search for title entered
 * @description First checks if there's an internet connection. If not, give an alert, 
        otherwise kick off the search
 ********************************************************************************************/
- (void) searchByTitle
{
    if ([self isReachable]) {
        
        [self.view bringSubviewToFront:self.activityIndicator];
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];

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

/********************************************************************************************
 * @method receivedNotification
 * @abstract
 * @description
 ********************************************************************************************/
- (void)receivedNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"Library written to pList"]) {
        [self movieAddCompleted];
    }
}

/********************************************************************************************
 * @method movieAddCompleted
 * @abstract
 * @description
 ********************************************************************************************/
- (void)movieAddCompleted
{
    NSLog(@">>>>> pList notification received by SearchViewController");
    
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
}

/********************************************************************************************
 * @method textFieldShouldReturn
 * @abstract
 * @description
 ********************************************************************************************/
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self searchByTitle];
    return YES;
}



@end
