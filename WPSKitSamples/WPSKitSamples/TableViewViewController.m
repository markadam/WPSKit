//
//  TableViewViewController.m
//  WPSKitSamples
//
//  Created by Kirby Turner on 8/22/13.
//  Copyright (c) 2013 White Peak Software Inc. All rights reserved.
//

#import "TableViewViewController.h"

@interface TableViewViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation TableViewViewController

- (id)initWithDefaultNib
{
   self = [super initWithNibName:@"TableViewViewController" bundle:nil];
   if (self) {
      
   }
   return self;
}

- (NSDictionary *)itemAtIndexPath:(NSIndexPath *)indexPath
{
   NSDictionary *dict = [[self data] objectAtIndex:[indexPath section]];
   NSArray *items = [dict objectForKey:kWPSFeatureKeyItems];
   NSDictionary *item = [items objectAtIndex:[indexPath row]];
   return item;
}

#pragma mark - UITableViewDelegate and UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   NSInteger count = [[self data] count];
   return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   NSDictionary *dict = [[self data] objectAtIndex:section];
   NSArray *items = [dict objectForKey:kWPSFeatureKeyItems];
   NSInteger count = [items count];
   return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   NSDictionary *dict = [[self data] objectAtIndex:section];
   NSString *title = [dict objectForKey:kWPSFeatureKeyTitle];
   return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *cellID = @"cellID";
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
   if (!cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
      [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
   }
   
   NSDictionary *item = [self itemAtIndexPath:indexPath];
   NSString *title = [item objectForKey:kWPSFeatureKeyTitle];
   [[cell textLabel] setText:title];
   
   return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSDictionary *item = [self itemAtIndexPath:indexPath];
   NSString *title = [item objectForKey:kWPSFeatureKeyTitle];
   NSArray *items = [item objectForKey:kWPSFeatureKeyItems];
   NSString *viewControllerClassName = [item objectForKey:kWPSFeatureKeyViewControllerClassName];
   
   CustomViewController *viewController = [[NSClassFromString(viewControllerClassName) alloc] initWithDefaultNib];
   [viewController setTitle:title];
   [viewController setData:items];
   
   [[self navigationController] pushViewController:viewController animated:YES];
   
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
