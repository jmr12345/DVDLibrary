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

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{

    self.foundMovie = [[Movie alloc]init];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    NSString *upc = @"043396399778";
    self.search = [[SearchResult alloc]initWithUpc:upc];
    [self.search searchForMovieByUpc:upc];
    
    self.search2 = [[SearchResult alloc]initWithMovieTitle:@"The Heat"];
    [self.search2 searchForMovieByTitle:@"The Heat"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getMovie
{
    self.foundMovie = self.search.foundMovie;
}

- (BOOL)isReachable
{
    Reachability *currentReachability = [Reachability reachabilityForInternetConnection];
    if(currentReachability.currentReachabilityStatus != NotReachable){
        return true;
    }
    return false;
}


- (IBAction)searchByTitleButton:(id)sender {
    self.foundMovie = self.search.foundMovie;
    Movie *testMovie = [[Movie alloc]init];
    testMovie = self.search2.foundMovie;
}
@end
