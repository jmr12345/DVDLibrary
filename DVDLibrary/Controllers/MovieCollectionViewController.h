//
//  MovieCollectionViewController.h
//  DVDLibrary
//
//  Created by Ming on 3/2/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) NSArray* allTableData;
@property (strong, nonatomic) NSMutableDictionary* filteredTableData;
@property (strong, nonatomic) NSMutableArray* sections;


@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (nonatomic, assign) bool isFiltered;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIToolbar *searchBar;

-(void)changeSections;
@end
