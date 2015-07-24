//
//  Document.h
//  TahDoodle
//
//  Created by jiangchao on 15/7/24.
//  Copyright (c) 2015年 jiangchao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Document : NSDocument <NSTableViewDataSource>
{
    NSMutableArray *todoItems;
    IBOutlet NSTableView *itemTableView;
}

- (IBAction)createNewItem:(id)sender;


@end

