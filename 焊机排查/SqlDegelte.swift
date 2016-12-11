//
//  SqlDegelte.swift
//  MyfirstApp
//
//  Created by 方振宇 on 15/12/29.
//  Copyright © 2015年 fzy. All rights reserved.
//

import Foundation

class sqlite{
    var date:SQLiteDB!
    init(){
        date=SQLiteDB.sharedInstance
    }
    func search(_ text:String)->[[String:Any]]{

        
    let result = date.query(sql: "select * from 电流电压表排查 where 设备编号 like'%\(text)%'or 设备名称 like '%\(text)%'")
        print(text)
        return result as [[String : Any]]
    }

    func update(_ idnumber:Int,_ sbbh:String,_ sbmc:String,_ state:String,_ dlb1:String,_ dyb1:String,_ dlb2:String ,_ dyb2:String,_ dd:String, _ beizhu:String){
        
     let _ = date.execute(sql: "update 电流电压表排查 set  设备编号='\(sbbh)',设备名称='\(sbmc)',状态='\(state)',电流表1='\(dlb1)',电压表1='\(dyb1)',电流表2='\(dlb2)',电压表2='\(dyb2)',地点='\(dd)' ,备注='\(beizhu)' where ID ='\(idnumber)'")
    }
    func add(_ sbbh:String,_ sbmc:String,_ state:String,_ dlb1:String,_ dyb1:String,_ dlb2:String ,_ dyb2:String,_ dd:String, _ beizhu:String){
        
        let _ = date.execute(sql: "insert into 电流电压表排查(状态,设备编号,设备名称,电流表1,电压表1,电流表2,电压表2,地点,备注 ) values('\(state)','\(sbbh)','\(sbmc)','\(dlb1)','\(dyb1)','\(dlb2)','\(dyb2)','\(dd)','\(beizhu)' )")

    }
    func delete(id:Int) {
        let _ = date.execute(sql: "delete from 电流电压表排查 where ID=\(id)")
        
    }
    

}
