//
//  MovieCollectionViewController.h
//  DVDLibrary
//
//  Created by Ming on 3/2/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LibraryViewController.h"

@interface MovieCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) LibraryViewController *lvc;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
