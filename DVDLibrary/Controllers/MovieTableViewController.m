//
//  MovieTableViewController.m
//  DVDLibrary
//
//  Created by Ming on 2/27/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import "MovieTableViewController.h"
#import "MovieTableViewCell.h"
#import "Movie.h"
#import "MovieData.h"

@interface MovieTableViewController ()

@property NSString *viewType;

@end

@implementation MovieTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.viewType = @"Titles";
    
    self.searchBar.delegate = (id)self;
    
    self.allTableData = [[MovieData alloc] init].movieData;
    
    
    self.tableView.sectionFooterHeight = 0.0;
    self.tableView.sectionHeaderHeight = 30.0;
    
    [self updateTableData:@""];
    [self.tableView reloadData];
}

//-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
//    return 20;
//}

//-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
//    return 0;
//}
//
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 50;
//}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* key = @"";
    
    if ([self.viewType  isEqual:@"Titles"]) {
       key = [self.letters objectAtIndex:section];
    } else if ([self.viewType  isEqual:@"Genres"]) {
       key = [self.genres objectAtIndex:section];
    }
    
    return key;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.viewType  isEqual:@"Titles"]) {
        return [self.letters count];
    } else if ([self.viewType  isEqual:@"Genres"]) {
        return [self.genres count];
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.viewType  isEqual:@"Titles"]) {
        NSString* letter = [self.letters objectAtIndex:section];
        NSArray* arrayForLetter = (NSArray*)[self.filteredTableData objectForKey:letter];
        return [arrayForLetter count];
    } else if ([self.viewType  isEqual:@"Genres"]) {
        NSString* genre = [self.genres objectAtIndex:section];
        NSArray* arrayForGenres = (NSArray*)[self.filteredTableData objectForKey:genre];
        return [arrayForGenres count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MovieTableViewCellID";
    MovieTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[MovieTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Movie *movie = [[Movie alloc] init];
    
    if ([self.viewType  isEqual:@"Titles"]) {
        NSString* letter = [self.letters objectAtIndex:indexPath.section];
        NSArray* arrayForLetter = (NSArray*)[self.filteredTableData objectForKey:letter];
        movie = (Movie *)[arrayForLetter objectAtIndex:indexPath.row];
    } else if ([self.viewType  isEqual:@"Genres"]) {
        NSString* genre = [self.genres objectAtIndex:indexPath.section];
        NSArray* arrayForGenre = (NSArray*)[self.filteredTableData objectForKey:genre];
        movie = (Movie *)[arrayForGenre objectAtIndex:indexPath.row];
    }
  
    NSLog(@"%@",movie.title);
    
    cell.label.text = movie.title;
    [cell.movieImageView setImage:movie.image];
    return cell;
}

-(void)updateTableData:(NSString*)searchString
{
    self.filteredTableData = [[NSMutableDictionary alloc] init];
    
    for (Movie* movie in self.allTableData)
    {
        bool isMatch = false;
        if(searchString.length == 0)
        {
            // If our search string is empty, everything is a match
            isMatch = true;
        }
        else
        {
            // If we have a search string, check to see if it matches the movie title
            NSRange nameRange = [movie.title rangeOfString:searchString options:NSCaseInsensitiveSearch];
            //NSRange descriptionRange = [food.description rangeOfString:searchString options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound)
                isMatch = true;
        }
        
        // If we have a match...
        if(isMatch)
        {
            if ([self.viewType  isEqual:@"Titles"]) {
                // Find the first letter of the title's name. This will be its group.
                NSString* firstLetter = [movie.title substringToIndex:1];
                
                // Check to see if we already have an array for this group
                NSMutableArray* arrayForLetter = (NSMutableArray*)[self.filteredTableData objectForKey:firstLetter];
                if(arrayForLetter == nil)
                {
                    // If we don't, create one, and add it to our dictionary
                    arrayForLetter = [[NSMutableArray alloc] init];
                    [self.filteredTableData setValue:arrayForLetter forKey:firstLetter];
                }
                
                // Finally, add the food to this group's array
                [arrayForLetter addObject:movie];

            } else if ([self.viewType  isEqual:@"Genres"]) {
                // Find the genre of the movie. This will be its group.
                NSString* genre = movie.genre;
                
                // Check to see if we already have an array for this group
                NSMutableArray* arrayForGenre = (NSMutableArray*)[self.filteredTableData objectForKey:genre];
                if(arrayForGenre == nil)
                {
                    // If we don't, create one, and add it to our dictionary
                    arrayForGenre = [[NSMutableArray alloc] init];
                    [self.filteredTableData setValue:arrayForGenre forKey:genre];
                }
                
                // Finally, add the movie to this group's array
                [arrayForGenre addObject:movie];
            }

        }
    }
    
    if ([self.viewType  isEqual:@"Titles"]) {
        self.letters = [[[self.filteredTableData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
    } else if ([self.viewType  isEqual:@"Genres"]) {
        self.genres = [[[self.filteredTableData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
    }
    
    // Finally, refresh the table
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    //view.tintColor = [UIColor blackColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
     header.contentView.backgroundColor = [UIColor blackColor];
}

#pragma mark - Table view delegate

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    [self updateTableData:text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

///*
///*
//#pragma mark - Navigation
//
//// In a story board-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//
// */
//
- (IBAction)switchToTitles:(id)sender {
    self.viewType = @"Titles";
    [self updateTableData:@""];

}

- (IBAction)switchToGenres:(id)sender {
    self.viewType = @"Genres";
    [self updateTableData:@""];

}
@end
