





import Foundation

class BaseEncodeModel : NSObject, NSCoding {
    override init() {}
    
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
    
    func encode(with aCoder: NSCoder) {
        let propertyList = getPropertyNameList()
        for p_name in propertyList {
            aCoder.encode(value(forKey: p_name), forKey: p_name)
        }
        print("encode successful")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        let propertyList = getPropertyNameList()
        for p_name in propertyList {
            let value = aDecoder.decodeObject(forKey: p_name)
            setValue(value, forKey: p_name)
        }
    }
    
    func archive(fileName: String) {
        let filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let savePath = filePath + "/" + fileName + ".plist"
        NSKeyedArchiver.archiveRootObject(self, toFile: savePath)
    }
    
    static func unarchive(fileName: String) -> Any {
        let filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let savePath = filePath + "/" + fileName + ".plist"
        return NSKeyedUnarchiver.unarchiveObject(withFile: savePath) as! objectCode
    }
}




class objectCode : BaseEncodeModel {
    var name: String? = nil
    var gender: Bool = false
    var age: Int = 0
    
    override init() {
        super.init()
    }
    
    func describe() {
        let arr = getPropertyNameList()
        print(arr)
    }
    
    func printProperty() {
        print("\(name!), \(gender), \(age)")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
