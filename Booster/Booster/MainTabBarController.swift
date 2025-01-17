//
//  MainTabBarController.swift
//  Booster
//
//  Created by 김태훈 on 2020/07/06.
//  Copyright © 2020 kimtaehoon. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController ,UITabBarControllerDelegate{

  var univIdx:Int?
    override func viewDidLoad() {
      super.viewDidLoad()
      self.delegate = self
      setTabBar()
      
      // Do any additional setup after loading the view.
    }
    func setTabBar() {
      self.tabBar.backgroundImage = UIImage(named: "bgTab")
      
      var tempsize:CGSize = self.tabBar.bounds.size
      print(tempsize)
      self.tabBar.bounds.size = self.tabBar.sizeThatFits(tempsize)
      print(tabBar.frame)
      print(self.tabBar.bounds.size)
      let homeStoryboard = UIStoryboard.init(name:"Home",bundle: nil)
        guard let firstTab = homeStoryboard.instantiateViewController(identifier: "HomeViewController") as? HomeViewController else{return}

        firstTab.tabBarItem.title = "홈"
      firstTab.tabBarItem.image = UIImage(named: "iconHomeInact")?.withRenderingMode(.alwaysOriginal)
      
      firstTab.tabBarItem.selectedImage = UIImage(named: "iconHomeAct")?.withRenderingMode(.alwaysTemplate)
        
        let searchStoryboard = UIStoryboard.init(name:"Search",bundle: nil)
        guard let secondTab = searchStoryboard.instantiateViewController(identifier: "SearchViewController") as? SearchViewController else{return}
      secondTab.univIdx = univIdx
        secondTab.tabBarItem.title = "매장"
      secondTab.tabBarItem.image = UIImage(named: "iconStoreInact")?.withRenderingMode(.automatic)
      
      //secondTab.tabBarItem.accessibilityFrame = CGRect()
        secondTab.tabBarItem.selectedImage = UIImage(named: "iconStoreAct")?.withRenderingMode(.alwaysTemplate)
        
        let orderStoryboard = UIStoryboard.init(name:"Order",bundle: nil)
        guard let thirdTab = orderStoryboard.instantiateViewController(identifier: "OrderViewController") as? UINavigationController else{return}
      
        thirdTab.tabBarItem.title = ""
        thirdTab.tabBarItem.image = UIImage(named: "iconRocket")?.withRenderingMode(.alwaysOriginal)
      thirdTab.tabBarItem.imageInsets.top = 0
        //thirdTab.tabBarItem.selectedImage = UIImage(named: "btnTab3Active")?.withRenderingMode(.alwaysTemplate)
        
        let statusStoryboard = UIStoryboard.init(name:"StatusHs",bundle: nil)
        guard let fourthTab = statusStoryboard.instantiateViewController(identifier: "StatusViewController") as? StatusHsViewController else{return}
        
        fourthTab.tabBarItem.title = "주문현황"
        fourthTab.tabBarItem.image = UIImage(named: "iconHistoryInact")?.withRenderingMode(.alwaysOriginal)
        fourthTab.tabBarItem.selectedImage = UIImage(named: "iconHistoryAct")?.withRenderingMode(.alwaysTemplate)

        let myPageStoryboard = UIStoryboard.init(name:"MyPageHs",bundle: nil)
        guard let fifthTab = myPageStoryboard.instantiateViewController(identifier: "MyPageHsViewController") as? MyPageHsViewController else{return}

        fifthTab.tabBarItem.title = "마이페이지"
        fifthTab.tabBarItem.image = UIImage(named: "iconMypageInact")?.withRenderingMode(.alwaysOriginal)
        fifthTab.tabBarItem.selectedImage = UIImage(named: "iconMypageAct")?.withRenderingMode(.alwaysTemplate)

        let tabs = [firstTab, secondTab, thirdTab,fourthTab,fifthTab]
      self.setViewControllers(tabs, animated: false)
        self.selectedViewController = firstTab

    }
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    let itemIndex = tabBarController.selectedIndex
    if (itemIndex == 0 ){
      let homeStoryboard = UIStoryboard.init(name:"Home",bundle: nil)
             guard let firstTab = homeStoryboard.instantiateViewController(identifier: "HomeViewController") as? HomeViewController else{return}
      print(firstTab.HomeLottieVie?.subviews)

      firstTab.homeLottieAnimation.reloadImages()
      firstTab.homeLottieAnimation.play()
      firstTab.homeLottieAnimation.removeFromSuperview()
      firstTab.viewDidLoad()

    }
    if(itemIndex == 2){
      tabBarController.tabBar.isHidden = true
      //tabBarController.viewControllers![2].reloadInputViews()
      let orderStoryboard = UIStoryboard.init(name:"Order",bundle: nil)
      guard let thirdTab = orderStoryboard.instantiateViewController(identifier: "orderView") as? OrderViewController else{return}
      print("jj")
      thirdTab.viewDidLoad()
      print("DD")
    }
    
    else{
      tabBarController.tabBar.isHidden = false
    }
  }
  
  func addHeightConstraintToTabbar() -> Void {
    let heightConstant:CGFloat = self.view.safeAreaInsets.bottom + 101.0
    self.tabBar.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
  }
  
  /*
   // MARK: - Navigation
   CategoryVC
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
extension UITabBar{
  override open func sizeThatFits(_ size: CGSize) -> CGSize {
      super.sizeThatFits(size)
      var sizeThatFits = super.sizeThatFits(size)
      sizeThatFits.height = 101
      return sizeThatFits
  }
}
