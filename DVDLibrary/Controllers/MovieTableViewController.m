//
//  MovieTableViewController.m
//  DVDLibrary
//
//  Created by Ming on 3/1/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import "MovieTableViewController.h"
#import "MovieTableViewCell.h"
#import "Movie.h"
#import "MovieData.h"
#import "DetailViewController.h"

@interface MovieTableViewController ()

@property NSString *viewType;

@end

@implementation MovieTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.viewType = @"Titles";
    
    self.allTableData = [[MovieData alloc] init].movieData;
    
    self.tableView.sectionFooterHeight = 0.0;
    self.tableView.sectionHeaderHeight = 28.0;
    
    // Update sections and data for search string (empty string shows all data)
    [self updateTableData:@""];

}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* key = [self.sections objectAtIndex:section];
    return key;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* category = [self.sections objectAtIndex:section];
    NSArray* arrayForSection = (NSArray*)[self.filteredTableData objectForKey:category];
    return [arrayForSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MovieTableViewCellID";
    MovieTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Get movie at current position
    Movie *movie = [[Movie alloc] init];
    NSString* category = [self.sections objectAtIndex:indexPath.section];
    NSArray* arrayForSection = (NSArray*)[self.filteredTableData objectForKey:category];
    movie = (Movie *)[arrayForSection objectAtIndex:indexPath.row];
    
    // Configure cell appearance
    cell.label.text = movie.title;
    [cell.movieImageView setImage:movie.image];
    return cell;
}

// Update sections and data for search string (empty String shows all data)
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
            if ([self.viewType  isEqual:@"Titles"]) {
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
                
            } else if ([self.viewType  isEqual:@"Genres"]) {
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
    
    // Reload table
    [self.tableView reloadData];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 28)];
    
    // Setup label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 28)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    NSString *string = [self.sections objectAtIndex:section];
    [label setText:string];
    [view addSubview:label];
    
    [view setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.7f]];

    return view;
}

#pragma mark - Table view delegate

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    [self updateTableData:text];
    
    if([text length] == 0) {
        [searchBar performSelector: @selector(resignFirstResponder)
                        withObject: nil
                        afterDelay: 0.1];
    }

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.hidden = YES;
}

- (void)changeSections {
    if ([self.viewType  isEqual:@"Titles"]) {
        self.viewType = @"Genres";
        [self updateTableData:@""];
    } else if ([self.viewType  isEqual:@"Genres"]) {
        self.viewType = @"Titles";
        [self updateTableData:@""];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get destination view controller
    DetailViewController *dvc = [segue destinationViewController];
    
    // Get selected indexPath
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    
    // Get movie at current position
    Movie *selectedMovie = [[Movie alloc] init];
    NSString* category = [self.sections objectAtIndex:selectedIndexPath.section];
    NSArray* arrayForSection = (NSArray*)[self.filteredTableData objectForKey:category];
    selectedMovie = (Movie *)[arrayForSection objectAtIndex:selectedIndexPath.row];

    // Pass movie to detail view controller
    dvc.movie = selectedMovie;
}

@end
