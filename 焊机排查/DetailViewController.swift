//
//  DetailViewController.swift
//  焊机排查
//
//  Created by 方振宇 on 2016/11/21.
//  Copyright © 2016年 方振宇. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UITextFieldDelegate {
    var detail:AnyObject?
    @IBOutlet weak var stateplain: UISegmentedControl!
    @IBOutlet weak var statetext: UITextField!
    @IBOutlet weak var sbbh: UITextField!
    @IBOutlet weak var sbmc: UITextField!
    @IBOutlet weak var dlb1: UITextField!
    @IBOutlet weak var dyb1: UITextField!
    @IBOutlet weak var dlb2: UITextField!
    @IBOutlet weak var dyb2: UITextField!
    @IBOutlet weak var didian: UITextField!
    @IBOutlet weak var beizhu: UITextView!
    var ID:Int = 0
    var s:[String:UITextField?]!
    override func viewDidLoad() {
        super.viewDidLoad()
        if isAddNewItem {
            s=["状态":statetext,"设备编号":sbbh,"设备名称":sbmc,"电流表1":dlb1,"电压表1":dyb1,"电流表2":dlb2,"电压表2":dyb2,"地点":didian]
        }else
        if let ss = detail{
            s=["状态":statetext,"设备编号":sbbh,"设备名称":sbmc,"电流表1":dlb1,"电压表1":dyb1,"电流表2":dlb2,"电压表2":dyb2,"地点":didian]

             ID = ss["ID"] as! Int
            print(ID)
        navigationItem.title=ss["设备编号"] as? String
//            statetext.text=ss["状态"] as? String
//            sbbh.text=ss["设备编号"] as? String
//            sbmc.text=ss["设备名称"] as? String
            if ss["状态"] as? String=="未登记"{
                stateplain.selectedSegmentIndex=0
                statetext.textColor=UIColor.gray
            }else {
                stateplain.selectedSegmentIndex=1
                statetext.textColor=UIColor.blue
            }
            
            func ys(string:String,textfield:UITextField!){
                if ss[string] is NSNumber{
                    if ss[string] as! Int == 0{
                        textfield.text=""
                    }else{
                        textfield.text=String(describing: ss[string] as! Int)
                    }
                }else{
                textfield.text=ss[string] as? String
                }
            }
            for (i,j)in s{
                ys(string: i, textfield: j)
            }
            beizhu.text=ss["备注"] as? String
        // Do any additional setup after loading the view.
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeState(_ sender: UISegmentedControl) {
        let currentDate = Date()
        let dateformatter = DateFormatter()
        dateformatter.locale=Locale.current
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let stringDate = dateformatter.string(from: currentDate)
        if sender.selectedSegmentIndex==0{
            statetext.text="未登记"
            statetext.textColor=UIColor.gray
            beizhu.text=beizhu.text!+"状态于"+stringDate+"将已登记修改为未登记;\n"
        }else{
            statetext.text="已登记"
            statetext.textColor=UIColor.blue
            beizhu.text=beizhu.text!+"状态于"+stringDate+"由未登记修改为已登记;\n"
        }
        
    }
    let d:sqlite=sqlite()
    var isAddNewItem=false
    @IBAction func save(_ sender: Any) {
        if isAddNewItem {
            d.add(sbbh.text!,sbmc.text!, statetext.text!, dlb1.text!, dyb1.text!, dlb2.text!, dyb2.text!, didian.text! , beizhu.text!)
        }else{
        d.update(ID,sbbh.text!,sbmc.text!,statetext.text!, dlb1.text!, dyb1.text!, dlb2.text!, dyb2.text!, didian.text!, beizhu.text!)
        }
    }
    var oldvalue:String=""
    func textFieldDidBeginEditing(_ textField: UITextField){
      oldvalue =  textField.text!
    }
   
    
    func textFieldDidEndEditing(_ textField: UITextField){
        if oldvalue != textField.text!{
            var textFieldtitle:String=""
            for(i,j)in s{
                if j! == textField{
                    textFieldtitle=i
                    break
                }
            }
            
            let currentDate = Date()
            let dateformatter = DateFormatter()
            dateformatter.locale=Locale.current
            dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let stringDate = dateformatter.string(from: currentDate)
        
            
            beizhu.text=beizhu.text!+textFieldtitle+"于"+stringDate+"由"+oldvalue+"修改为"+textField.text!+";\n"
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        IQKeyboardManager.sharedManager().enable=true
    }
   
}
