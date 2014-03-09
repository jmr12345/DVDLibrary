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

@interface SearchViewController ()

@property (strong, nonatomic) NSBlockOperation *blockOperation;

@end

@implementation SearchViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [self.tabBarController setSelectedIndex:0];
    }
    else{
        [self noInternetError];
        return;
    }
}

@end
