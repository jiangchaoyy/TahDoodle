//
//  Document.m
//  TahDoodle
//
//  Created by jiangchao on 15/7/24.
//  Copyright (c) 2015年 jiangchao. All rights reserved.
//

#import "Document.h"

@interface Document ()

@end

@implementation Document

#pragma mark - NSDocument的覆盖方法

- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace {
    return YES;
}

- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    //[NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    //return nil;
    
    //保存文档时调用
    //应该返回一个NSData对象，其中包含需要保存的数据
    //如果数组对象还不存在，就先使用空数组
    if (!todoItems) {
        todoItems = [NSMutableArray array];
    }
    
    //将todoItems数组转换成NSData对象
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:todoItems
                                                              format:NSPropertyListXMLFormat_v1_0
                                                             options:0
                                                               error:outError];
    //返回新创建的NSData对象
    return  data;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    //[NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    //return YES;
    
    //载入文档时调用
    //需要通过传人的对象，得到所需的数据
    
    //将NSData对象转回todoItems数组
    todoItems = [NSPropertyListSerialization propertyListWithData:data
                                                          options:NSPropertyListXMLFormat_v1_0
                                                           format:NULL
                                                            error:outError];
    
    //根据转换结果，返回成功或失败
    return (todoItems != nil);
}

#pragma mark - 数据源方法
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    //因为显示的是todoItems中的对象，所以表格对象的显示行数就是数组所包含对象的个数
    return [todoItems count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    //根据索引，返回todoItems中的相应对象，
    //表格视图将通过该对象显示相应的NSTableViewCell
    return [todoItems objectAtIndex:row];
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    //当用户修改表格视图中的任务数据时，更新todoItems数组
    [todoItems replaceObjectAtIndex:row withObject:object];
    //将文档标记为有未保存的修改
    [self updateChangeCount:NSChangeDone];
}

#pragma mark - 动作方法

- (IBAction)createNewItem:(id)sender
{
    //如果todoItems指向的对象尚不存在，则创建之，用于保存任务信息
    if (!todoItems) {
        todoItems = [NSMutableArray array];
    }
    
    [todoItems addObject:@"New Item"];
    
    //-reloadData方法会要求表格对象刷新界面,并通过其dataSource获取显示数据
    //(本例中的dataSource是Document对象)
    //
    [itemTableView reloadData];
    
    //-updateChangeCount:方法通知应用“文档”是否有尚未保存的修改。
    //NSChangeDone会将文档标记为“未保存”
    [self updateChangeCount:NSChangeDone];
}

@end
