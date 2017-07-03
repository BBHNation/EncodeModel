# EncodeModel & Dic2Entity
you can use this model to make the encoding &amp; decoding much easier.
more detail in the  Demo.swift

####
#### 1. 你可以使用这个model在iOS开发中来简化encoding和decoding
#### 2. 你可以使用这个model在iOS开发中实现字典初始化对象的过程

#### 更多的信息，从项目的Demo.swift中获取

#### Example Code

First Step 使用字典初始化，并归档

```
let he = Hello.init(dic: ["name": 123,
                                  "gender":true])
        
        
        let demo = Demo.init(dic: ["content":content.text ?? "nil",
                                   "age":12,
                                   "name":"BBH",
                                   "gender":false,
                                   "classMates":["RQQ","DZ"],
                                   "otherDic":["hello":"world"],
                                   "hellocontent":he,
                                   "intArr":[2,3,4,5]
                            ])
        demo.archive(fileName: "helloFileName")

```

Seconde Step 解档并获取对象描述

```
let demo = Demo.unarchive(fileName: "helloFileName") as? Demo
        output.text = demo?.content
        print(demo?.description ?? "nil")
```
