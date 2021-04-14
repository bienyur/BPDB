//
//  BPDBManager.m
//  BasicProject
//
//  Created by bieny on 2021/3/18.
//  Copyright © 2021 404. All rights reserved.
//

#import "BPDBManager.h"


@interface BPDBManager()

@property (nonatomic,strong) RLMRealmConfiguration *realmConfig;

@end

@implementation BPDBManager

+ (BPDBManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    static BPDBManager * instance;
    dispatch_once( &onceToken, ^{
        
        instance = [[BPDBManager alloc] init];
        
    });
    
    return instance;
}


+ (void)setupConfigInfo:(BPDBConfig *)cfg
{
    if (cfg == nil) {
        return;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 数据库配置
        RLMRealmConfiguration *rlmCfg = [RLMRealmConfiguration defaultConfiguration];
        rlmCfg.schemaVersion = cfg.dbVer;
        rlmCfg.migrationBlock = cfg.migrationBlock;
        
        if (cfg.encryptKey.length > 0) {
            rlmCfg.encryptionKey = cfg.encryptKey;
        }
        
        [self sharedInstance].realmConfig = rlmCfg;
    });
}

+ (void)configSecurityKey:(NSData *)secKey
{
    if (secKey == nil || [secKey length] == 0) {
        return;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 数据库配置
        [self sharedInstance].realmConfig = [RLMRealmConfiguration defaultConfiguration];
        [self sharedInstance].realmConfig.encryptionKey = secKey;
    });
}

+ (void)checkClazz:(Class)clazz
{
    BOOL isCorrectClass = [[clazz new] isKindOfClass:[BPDBObject class]];
    NSAssert(isCorrectClass, @"必须继承自BPDBObject");
}

/// 跨线程读写数据会出问题，必须每次都实例化一个最新的
- (RLMRealm *)realm
{
    if (self.realmConfig) {
        
        NSError *error = nil;
        RLMRealm *tempRealm = [RLMRealm realmWithConfiguration:self.realmConfig error:&error];
        if (error) {
            NSLog(@"Error opening realm: %@", error);
        }
        
        return tempRealm;
        
    }else{
        
        return [RLMRealm defaultRealm];
    }
}

#pragma mark - 写入

+ (BOOL)writeObj:(__kindof BPDBObject *)obj
{
    RLMRealm *realm = [[self sharedInstance] realm];
    return [realm transactionWithBlock:^{
        [realm addOrUpdateObject:obj];
    } error:nil];
}

+ (BOOL)writeObjs:(NSArray<__kindof BPDBObject *> *)objs
{
    RLMRealm *realm = [[self sharedInstance] realm];
    return [realm transactionWithBlock:^{
        [realm addOrUpdateObjects:objs];
    } error:nil];
}

#pragma mark - 更新

+ (BOOL)updateObj:(void (^)(void))updateBlock
{
    RLMRealm *realm = [[self sharedInstance] realm];
    
    return [realm transactionWithBlock:^{
        updateBlock();
    } error:nil];
}

#pragma mark - 删除

+ (BOOL)deleteObj:(__kindof BPDBObject *)obj
{
    RLMRealm *realm = [[self sharedInstance] realm];
    return [realm transactionWithBlock:^{
        [realm deleteObject:obj];
    } error:nil];
}

+ (BOOL)deleteObjWithPrimaryKey:(id)primaryKey targetClass:(Class)clazz
{
    BPDBObject *obj = [self queryObjWithPrimaryKey:primaryKey targetClass:clazz];
    if (obj) {
        return [self deleteObj:obj];
    } else {
        return NO;
    }
}

+ (BOOL)deleteObjs:(NSArray<__kindof BPDBObject *> *)objs
{
    RLMRealm *realm = [[self sharedInstance] realm];
    return [realm transactionWithBlock:^{
        [realm deleteObjects:objs];
    } error:nil];
}

+ (BOOL)deleteAllTargetObjs:(Class)clazz
{
    NSArray *objs = [self queryAllObj:clazz];
    return [self deleteObjs:objs];
}

#pragma mark - 查询

+ (NSArray<__kindof BPDBObject *> *)queryAllObj:(Class)clazz
{
    [BPDBManager checkClazz:clazz];
    
    RLMRealm *realm = [[self sharedInstance] realm];
    RLMResults<BPDBObject *> *queryResult = [clazz allObjectsInRealm:realm];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSInteger i = 0; i < queryResult.count; i ++) {
        
        BPDBObject *item = [queryResult objectAtIndex:i];
        
        [resultArray addObject:item];
    }
    
    return resultArray;
}

+ (NSArray<__kindof BPDBObject *> *)queryObjsWithPredicate:(NSPredicate *)predicate targetClass:(Class)clazz
{
    [BPDBManager checkClazz:clazz];
    
    RLMRealm *realm = [[self sharedInstance] realm];
    RLMResults<BPDBObject *> *queryResult = [clazz objectsInRealm:realm withPredicate:predicate];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSInteger i = 0; i < queryResult.count; i ++) {
        
        BPDBObject *item = [queryResult objectAtIndex:i];
        
        [resultArray addObject:item];
    }
    
    return resultArray;
}

+ (NSArray<__kindof BPDBObject *> *)queryObjsWithPredicate:(NSPredicate *)predicate sortFilter:(BPDBSortFilter *)sortFilter targetClass:(Class)clazz;
{
    [BPDBManager checkClazz:clazz];
    
    RLMRealm *realm = [[self sharedInstance] realm];
    
    RLMResults<BPDBObject *> *queryResult = [[clazz objectsInRealm:realm withPredicate:predicate]
                                             sortedResultsUsingKeyPath:sortFilter.sortPropertyName
                                             ascending:sortFilter.ascending];
    
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSInteger i = 0; i < queryResult.count; i ++) {
        
        BPDBObject *item = [queryResult objectAtIndex:i];
        
        [resultArray addObject:item];
    }
    
    return resultArray;
}

+ (__kindof BPDBObject *)queryObjWithPrimaryKey:(id)primaryKey targetClass:(Class)clazz;
{
    [BPDBManager checkClazz:clazz];
    
    RLMRealm *realm = [[self sharedInstance] realm];
    BPDBObject *queryObj = [clazz objectInRealm:realm forPrimaryKey:primaryKey];
    
    return queryObj;
}

#pragma mark - 清空数据库
+ (BOOL)clear
{
    RLMRealm *realm = [[self sharedInstance] realm];
    return [realm transactionWithBlock:^{
        [realm deleteAllObjects];
    } error:nil];
}

@end
