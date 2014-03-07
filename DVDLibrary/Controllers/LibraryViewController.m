//
//  LibraryViewController.m
//  DVDLibrary
//
//  Created by Ming on 3/2/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import "LibraryViewController.h"
#import "MovieTableViewController.h"
#import "MovieCollectionViewController.h"
#import "Movie.h"
#import "MovieData.h"
#import "SplashScreenViewController.h"

@interface LibraryViewController ()
- (void)dismissSplashScreenViewController;
@property (strong,nonatomic) NSString *category;
@end

@implementation LibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Get a reference to the SplashScreenViewController from the StoryBoard
    SplashScreenViewController *svc = [[self storyboard] instantiateViewControllerWithIdentifier:@"SplashScreenViewController"];
    [self presentViewController:svc animated:NO completion:^{
        NSLog(@"SplashScreenViewController did appear");
    }];

    // Call method after set time
    [self performSelector:@selector(dismissSplashScreenViewController) withObject:nil afterDelay:2];

    // Shows tableView categorized by title
    self.category = @"Titles";

    // Get all movie data info and set filtered table data to include everything
    self.allTableData = [[MovieData alloc] init].movieData;
    [self updateTableData:@""];

    // Add movie layout controller
    UIViewController *vc = [self getViewController:@"Table"];
    [self addChildViewController:vc];
    vc.view.frame = self.view.bounds;
    [self.view addSubview:vc.view];
    self.currentViewController = vc;

    // Add search bar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [self.view addSubview:self.searchBar];
    [self.view sendSubviewToBack:self.searchBar];
    self.searchBar.barTintColor = [UIColor darkGrayColor];
    self.searchBar.hidden = YES;
    self.searchBar.delegate = self;

}

- (IBAction)changeSections:(id)sender {
//    [(MovieTableViewController*)self.currentViewController changeSections];
//    if ([self.category isEqual:@"Titles"]) {
//        self.category = @"Genres";
//        [self.categoryButton setTitle:@"By: Genres" forState:UIControlStateNormal];
//    } else if ([self.category isEqual:@"Genres"]) {
//        self.category = @"Titles";
//        [self.categoryButton setTitle:@"By: Titles" forState:UIControlStateNormal];
//    }
}


- (IBAction)changeMovieLayout:(id)sender {
    // Add new viewcontroller and remove other one
    UIViewController *vc = [self switchViewController];
    [self addChildViewController:vc];
    [self.currentViewController.view removeFromSuperview];
    vc.view.frame = self.view.bounds;
    [self.view addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    [self.currentViewController removeFromParentViewController];
    self.currentViewController = vc;
    self.searchBar.hidden = YES;

//    [self transitionFromViewController:self.currentViewController toViewController:vc duration:0.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
//        [self.currentViewController.view removeFromSuperview];
//        vc.view.frame = self.view.bounds;
//        [self.view addSubview:vc.view];
//    } completion:^(BOOL finished) {
//        [vc didMoveToParentViewController:self];
//        [self.currentViewController removeFromParentViewController];
//        self.currentViewController = vc;
//    }];
}



- (UIViewController *)switchViewController{
    UIViewController *vc;
    // Switch from table layout to collection layout
    if ([self.currentViewController class] == [MovieTableViewController class]) {
        vc = [self getViewController:@"Collection"];

        // Update bar button to show list image
        UIImage *image = [UIImage imageNamed:@"list-26.png"];
        [self.movieLayoutButton setImage:image];

    // Switch from collection layout to table layout
    } else if ([self.currentViewController class] == [MovieCollectionViewController class]) {
        vc = [self getViewController:@"Table"];

        // Update bar button to show grid image
        UIImage *image = [UIImage imageNamed:@"grid-26.png"];
        [self.movieLayoutButton setImage:image];
    }
    return vc;
}

- (UIViewController *)getViewController:(NSString *)movieLayout{
    UIViewController *vc;
    // Return controller with table view layout
    if ([movieLayout isEqual:@"Table"]) {
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MovieTableViewControllerID"];
        ((MovieTableViewController *)vc).lvc = self;

    // Return controller with collection view layout
    } else if ([movieLayout isEqual:@"Collection"]) {
        vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MovieCollectionViewControllerID"];
        ((MovieCollectionViewController *)vc).lvc = self;
    }
    return vc;
}

// Update sections and data for search string (empty string shows all data)
-(void)updateTableData:(NSString*)searchString
{
    self.filteredTableData = [[NSMutableDictionary alloc] init];

    for (Movie* movie in self.allTableData)
    {
        bool isMatch = false;
        if(searchString.length == 0)
        {
            // If empty string, show everything
            isMatch = true;
        }
        else
        {
            // Else, check to see if search string matches a movie title
            NSRange titleRange = [movie.title rangeOfString:searchString options:NSCaseInsensitiveSearch];
            if(titleRange.location != NSNotFound)
                isMatch = true;
        }

        // If there is a match
        if(isMatch)
        {
            if ([self.category  isEqual:@"Titles"]) {
                // Find first letter of movie title
                NSString* firstLetter = [movie.title substringToIndex:1];

                // Check to see if an array for the letter already exists
                NSMutableArray* arrayForLetter = (NSMutableArray*)[self.filteredTableData objectForKey:firstLetter];
                if(arrayForLetter == nil)
                {
                    // If none exists, create one, and add it to dictionary
                    arrayForLetter = [[NSMutableArray alloc] init];
                    [self.filteredTableData setValue:arrayForLetter forKey:firstLetter];
                }
                // Add movie to its section array
                [arrayForLetter addObject:movie];

            } else if ([self.category  isEqual:@"Genres"]) {
                // Find the genre of the movie
                NSString* genre = [movie.genre objectAtIndex:0];

                // Check to see if an array for genre already exists
                NSMutableArray* arrayForGenre = (NSMutableArray*)[self.filteredTableData objectForKey:genre];
                if(arrayForGenre == nil)
                {
                    // If none exists, create one, and add it to dictionary
                    arrayForGenre = [[NSMutableArray alloc] init];
                    [self.filteredTableData setValue:arrayForGenre forKey:genre];
                }
                // Add movie to its section array
                [arrayForGenre addObject:movie];
            }
        }
    }
    // Create array of all sections
    self.sections = [[[self.filteredTableData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];

    // Reload data for appropriate view type
    if ([self.currentViewController class] == [MovieTableViewController class]) {
       [((MovieTableViewController *)self.currentViewController).tableView reloadData];
    }
    else if ([self.currentViewController class] == [MovieCollectionViewController class]) {
       [((MovieCollectionViewController *)self.currentViewController).collectionView reloadData];
    }
}

- (IBAction)search:(id)sender {
    if ([self.searchBar isHidden]){
        self.searchBar.hidden = NO;
        [self.view bringSubviewToFront:self.searchBar];
    }
    else {
        self.searchBar.hidden = YES;
        [self.view sendSubviewToBack:self.searchBar];
    }
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchString
{
    [self updateTableData:searchString];

    if([searchString length] == 0) {
        [searchBar performSelector: @selector(resignFirstResponder)
                        withObject: nil
                        afterDelay: 0.1];
    }

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)dismissSplashScreenViewController
{
    // Remove the view controller
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"SplashScreenViewController is dismissed from the HomeViewController");
    }];
}

@end
