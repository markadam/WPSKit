//
//  WPSFetchedResultsDataSource.m
//  WPSKitSamples
//
//  Created by Kirby Turner on 2/1/14.
//  Copyright (c) 2014 White Peak Software Inc. All rights reserved.
//

#import "WPSFetchedResultsDataSource.h"
#import "NSArray+WPSKit.h"
#import <CoreData/CoreData.h>

@implementation WPSFetchedResultsDataSource

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
   NSFetchedResultsController *frc = [self fetchedResultsController];
   return [frc objectAtIndexPath:indexPath];
}

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath
{
   NSString *cellId = [self cellIdentifier];
   WPSCellIdentifierBlock cellIdentifier = [self cellIdentifierBlock];
   if (cellIdentifier) {
      cellId = cellIdentifier(indexPath);
   }
   return cellId;
}

#pragma mark - Helpers

- (NSInteger)numberOfSections
{
   NSFetchedResultsController *frc = [self fetchedResultsController];
   NSInteger count = (NSInteger)[[frc sections] count];
   return count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
   NSFetchedResultsController *frc = [self fetchedResultsController];
   id <NSFetchedResultsSectionInfo> sectionInfo = [[frc sections] objectAtIndex:(NSUInteger)section];
   NSInteger count = (NSInteger)[sectionInfo numberOfObjects];
   
   return count;
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
   return [self numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return [self numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self cellIdentifierAtIndexPath:indexPath] forIndexPath:indexPath];
   if (self.configureCellBlock) {
      id object = [self objectAtIndexPath:indexPath];
      self.configureCellBlock(cell, indexPath, object);
   }
   return cell;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return [self numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [self numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifierAtIndexPath:indexPath] forIndexPath:indexPath];
   if (self.configureCellBlock) {
      id object = [self objectAtIndexPath:indexPath];
      self.configureCellBlock(cell, indexPath, object);
   }
   return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   NSString *title = nil;
   NSArray *titles = [self sectionHeaderTitles];
   if (titles) {
      id value = [titles wps_safeObjectAtIndex:(NSUInteger)section];
      if ([value isKindOfClass:[NSString class]]) {
         title = value;
      }
   }
   return title;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
   BOOL canEdit = YES;
   if (self.canEditBlock) {
      canEdit = self.canEditBlock(indexPath);
   }
   return canEdit;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (self.commitEditingStyleBlock) {
      self.commitEditingStyleBlock(tableView, editingStyle, indexPath);
   }
}

@end
