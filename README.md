# EncodeModel
#### you can use this model to make the encoding &amp; decoding much easier.
#### more detail in the  Demo.swift

####
#### 你可以使用这个model在iOS开发中来简化encoding和decoding
#### 更多的信息，从项目的Demo.swift中获取

#### Example Code

First Step
```
/// BaseEncodeModel is the EncodeModel
class Demo: BaseEncodeModel {
    var name : String = ""
    var age : Int = 0
    var gender : Bool = false
    var content : String = ""
}
```

Seconde Step
```
let demo = Demo.init()
demo.content = content.text!
demo.age = 22
demo.name = "BBH"
demo.gender = true
demo.archive(fileName: "helloFileName")
```

Third Step
```
/// Get the object
let demo = Demo.unarchive(fileName: "helloFileName") as? Demo
```
