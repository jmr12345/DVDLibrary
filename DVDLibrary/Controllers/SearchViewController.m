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
#import "ProcessingView.h"

@interface SearchViewController ()

@property (strong, nonatomic) NSBlockOperation *blockOperation;
@property (strong, nonatomic) ProcessingView *processingView;

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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"Search done"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"Entered background"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"Interrupted"
                                               object:nil];
    
    self.titleSearchTextField.clearButtonMode = YES;
    
    self.processingView = [[ProcessingView alloc] initWithFrame:CGRectMake(110, 264, 100, 100)withMessage:@"Searching"];
    [self.view addSubview:self.processingView];
    self.processingView.hidden = YES;
}

- (void) viewDidAppear:(BOOL)animated
{
    self.processingView.hidden = YES;
}

#pragma mark - Reachability
/********************************************************************************************
 * @method isReachable
 * @abstract checks to see if have wifi or 3G/LTE connection
 * @description Uses the Reachability classes
 ********************************************************************************************/
- (BOOL)isReachable
{
    Reachability *currentReachability = [Reachability reachabilityForInternetConnection];
    if(currentReachability.currentReachabilityStatus != NotReachable){
        NSLog(@">>>>>Connected to the internet!");
        return true;
    }
    NSLog(@">>>>>Not connected to the internet!");
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
    NSLog(@">>>>>Showing no internet connection error");
}

#pragma mark - Search by Title
/********************************************************************************************
 * @method searchByTitleButton:
 * @abstract finds movie by title input by user
 * @description
 ********************************************************************************************/
- (IBAction)searchByTitleButton:(id)sender
{
    [self.titleSearchTextField resignFirstResponder];
    [self searchByTitle];
}

/********************************************************************************************
 * @method searchByTitle
 * @abstract checks for internet connectivity, and if established, then kicks off search
 * @description checks internet connectivity, if none, show alert. If have internet, then
            start search and show spinner
 ********************************************************************************************/
- (void) searchByTitle
{
    if ([self isReachable]) {
        //shows spinner
        self.processingView.hidden = NO;
        
        //kicks off search
        self.titleSearch = self.titleSearchTextField.text;
        NSString *searchString = [self.titleSearch capitalizedString];
        NSLog(@"Searching for movie titled: %@", searchString);
        self.search = [[SearchResult alloc]initWithMovieTitle:searchString];
        [self.search titleSearch:searchString];
    }
    //if no internet connection, show alert
    else{
        [self noInternetError];
        return;
    }
}

/********************************************************************************************
 * @method receivedNotification:
 * @abstract checks if received notification that process is finished
 * @description if process is finished, then clear search text field and hide the spinner
 ********************************************************************************************/
- (void)receivedNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"Search done"] || [[notification name] isEqualToString:@"Entered background"] || [[notification name] isEqualToString:@"Interrupted"]) {
        NSLog(@">>>>> Search done notification received by SearchViewController");
        self.titleSearchTextField.text = @"";
        self.processingView.hidden = YES;
    }
}

#pragma mark - search title keyboard
/********************************************************************************************
 * @method textFieldShouldReturn:
 * @abstract gives functionality to the search button on the keyboard popup
 * @description hides keyboard and kicks of search by movie title
 ********************************************************************************************/
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self searchByTitle];
    return YES;
}

/********************************************************************************************
 * @method textFieldShouldClear:
 * @abstract hides the keyboard when the x is clicked in the text field
 * @description 
 ********************************************************************************************/
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self.titleSearchTextField performSelector: @selector(resignFirstResponder)
                        withObject: nil
                        afterDelay: 0.1];
    return YES;
}

@end
