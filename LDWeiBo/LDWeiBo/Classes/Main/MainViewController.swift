//
//  MainViewController.swift
//  LDWeiBo
//
//  Created by ld on 2023/2/23.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // 1.获取json文件路径
        guard let jsonPath = Bundle.main.path(forResource: "MainVCSettings.json", ofType: nil) else {
            print("没有获取到对应的文件路径")
            return
        }
        
        // 2.读取json文件中的内容
 
        guard let jsonData = NSData(contentsOfFile: jsonPath) else {
            print("没有获取到json文件中数据")
            return
            
        }
        
        // 3.将Data转成数组
        
        // 如果在调用系统某一个方法时,该方法最后有一个throws.说明该方法会抛出异常.如果一个方法会抛出异常,那么需要对该异常进行处理
//        在swift中提供三种处理异常的方式
//           方式一:try方式 程序员手动捕捉异常
//        do {
//            try JSONSerialization.jsonObject(with: jsonData as Data)
//        } catch   {
//            // error异常的对象
//            print(error)
//        }
        
        // 方式二:try?方式(常用方式)系统帮助我们处理异常,如果该方法出现了异常,则该方法返回nil.如果没有异常,则返回对应的对象
//        guard let anyObject = try? JSONSerialization.jsonObject(with: jsonData as Data) else {
//            return
//
//        }
        
//    方式三:try!方法(不建议,非常危险) 直接告诉系统,该方法没有异常.注意:如果该方法出现了异常,那么程序会报错(崩溃)
        
//        let anyObject = try! JSONSerialization.jsonObject(with: jsonData as Data)
//
        
        guard let anyObject = try? JSONSerialization.jsonObject(with: jsonData as Data) else {
             return
            
        }
        
        guard let dictArray = anyObject as? [[String : AnyObject]] else {
            return
            
        }
        
        // 4.遍历字典,获取对应的信息
        for dict in dictArray {
            // 4.1.获取控制器的对应的字符串
            guard let vcName = dict["vcName"] as? String else {
                continue
            }
            
            // 4.2.获取控制器显示的title
            
            guard let title = dict["title"] as? String else {
                continue
                
            }
            
            // 4.3.获取控制器显示的图标名称
            guard let imageName = dict["imageName"] as? String else {
                continue
                
            }
            
            // 4.4.添加子控制器
            addChildViewController(childVcName: vcName, title: title, imageName: imageName)
            
        }
    }
      
    
    
    // swift支持方法的重载
    // 方法的重载:方法名称相同,但是参数不同. --> 1.参数的类型不同 2.参数的个数不同
    // private在当前文件中可以访问,但是其他文件不能访问
    
    private func addChildViewController(childVc : UIViewController, title : String, imageName : String)  {
        // 1.设置子控制器的属性
        childVc.title = title
        childVc.tabBarItem.image = UIImage(named: imageName)
        childVc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        
       // 2.包装导航栏控制器
        let childNav = UINavigationController(rootViewController: childVc)
        
        // 3.添加控制器
        addChild(childNav)
    }
    
    func addChildViewController(childVcName : String, title : String, imageName : String) {
        // 0.获取命名空间
        guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            print("没有获取命名空间")
            return
            
        }
        
        // 1.根据字符串获取对应的Class
        guard let chiidVcClass = NSClassFromString(nameSpace + "." + childVcName) else {
            print("没有获取到字符串对应的Class")
            return
            
        }
        
        // 2.将对应的AnyObject转成控制器的类型
        guard let childVcType = chiidVcClass as? UIViewController.Type else {
            print("没有获取对应控制器的类型")
            return
        }
        
        // 3.创建对应的控制器对象
        let childVc = childVcType.init()
        
        // 4.设置子控制器的属性
        childVc.title = title
        childVc.tabBarItem.image = UIImage(named: imageName)
        childVc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        
        // 5.包装导航栏控制器
        let childNav = UINavigationController(rootViewController: childVc)
        // 6.添加控制器
        addChild(childNav)
        
    }
  

}
