//
//  BPDBManager.h
//  BasicProject
//
//  Created by bieny on 2021/3/18.
//  Copyright © 2021 404. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPDBConfig.h"
#import "BPDBObject.h"
#import "BPDBSortFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface BPDBManager : NSObject

/**
 * 数据库初始化配置, 全局只会执行一次
 * @param cfg 配置信息
 */
+ (void)setupConfigInfo:(BPDBConfig *)cfg;

/**
 *  写入一条数据
 *
 *  @param obj 目标数据
 *
 *  @return 执行结果
 */
+ (BOOL)writeObj:(__kindof BPDBObject *)obj;

/**
 *  批量写入
 *
 *  @param objs 数组
 *
 *  @return 执行结果
 */
+ (BOOL)writeObjs:(NSArray<__kindof BPDBObject *> *)objs;

/**
 *  更新一条数据，更新数据必须在block中执行
 *
 *  @param updateBlock 在block中更新数据
 *
 *  @return 执行结果
 */
+ (BOOL)updateObj:(void (^)(void))updateBlock;

/**
 *  在数据库中删除目标数据
 *
 *  @param obj 目标数据
 *
 *  @return 执行结果
 */
+ (BOOL)deleteObj:(__kindof BPDBObject *)obj;

/**
 *  在数据库中目标主键数据
 *
 * @param primaryKey 主键
 * @param clazz 目标类
 *
 * @return 执行结果
 */
+ (BOOL)deleteObjWithPrimaryKey:(id)primaryKey targetClass:(Class)clazz;

/**
 *  在数据库中删除目标数组数据
 *
 *  @param objs 需要删除的数据数组
 *
 *  @return 执行结果
 */
+ (BOOL)deleteObjs:(NSArray<__kindof BPDBObject *> *)objs;

/**
 * 在数据库中删除所有目标类对应的数据
 *
 * @param clazz 目标类
 *
 * @return 执行结果
 */
+ (BOOL)deleteAllTargetObjs:(Class)clazz;

/**
 *  查询目标数据模型的所有存储数据
 *
 *  @param clazz 需要查询的目标类
 *
 *  @return 数据库中存储的所有数据
 */
+ (NSArray<__kindof BPDBObject *> *)queryAllObj:(Class)clazz;

/**
 *  根据断言条件查询目标数据
 *
 *  @param predicate 查询条件
 *  @param clazz     需要查询的目标类
 *
 *  @return 查询结果
 */
+ (NSArray<__kindof BPDBObject *> *)queryObjsWithPredicate:(NSPredicate *)predicate targetClass:(Class)clazz;

/**
 *  根据断言条件查询数据，并进行排序
 *
 *  @param predicate  查询条件
 *  @param clazz      需要查询的类
 *  @param sortFilter 排序配置
 *
 *  @return 查询结果
 */
+ (NSArray<__kindof BPDBObject *> *)queryObjsWithPredicate:(NSPredicate *)predicate sortFilter:(BPDBSortFilter *)sortFilter targetClass:(Class)clazz;

/**
 *  根据主键查询目标数据
 *
 *  @param primaryKey 主键值
 *  @param clazz      需要查询的类
 *
 *  @return 查询结果
 */
+ (__kindof BPDBObject *)queryObjWithPrimaryKey:(id)primaryKey targetClass:(Class)clazz;

/**
 *  清空数据库
 *
 *  @return 执行结果
 */
+ (BOOL)clear;

@end

NS_ASSUME_NONNULL_END
