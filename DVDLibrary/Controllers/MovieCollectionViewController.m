//
//  MovieCollectionViewController.m
//  DVDLibrary
//
//  Created by Ming on 3/2/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import "MovieCollectionViewController.h"
#import "MovieCollectionViewCell.h"
#import "Movie.h"
#import "MovieData.h"
#import "DetailViewController.h"
#import "CollectionHeaderView.h"


@interface MovieCollectionViewController ()
@property NSString *viewType;
@end

@implementation MovieCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.viewType = @"Titles";
}

- (NSInteger) numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return [self.lvc.sections count];
}

- (NSInteger) collectionView:(UICollectionView *)collectionView
      numberOfItemsInSection:(NSInteger)section
{
    NSString* category = [self.lvc.sections objectAtIndex:section];
    NSArray* arrayForSection = (NSArray*)[self.lvc.filteredTableData objectForKey:category];
    return [arrayForSection count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MovieCollectionViewCellID";
    MovieCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    // Get movie at current position
    Movie *movie = [[Movie alloc] init];
    NSString* category = [self.lvc.sections objectAtIndex:indexPath.section];
    NSArray* arrayForSection = (NSArray*)[self.lvc.filteredTableData objectForKey:category];
    movie = (Movie *)[arrayForSection objectAtIndex:indexPath.row];

    // Configure cell with current movie's image
    UIImage *image = movie.image;
    [cell.movieImageView setImage:image];
    
    return cell;
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 22, 15, 22);
}

- (void)changeSections {
//    if ([self.viewType  isEqual:@"Titles"]) {
//        self.viewType = @"Genres";
//        [self updateTableData:@""];
//    } else if ([self.viewType  isEqual:@"Genres"]) {
//        self.viewType = @"Titles";
//        [self updateTableData:@""];
//    }
}

- (UICollectionReusableView *)collectionView: (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    CollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                         UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderID" forIndexPath:indexPath];
    headerView.sectionLabel.text = self.lvc.sections[indexPath.section];
    [headerView setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.7f]];

    return headerView;
}

#pragma mark - Collection view data source

- (NSString *)collectionView:(UICollectionView *)collectionView titleForHeaderInSection:(NSInteger)section
{
    NSString* key = [self.lvc.sections objectAtIndex:section];
    return key;
}

-(UIView *)collectionView:(UICollectionView *)collectionView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, collectionView.frame.size.width, 28)];
    
    // Setup label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, collectionView.frame.size.width, 28)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    NSString *string = [self.lvc.sections objectAtIndex:section];
    [label setText:string];
    [view addSubview:label];
    
    [view setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.7f]];
    
    return view;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get destination view controller
    DetailViewController *dvc = [segue destinationViewController];
    
    // Get selected indexPath
    NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
    NSIndexPath *selectedIndexPath = [indexPaths objectAtIndex:0];
    
    // Get movie at current position
    Movie *selectedMovie = [[Movie alloc] init];
    NSString* category = [self.lvc.sections objectAtIndex:selectedIndexPath.section];
    NSArray* arrayForSection = (NSArray*)[self.lvc.filteredTableData objectForKey:category];
    selectedMovie = (Movie *)[arrayForSection objectAtIndex:selectedIndexPath.row];
    
    // Pass movie to detail view controller
    dvc.movie = selectedMovie;
}

@end
