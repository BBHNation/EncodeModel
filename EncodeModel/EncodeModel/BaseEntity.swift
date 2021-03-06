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
        let propertyNames = getPropertyNameList()
        let propertyClassesByName = self.propertyClassesByName()
        
        // 遍历类的属性名字类表，将属性内容添加到自己的类中
        for (_, key) in propertyNames.enumerated() {
            // 开始遍历
            // 这里需要处理一些类型，处理Dic中的类型与类中的类型不同的情况
            // 例如 Dic中是Int，而类型中是String，需要中间做转换
            var finalValue : String? = nil// 根据类型的不同做一些适配
            if propertyClassesByName[key] == NSString.self {
                // 如果是NSString类型
                finalValue = "\(dic[key] ?? "nil")"
//                print("NSString类型")
            }
            else if propertyClassesByName[key] == NSArray.self {
                // 如果是NSArray类型
//                print("NSArray类型")
            }
            else if propertyClassesByName[key] == NSDictionary.self {
                // 如果是NSDictionary类型
//                print("NSDictionary类型")
            }
            else if propertyClassesByName[key] == Int.self {
                // 如果是Int类型
//                print("Int类型")
            }
            else if propertyClassesByName[key] == Bool.self {
                // 如果是Bool类型
//                print("Bool类型")
            }
            else {
                // 未捕获类型
//                print("未捕获类型")
            }
            
            self.setValue(finalValue==nil ? dic[key] : finalValue, forKey: key)
        }
    }

    /// 继承自BaseEncodeModel之后必须要写的一个协议函数
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// 描述文字
    override var description: String {
        get {
            var descripString : String? = ""
            let propertyNames = getPropertyNameList()
            for (_, value) in propertyNames.enumerated() {
                
                descripString?.append("\(value) is: \(self.value(forKey: value) ?? "\(value) is nil") \n")
            }
            return descripString!
        }
    }
    
    /// 获取属性名字和类型
    ///
    /// - Returns: 返回[String : AnyClass]的字典
    /// - BUG: 其中有一个缓存bug，缓存失败，给自己添加属性失败
    /// - BUG: 其中类型处理处有需要解决的BUG，对象类型如何分类？
    private func propertyClassesByName() -> [String : AnyClass] {
        // 这里是做了一个缓存，如果有直接返回，如果没有再处理之后再缓存
        // 这里有一个缓存不成功的BUG
        var dictionary : [String : AnyClass]? = self.propertyNameTypeDic
        if dictionary != nil { return dictionary! } else { dictionary = [String : AnyClass]() }
        
        var supClass : AnyClass = object_getClass(self)// 获取本实例的类
        while supClass != object_getClass(NSObject.self) {// 一层层递归到NSObject类
            var propertyCount : UInt32 = 0
            let properties = class_copyPropertyList(supClass, &propertyCount)
            guard let propertyList = properties else { break }// 获取了属性列表
            
            
            for i in 0..<propertyCount {// 开始从属性列表中获取属性名字和属性类型
                let property = propertyList[Int(i)]
                guard let p_name = property_getName(property) else { continue }
                let key = String.init(cString: p_name)// 获取到了属性名字
                
                // 检查是否有隐藏的变量
                guard let ivar = property_copyAttributeValue(property, "V") else { continue }
                
                // ivar存在并且p_name也存在
                let ivarName = String.init(cString: ivar)
                if ivarName == key || ivarName == "_"+key {// 如果属性和变量是对应的
                    // 开始判断变量的类型
                    var propertyClass : AnyClass? = nil // 可为空的属性类型，如果为空则表示目前这个类型没有被处理
                    guard let typeEncoding = property_copyAttributeValue(property, "T") else { continue }// 第二个参数是“V”是获取变量名，“T”是获取类型，其中typeEncoding是Int8类型
                    
                    switch typeEncoding[0] {
                    case 64:
                        // %@ 对象Object类型
//                        print("对象类型")
                        if strlen(typeEncoding) >= 3 {
                            let cName = strndup(typeEncoding + 2, Int(strlen(typeEncoding))-3)
                            let name = NSString.init(utf8String: cName!)
                            let range = name?.range(of: "<")
                            var finalName : String? = nil
                            if range?.location != NSNotFound {
                                finalName = (name?.substring(to: (range?.location)!))!
                            }
                            propertyClass = finalName == nil ? NSClassFromString(name! as String) : NSClassFromString(finalName!)
                            print(propertyClass ?? "property is nil")
                            free(cName)
                        }
                    case 66:
                        // %B Bool类型
//                        print("Bool类型")
                        propertyClass = object_getClass(Bool.self)
                    case 113:
//                        print("Int类型")
                        propertyClass = object_getClass(Int.self)
                    default:
//                        print("未被处理的类型")
                        break
                    }
                    free(typeEncoding)
                    if propertyClass != nil {
                        dictionary?[key] = propertyClass
                    }
                }
                free(ivar)
            }
            free(properties)
            supClass = supClass.superclass()!
        }
        
        //这里做一个缓存
        self.propertyNameTypeDic = dictionary
        
        return dictionary!
    }
}




private var cacheKey : Void?// 用来作为缓存的Key
// MARK: - 给BaseEntity添加一个属性和类型的属性
extension BaseEntity {
    var propertyNameTypeDic : [String : AnyClass]? {
        get {
            return objc_getAssociatedObject(self, &cacheKey) as? [String : AnyClass]
        }
        set {
            objc_setAssociatedObject(self, &cacheKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
