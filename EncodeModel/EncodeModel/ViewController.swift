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
        let demo = Demo.init(dic: ["content":"hello world",
                                   "age":12,
                                   "name":"BBH",
                                   "gender":false,
                                   "classMates":["RQQ","DZ"]])
        
        /*
        demo.content = content.text!
        demo.age = 22
        demo.name = "BBH"
        demo.gender = true
        demo.archive(fileName: "helloFileName")
         */
        demo.archive(fileName: "helloFileName")
    }

    
    @IBAction func decode(_ sender: Any) {
        let demo = Demo.unarchive(fileName: "helloFileName") as? Demo
        output.text = demo?.content
        print("name:\(demo?.name ?? ""), age:\(demo?.age ?? 0), gender:\(demo?.gender ?? false)")
    }
}
