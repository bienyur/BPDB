//
//  BPDBObject.h
//  BasicProject
//
//  Created by bieny on 2021/3/18.
//  Copyright © 2021 404. All rights reserved.
//

#import <Realm/Realm.h>

NS_ASSUME_NONNULL_BEGIN

@interface BPDBObject : RLMObject
/// 必须定义主键
+ (NSString *)primaryKey;
@end

NS_ASSUME_NONNULL_END
