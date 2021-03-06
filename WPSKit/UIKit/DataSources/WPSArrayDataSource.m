//
//  WPSArrayDataSource.m
//  WPSKitSamples
//
//  Created by Kirby Turner on 2/1/14.
//  Copyright (c) 2014 White Peak Software Inc. All rights reserved.
//

#import "WPSArrayDataSource.h"
#import "NSArray+WPSKit.h"

@interface WPSArrayDataSource ()

@end

@implementation WPSArrayDataSource

- (id)initWithArray:(NSArray *)array cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(WPSCellConfigureBlock)configureCellBlock
{
   self = [self initWithArray:array sectionHeaderTitles:nil cellIdentifier:cellIdentifier configureCellBlock:configureCellBlock];
   if (self) {
      
   }
   return self;
}

- (id)initWithArray:(NSArray *)array sectionHeaderTitles:(NSArray *)sectionHeaderTitles cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(WPSCellConfigureBlock)configureCellBlock
{
   self = [super init];
   if (self) {
      [self setArray:array];
      [self setSectionHeaderTitles:sectionHeaderTitles];
      [self setCellIdentifier:cellIdentifier];
      [self setConfigureCellBlock:configureCellBlock];
   }
   return self;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
   NSArray *array = [[self array] wps_safeObjectAtIndex:(NSUInteger)[indexPath section]];
   NSUInteger index = (NSUInteger)[indexPath item];
   id object = [array wps_safeObjectAtIndex:index];
   return object;
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

- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath
{
   NSMutableArray *allObjects = [[self array] mutableCopy];
   NSMutableArray *sectionObjects = [[allObjects wps_safeObjectAtIndex:(NSUInteger)[indexPath section]] mutableCopy];
   NSUInteger index = (NSUInteger)[indexPath item];
   [sectionObjects removeObjectAtIndex:index];
   [allObjects replaceObjectAtIndex:(NSUInteger)[indexPath section] withObject:sectionObjects];
   
   [self setArray:[allObjects copy]];
}

#pragma mark - Helpers

- (NSInteger)numberOfSections
{
   NSInteger count = (NSInteger)[[self array] count];
   return count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
   NSArray *sectionItems = [[self array] wps_safeObjectAtIndex:(NSUInteger)section];
   NSInteger count = (NSInteger)[sectionItems count];
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
      id item = [self objectAtIndexPath:indexPath];
      self.configureCellBlock(cell, indexPath, item);
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
      id item = [self objectAtIndexPath:indexPath];
      self.configureCellBlock(cell, indexPath, item);
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
