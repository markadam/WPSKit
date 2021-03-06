//
//  WebClientViewController.h
//  WPSKitSamples
//
//  Created by Kirby Turner on 2/16/12.
//  Copyright (c) 2012 White Peak Software Inc. All rights reserved.
//

#import "CustomViewController.h"

@class WPSTextView;

@interface WebClientViewController : CustomViewController

@property (nonatomic, strong) IBOutlet WPSTextView *textView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
