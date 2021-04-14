//
//  BPDBConfig.h
//  BasicProject
//
//  Created by bieny on 2021/3/18.
//  Copyright © 2021 404. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPDBObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface BPDBConfig : NSObject

/// 数据库加密KEY
@property (nonatomic, strong, nullable) NSData *encryptKey;
/// 数据库版本
@property (nonatomic, assign) uint64_t dbVer;
/// 数据库版本合并处理回调
@property (nonatomic, copy, nullable) RLMMigrationBlock migrationBlock;

@end

NS_ASSUME_NONNULL_END
