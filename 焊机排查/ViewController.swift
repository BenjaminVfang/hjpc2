//
//  ViewController.swift
//  焊机排查
//
//  Created by 方振宇 on 2016/11/21.
//  Copyright © 2016年 方振宇. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var searchtext: UITextField!
    @IBOutlet weak var tableview: UITableView!
    var result1:[[String:Any]]!
    let da:sqlite=sqlite()
    var isFirstResponderzdy: Bool=true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let _=result1{
            return result1.count
        }else{
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell=UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier:"cell")
                if let _=result1{
                    let date1=result1[indexPath.row]
                    cell.textLabel?.text=date1["设备编号"] as? String
                    cell.detailTextLabel?.text = date1["状态"] as? String
                    if date1["状态"] as? String=="未登记"{
                        cell.backgroundColor=UIColor(colorLiteralRed: 160/255.0, green: 160/255.0, blue: 160/255.0, alpha: 1)
                        cell.detailTextLabel?.textColor=UIColor(colorLiteralRed: 60/255.0, green: 60/255.0, blue: 60/255.0, alpha: 1)
                    }else if date1["状态"] as? String=="已登记"{
                        cell.detailTextLabel?.textColor=UIColor.blue
                    }
                }
        return cell;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if searchtext.text != nil{
            search()}
        return true
    }
    
    @IBAction func search() {
        result1=da.search(searchtext.text!)
        tableview.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        performSegue(withIdentifier: "toDetail", sender: result1[indexPath.row])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepareforsegue")
        if segue.identifier=="toDetail"{
            let destination:DetailViewController=segue.destination as! DetailViewController
            destination.detail = sender as AnyObject?
        }else if segue.identifier=="newitem"{
            let destination:DetailViewController=segue.destination as! DetailViewController
            destination.isAddNewItem = true
        }
    }
    override func viewWillAppear(_ animated: Bool){
        if isFirstResponderzdy{
            isFirstResponderzdy=false
        }
        else{
            search()
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle{
        return UITableViewCellEditingStyle.delete
    }
   
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        var message1=""
        if let _=self.result1{
             message1 = result1[indexPath.row]["设备编号"] as! String
        }
        
        let alert=UIAlertController(title: "注意", message: "确认删除\(message1)", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "删除", style: UIAlertActionStyle.destructive){
            (UIAlertAction) -> Swift.Void in
            print("确认删除")
            if let _=self.result1{
                let id = self.result1[indexPath.row]["ID"] as! Int
//                self.tableview.reloadData()
                self.result1.remove(at: indexPath.row)
                self.tableview.deleteRows(at: [indexPath], with: .fade)
                self.da.delete(id: id)
            }
            
        }
            alert.addAction(deleteAction)
        let cancelAction=UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
   
        
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?{
        return "删除"
    }
}

