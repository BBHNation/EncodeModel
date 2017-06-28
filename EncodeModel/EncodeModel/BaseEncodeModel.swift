//
//  EncodeBaseModel.swift
//  EncodeModel
//
//  Created by 白彬涵 on 2017/6/27.
//  Copyright © 2017年 MR White. All rights reserved.
//

import Foundation

class BaseEncodeModel : NSObject, NSCoding {
    override init() {}
    
    /// 获取所有的属性名字
    ///
    /// - Returns: 返回一个数组，带有属性名字
    func getPropertyNameList() -> [String] {
        var count : UInt32 = 0
        var names : [String] = []
        let properties = class_copyPropertyList(type(of: self), &count)
        guard let propertyList = properties else { return [] }
        for i in 0..<count {
            let property = propertyList[Int(i)]
            guard let char_b = property_getName(property) else {
                continue //到下一个循环
            }
            if let key = NSString(cString: char_b, encoding: String.Encoding.utf8.rawValue) as String? {
                names.append(key)
            }
        }
        return names
    }
    
    /// 协议方法
    ///
    /// - Parameter aCoder: 编码
    func encode(with aCoder: NSCoder) {
        let propertyList = getPropertyNameList()
        for p_name in propertyList {
            aCoder.encode(value(forKey: p_name), forKey: p_name)
        }
        print("encode successful")
    }
    
    /// 协议方法
    ///
    /// - Parameter aDecoder: 解码
    required init?(coder aDecoder: NSCoder) {
        super.init()
        let propertyList = getPropertyNameList()
        for p_name in propertyList {
            let value = aDecoder.decodeObject(forKey: p_name)
            setValue(value, forKey: p_name)
        }
    }
    
    /// 实例方法，开始编码
    ///
    /// - Parameter fileName: 文件名字
    func archive(fileName: String) {
        let filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let savePath = filePath + "/" + fileName + ".plist"
        NSKeyedArchiver.archiveRootObject(self, toFile: savePath)
    }
    
    /// 类方法，开始解码
    ///
    /// - Parameter fileName: 文件名字
    /// - Return: 返回一个实例，可以为空
    static func unarchive(fileName: String) -> Any? {
        let filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let savePath = filePath + "/" + fileName + ".plist"
        return NSKeyedUnarchiver.unarchiveObject(withFile: savePath)
    }
}
