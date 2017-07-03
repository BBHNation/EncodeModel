//
//  ViewController.swift
//  EncodeModel
//
//  Created by 白彬涵 on 2017/6/27.
//  Copyright © 2017年 MR White. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var content: UITextField!
    @IBOutlet weak var output: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func encode(_ sender: Any) {
        let he = Hello.init(dic: ["name":"白彬涵",
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
    }

    
    @IBAction func decode(_ sender: Any) {
        let demo = Demo.unarchive(fileName: "helloFileName") as? Demo
        output.text = demo?.content
        print(demo?.description ?? "nil")
    }
}
