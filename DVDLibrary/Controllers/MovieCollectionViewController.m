//
//  MovieCollectionViewController.m
//  DVDLibrary
//
//  Created by Ming on 2/27/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import "MovieCollectionViewController.h"
#import "MovieCollectionViewCell.h"
#import "Movie.h"

@interface MovieCollectionViewController ()

@end

@implementation MovieCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView
      numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"MovieCollectionViewCellID";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *movieImageView = (UIImageView *)[cell viewWithTag:100];
    
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://icondock.com/wp-content/uploads/2009/03/easter-icons.jpg"]]];
    movieImageView.image = image;
    
    return cell;
}

//- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView
//                   cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"MovieCollectionViewCellID";
//    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    Movie *movie = [self.movies objectAtIndex:indexPath.row];
//
//    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://icondock.com/wp-content/uploads/2009/03/easter-icons.jpg"]]];
//    
//    [cell.movieImage setImage:image];
//    
//    return cell;
//
//}


@end
