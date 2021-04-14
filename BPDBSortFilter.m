//
//  BPDBSortFilter.m
//  BasicProject
//
//  Created by bieny on 2021/3/18.
//  Copyright © 2021 404. All rights reserved.
//

#import "BPDBSortFilter.h"

@implementation BPDBSortFilter

+ (instancetype)sortFilterWithPropertyName:(NSString *)propertyName ascending:(BOOL)ascending
{
    BPDBSortFilter *sortFilter = [[BPDBSortFilter alloc] init];
    sortFilter.sortPropertyName = propertyName;
    sortFilter.ascending = ascending;
    
    return sortFilter;
}

@end
