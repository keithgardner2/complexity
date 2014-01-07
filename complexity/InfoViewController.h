//
//  InfoViewController.h
//  complexity
//
//  Created by Patrick Madden on 12/7/13.
//  Copyright (c) 2013 Optimality Research Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController
@property (nonatomic, assign) NSString *fileToLoad;
@property (nonatomic, retain) IBOutlet UIWebView *wv;


@end
