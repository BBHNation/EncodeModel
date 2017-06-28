//
//  BaseEntity.swift
//  EncodeModel
//
//  Created by 白彬涵 on 2017/6/28.
//  Copyright © 2017年 MR White. All rights reserved.
//

import UIKit

/// BaseEntity是一个根据字典key-value形式来转换为对象的Entity
/// 继承BaseEntity，然后直接调用init函数就可以直接获取已经赋值的实体
/// 由于BaseEntity是继承自BaseEncodeModel，所以可以方便的使用Encode和Decode
class BaseEntity: BaseEncodeModel {
    
    /// 根据字典初始化
    init(dic: Dictionary<String, Any>) {
        super.init()
    }
    
    func test() {
        let resultArr = getPropertyNameList()
        print(resultArr)
    }
    
    /// 继承自BaseEncodeModel之后必须要写的一个协议函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 获取类的属性名字数组
    ///
    /// - Returns: 返回包含一个类及其父类的所有属性名字数组
    private func propertyNames() -> [String] {
        var nameArr = [String]()
        guard var supClass = object_getClass(self) else { return [] } // 获取本实例的类
        // 一层一层的向上循环获取属性列表
        while supClass != object_getClass(NSObject.self) {
            /// Step1 获取属性列表
            var propertyCount : UInt32 = 0
            let properties = class_copyPropertyList(supClass, &propertyCount)
            guard let propertyList = properties else { return [] }
            
            /// Step2 遍历属性列表并添加到数组末尾
            for i in 0..<propertyCount {
                let property = propertyList[Int(i)]
                let propertyName = property_getName(property)
                let key = String.init(cString: propertyName!)
                /*
                 * 这里有一个判断，去除Entity的子类中的entityClassDictionary
                 * 不让出现重复赋值递归赋值的情况
                 */
                /*
                 * if key == "entityClassDictionary" { continue }
                 */
                nameArr.append(key)
            }
            free(properties)
            supClass = supClass.superclass()!
        }
        return nameArr
    }
    
    private func propertyClassesByName() -> [String : String] {
        // 这里是做了一个缓存，如果有直接返回，如果没有再处理之后再缓存
        var cacheKey = "cacheKey"
        var dictionary = objc_getAssociatedObject(self, &cacheKey)
        if dictionary != nil { return dictionary as! [String : String] }
        var subClass = object_getClass(self)// 获取本实例的类
        while subClass != object_getClass(NSObject.self) {
            
        }
        return [:]
    }
}
