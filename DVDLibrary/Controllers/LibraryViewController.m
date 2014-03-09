//
//  LibraryViewController.m
//  DVDLibrary
//
//  Created by Ming on 3/2/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//
// LibraryViewController displays one of two view controllers (MovieTableViewController or
// MovieCollectionViewController) to display either a table view or
// collection view of the movie collection.  This controller also contains a searchbar
// and logic to filter the data for searched movies.

#import "LibraryViewController.h"
#import "MovieTableViewController.h"
#import "MovieCollectionViewController.h"
#import "Movie.h"
#import "MovieData.h"
#import "SplashScreenViewController.h"

@interface LibraryViewController ()
- (void)dismissSplashScreenViewController;
@property (strong,nonatomic) NSString *sectionType;
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
    self.sectionType = @"Titles";
    [self setUpSections];

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
    if ([self.sectionType isEqual:@"Titles"]){
        self.sectionType = @"Genres";
        [self.categoryButton setTitle:@"By: Genres" forState:UIControlStateNormal];
        [self setUpSections];
    } else if ([self.sectionType isEqual:@"Genres"]) {
        self.sectionType = @"Titles";
        [self.categoryButton setTitle:@"By: Titles" forState:UIControlStateNormal];
        [self setUpSections];
    }
    [self updateTableData:@""];
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
    
    // All movies sorted
    NSMutableArray *filteredMovieArray = [[self.allTableData sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    
    if (![searchString isEqualToString:@""]){
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF.title CONTAINS[c] %@ OR SELF.genre contains[c] %@", searchString, searchString];
        [filteredMovieArray filterUsingPredicate:searchPredicate];
    }
    
    if ([self.sectionType isEqual:@"Titles"]){
        for (NSString *section in self.sections) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title beginsWith[c] %@", section];
            [self.filteredTableData setValue:[filteredMovieArray filteredArrayUsingPredicate:predicate] forKey:section];
        }
        
        NSPredicate *numPredicate = [NSPredicate predicateWithFormat:@"SELF.title MATCHES '^[0-9].*'"];
        [self.filteredTableData setValue:[filteredMovieArray filteredArrayUsingPredicate:numPredicate] forKey:@"#"];
    }

    else if ([self.sectionType isEqual:@"Genres"]){
        for (NSString *section in self.sections) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.genre CONTAINS[c] %@", section];
            [self.filteredTableData setValue:[filteredMovieArray filteredArrayUsingPredicate:predicate] forKey:section];
        }
    }
    

    [self reloadMovieData];
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
        NSLog(@"SplashScreenViewController is dismissed from the LibraryViewController");
    }];
}

- (void)setUpSections{
   if ([self.sectionType isEqual:@"Titles"]){
       self.sections = [NSMutableArray arrayWithObjects:@"#",@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
   }  else if ([self.sectionType isEqual:@"Genres"]) {
       self.sections = [NSMutableArray arrayWithObjects:@"Action",@"Adventure",@"Animation",@"Comedy",@"Crime",@"Disaster",@"Documentary",@"Drama",@"Eastern",@"Erotic",@"Family",@"Fan Film",@"Fantasy",@"Film Noir",@"History",@"Holiday",@"Horror",@"Indie",@"Music",@"Musical",@"Mystery",@"Neo-noir",@"Road Movie",@"Romance",@"Science Fiction",@"Short",nil];
   }
}

- (void) reloadMovieData {
    // Reload data for appropriate view type
    if ([self.currentViewController class] == [MovieTableViewController class]) {
        [((MovieTableViewController *)self.currentViewController).tableView reloadData];
    }
    else if ([self.currentViewController class] == [MovieCollectionViewController class]) {
        [((MovieCollectionViewController *)self.currentViewController).collectionView reloadData];
    }
}

@end
