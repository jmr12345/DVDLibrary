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
#import "LoadingView.h"

@interface SearchViewController ()

@property (strong, nonatomic) NSBlockOperation *blockOperation;
@property (strong, nonatomic) LoadingView *loadingView;

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
    self.titleSearchTextField.clearButtonMode = YES;
    
    self.loadingView = [[LoadingView alloc] initWithMessage:@"Searching"];
    [self.view addSubview:self.loadingView];
    self.loadingView.hidden = YES;
}

- (void) viewDidAppear:(BOOL)animated
{
    self.loadingView.hidden = YES;
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
    [self.titleSearchTextField resignFirstResponder];
    [self searchByTitle];
}

- (void) searchByTitle{
    if ([self isReachable]) {
        
        self.loadingView.hidden = NO;

        self.titleSearch = self.titleSearchTextField.text;
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
    if ([[notification name] isEqualToString:@"Search done"]) {
        NSLog(@">>>>> Search done notification received by SearchViewController");
        
        self.loadingView.hidden = YES;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self searchByTitle];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self.titleSearchTextField performSelector: @selector(resignFirstResponder)
                        withObject: nil
                        afterDelay: 0.1];
    return YES;
}

@end
