//
//  MovieCollectionViewController2.h
//  DVDLibrary
//
//  Created by Ming on 3/2/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) NSArray* allTableData;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

-(void)changeSections;
@end
