//
//  BPDBSortFilter.h
//  BasicProject
//
//  Created by bieny on 2021/3/18.
//  Copyright © 2021 404. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BPDBSortFilter : NSObject

@property (nonatomic, copy) NSString *sortPropertyName;
/// 是否升序
@property (nonatomic, assign) BOOL ascending;

+ (instancetype)sortFilterWithPropertyName:(NSString *)propertyName ascending:(BOOL)ascending;


@end

NS_ASSUME_NONNULL_END
