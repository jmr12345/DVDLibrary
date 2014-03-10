//
//  MovieCollectionViewController.m
//  DVDLibrary
//
//  Created by Ming on 3/2/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//
// MovieCollectionViewController handles displaying the movies in a collection view.
// Clicking on a movie segues to the DetailViewController.

#import "MovieCollectionViewController.h"
#import "MovieCollectionViewCell.h"
#import "Movie.h"
#import "MovieData.h"
#import "DetailViewController.h"
#import "CollectionHeaderView.h"

@interface MovieCollectionViewController ()
@end

@implementation MovieCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Collection view data source

- (NSInteger) numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return [self.lvc.sections count];
}

- (NSInteger) collectionView:(UICollectionView *)collectionView
      numberOfItemsInSection:(NSInteger)section
{
    NSString* category = [self.lvc.sections objectAtIndex:section];
    NSArray* arrayForSection = (NSArray*)[self.lvc.filteredMovieData objectForKey:category];
    return [arrayForSection count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MovieCollectionViewCellID";
    MovieCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    // Get movie at current position
    Movie *movie = [[Movie alloc] init];
    NSString* category = [self.lvc.sections objectAtIndex:indexPath.section];
    NSArray* arrayForSection = (NSArray*)[self.lvc.filteredMovieData objectForKey:category];
    movie = (Movie *)[arrayForSection objectAtIndex:indexPath.row];

    // Configure cell with current movie's image
    UIImage *image = movie.image;
    [cell.movieImageView setImage:image];
    
    return cell;
}

- (UICollectionReusableView *)collectionView: (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    CollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                        UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderID" forIndexPath:indexPath];
    
    headerView.sectionLabel.text = self.lvc.sections[indexPath.section];
    [headerView setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.7f]];
    
    return headerView;
}

#pragma mark - Collection view delegate flow layout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // If no items in section, no insets
    if ([self.collectionView numberOfItemsInSection:section] == 0){
        return UIEdgeInsetsMake(0,0,0,0);
    }
    return UIEdgeInsetsMake(15, 22, 15, 22);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    // If no items in sections, don't show header
    if ([self.collectionView numberOfItemsInSection:section] == 0){
        return CGSizeMake(0,0);
    }
    return CGSizeMake(self.view.bounds.size.width, 28);
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@">>>>> Segue to DetailViewController from MovieCollectionViewController");
    
    // Get destination view controller
    DetailViewController *dvc = [segue destinationViewController];
    
    // Get selected indexPath
    NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
    NSIndexPath *selectedIndexPath = [indexPaths objectAtIndex:0];
    
    // Get movie at current position
    Movie *selectedMovie = [[Movie alloc] init];
    NSString* category = [self.lvc.sections objectAtIndex:selectedIndexPath.section];
    NSArray* arrayForSection = (NSArray*)[self.lvc.filteredMovieData objectForKey:category];
    selectedMovie = (Movie *)[arrayForSection objectAtIndex:selectedIndexPath.row];
    
    // Pass movie to detail view controller
    dvc.movie = selectedMovie;
}

@end
