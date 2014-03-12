//
//  LibraryViewController.m
//  DVDLibrary
//
//  Created by Ming on 3/2/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//
// LibraryViewController displays one of two view controllers (MovieTableViewController or
// MovieCollectionViewController) to show either a table view or
// collection view of the movie collection.  This controller also contains a searchbar
// and logic to filter the data for searched movies.  There's also a button to switch
// between categorizing the movies by title or by genre.

#import "LibraryViewController.h"
#import "MovieTableViewController.h"
#import "MovieCollectionViewController.h"
#import "Movie.h"
#import "MovieData.h"
#import "SplashScreenViewController.h"
#import "MovieLibraryManager.h"

@interface LibraryViewController ()
- (void)dismissSplashScreenViewController;
@property (strong,nonatomic) NSString *sectionType;
@end

@implementation LibraryViewController

/*******************************************************************************
 * @method      viewDidLoad
 * @abstract
 * @description Displays and dismisses splash screen, sets up to display
                to show movies in a table view categorized by titles, and
                adds search bar.
 ******************************************************************************/
- (void)viewDidLoad {
    [super viewDidLoad];

    // Get a reference to the SplashScreenViewController from the StoryBoard
    SplashScreenViewController *svc = [[self storyboard] instantiateViewControllerWithIdentifier:@"SplashScreenViewController"];
    [self presentViewController:svc animated:NO completion:^{
        NSLog(@">>>>> SplashScreenViewController did appear");
    }];

    // Call method after set time
    [self performSelector:@selector(dismissSplashScreenViewController) withObject:nil afterDelay:2];

    // Show movies categorized by title
    self.sectionType = @"Titles";
    [self setUpSections];

    // Get all movie data info and set filtered table data to include everything
    //read data from plist
    MovieLibraryManager *plistManager = [MovieLibraryManager sharedInstance];
    self.allMovieData = [plistManager getMovieLibrary];
    
    //self.allMovieData = [[MovieData alloc] init].movieData;
    [self updateDisplayedMovieData:@""];

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
    
    // Listen for notification that library has been written to pList (updated)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"Library written to pList"
                                               object:nil];
}

/*******************************************************************************
 * @method      changeSections:
 * @abstract    Tap button to change categorization
 * @description Changes categorization of movies between titles and genres.
 ******************************************************************************/
- (IBAction)changeSections:(id)sender {
    NSLog(@">>>>> changeSections button tapped");
    
    if ([self.sectionType isEqual:@"Titles"]){
        self.sectionType = @"Genres";
        [self.categoryButton setTitle:@"By: Genres" forState:UIControlStateNormal];
        [self setUpSections];
    } else if ([self.sectionType isEqual:@"Genres"]) {
        self.sectionType = @"Titles";
        [self.categoryButton setTitle:@"By: Titles" forState:UIControlStateNormal];
        [self setUpSections];
    }
    [self updateDisplayedMovieData:@""];
}

/*******************************************************************************
 * @method      changeMovieLayout:
 * @abstract    Tap button to change layout
 * @description Switches between adding movieTableViewController and
                movieCollectionViewController to display movies in different
                layouts.  Removes previous view controller.
 ******************************************************************************/
- (IBAction)changeMovieLayout:(id)sender {
    NSLog(@">>>>> changeMovieLayout button tapped");
    
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

/*******************************************************************************
 * @method      switchViewController
 * @abstract
 * @description Returns the view controller that contains the new layout and
                updates the view button to the image that represents the new
                view controller
 ******************************************************************************/
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

/*******************************************************************************
 * @method      getViewController:
 * @abstract
 * @description Returns view controller associated with given movieLayout
                and sets LibraryViewController property in new view controller
 ******************************************************************************/
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

/*******************************************************************************
 * @method      updateDisplayedMovieData:
 * @abstract
 * @description Filters movie data for search string and organizes the results
                by either title or genre.  If empty search string, returns all
                movies.
 ******************************************************************************/
-(void)updateDisplayedMovieData:(NSString*)searchString
{
    self.filteredMovieData = [[NSMutableDictionary alloc] init];
    
    // All movies sorted
    NSMutableArray *filteredMovieArray = [[self.allMovieData sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    
    // Filter results by the search string if it's not empty
    if (![searchString isEqualToString:@""]){
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF.title CONTAINS[c] %@ OR SELF.genre contains[c] %@", searchString, searchString];
        [filteredMovieArray filterUsingPredicate:searchPredicate];
    }
    
    // Categorize by title
    if ([self.sectionType isEqual:@"Titles"]){
        for (NSString *section in self.sections) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title beginsWith[c] %@", section];
            [self.filteredMovieData setValue:[filteredMovieArray filteredArrayUsingPredicate:predicate] forKey:section];
        }
        
        NSPredicate *numPredicate = [NSPredicate predicateWithFormat:@"SELF.title MATCHES '^[0-9].*'"];
        [self.filteredMovieData setValue:[filteredMovieArray filteredArrayUsingPredicate:numPredicate] forKey:@"#"];
    }

    // Categorize by genre
    else if ([self.sectionType isEqual:@"Genres"]){
        for (NSString *section in self.sections) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.genre CONTAINS[c] %@", section];
            [self.filteredMovieData setValue:[filteredMovieArray filteredArrayUsingPredicate:predicate] forKey:section];
        }
    }
    
    [self reloadMovieData];
}

/*******************************************************************************
 * @method      search:
 * @abstract    Tap search icon to switch between hiding/showing search bar
 * @description 
 ******************************************************************************/
- (IBAction)search:(id)sender {
    NSLog(@">>>>> Search button tapped");
    
    if ([self.searchBar isHidden]){
        self.searchBar.hidden = NO;
        [self.view bringSubviewToFront:self.searchBar];
    }
    else {
        self.searchBar.hidden = YES;
        [self.view sendSubviewToBack:self.searchBar];
    }
}

/*******************************************************************************
 * @method      searchBar: textDidChange:
 * @abstract    Updates displayed data for given search string
 * @description
 ******************************************************************************/
-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchString
{
    [self updateDisplayedMovieData:searchString];
    
    // Logic below found on stackoverflow to close keyboard when x button tapped
    if([searchString length] == 0) {
        [searchBar performSelector: @selector(resignFirstResponder)
                        withObject: nil
                        afterDelay: 0.1];
    }
}

/*******************************************************************************
 * @method      searchBarButtonClicked:
 * @abstract
 * @description Resigns first responder and closes keyboard when user
                completes a search.
 ******************************************************************************/
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@">>>>> Search bar search button clicked");
    [searchBar resignFirstResponder];
}

/*******************************************************************************
 * @method      setUpSections
 * @abstract
 * @description Sets up categories for either titles or genres.
 ******************************************************************************/
- (void)setUpSections{
   if ([self.sectionType isEqual:@"Titles"]){
       self.sections = [NSMutableArray arrayWithObjects:@"#",@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
   }  else if ([self.sectionType isEqual:@"Genres"]) {
       self.sections = [NSMutableArray arrayWithObjects:@"Action",@"Adventure",@"Animation",@"Comedy",@"Crime",@"Disaster",@"Documentary",@"Drama",@"Eastern",@"Erotic",@"Family",@"Fan Film",@"Fantasy",@"Film Noir",@"History",@"Holiday",@"Horror",@"Indie",@"Music",@"Musical",@"Mystery",@"Neo-noir",@"Road Movie",@"Romance",@"Science Fiction",@"Short",nil];
   }
}

/*******************************************************************************
 * @method      reloadMovieData:
 * @abstract
 * @description Reloads data for either table view or collection view based
                on type of current view controller.
 ******************************************************************************/
- (void) reloadMovieData {
    // Reload data for appropriate view type
    if ([self.currentViewController class] == [MovieTableViewController class]) {
        [((MovieTableViewController *)self.currentViewController).tableView reloadData];
    }
    else if ([self.currentViewController class] == [MovieCollectionViewController class]) {
        [((MovieCollectionViewController *)self.currentViewController).collectionView reloadData];
    }
}

/*******************************************************************************
 * @method      dismissSplashScreenViewController:
 * @abstract    Dismisses splash screen
 * @description
 ******************************************************************************/
- (void)dismissSplashScreenViewController
{
    // Remove the view controller
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@">>>>> SplashScreenViewController is dismissed from the LibraryViewController");
    }];
}

/*******************************************************************************
 * @method      receivedNotification:
 * @abstract    Refreshes movie data when notification received that pList updated
 * @description
 ******************************************************************************/
- (void)receivedNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"Library written to pList"]) {
        NSLog(@">>>>> pList notification received by LibraryViewController");
        
        [self refreshMovieData];
    }
}

/*******************************************************************************
 * @method      refreshMovieData:
 * @abstract    Refreshes data with current pList
 * @description
 ******************************************************************************/
- (void) refreshMovieData{
    MovieLibraryManager *plistManager = [MovieLibraryManager sharedInstance];
    self.allMovieData = [plistManager getMovieLibrary];
    
    [self updateDisplayedMovieData:(@"")];
}

@end
