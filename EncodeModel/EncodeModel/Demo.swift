//
//  Demo.swift
//  EncodeModel
//
//  Created by 白彬涵 on 2017/6/27.
//  Copyright © 2017年 MR White. All rights reserved.
//

import UIKit
class Hello: BaseEntity {
    var name : String = ""
    var gender : Bool = false
}

class Demo: BaseEntity {
    var name : String = "" // String类型
    var age : Int = 0 // Int类型
    var gender : Bool = false // Bool类型
    var content : String = "" // String 类型
    var classMates : Array<String> = [] // 数组类型
    var otherDic : [String : Any] = [:] // 字典类型
    var hellocontent : Hello? // 类 类型
    var intArr : Array<Int> = [] // 数组Int
}
