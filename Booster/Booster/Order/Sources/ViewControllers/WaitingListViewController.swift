//
//  WaitingListViewController.swift
//  Booster
//
//  Created by 김태훈 on 2020/07/06.
//  Copyright © 2020 kimtaehoon. All rights reserved.
//

import UIKit
import MobileCoreServices
import QuickLookThumbnailing
class WaitingListViewController: UIViewController {
  var refreshCollectionView = UIRefreshControl()
  var orderIdx:Int = -1
  var storeInfo:simpleStoreData?
  @objc func refresh(){
    self.view.layoutIfNeeded()
    refreshCollectionView.endRefreshing()
  }
  
  @IBOutlet weak var storeName: UILabel!
  @IBOutlet weak var storeAddress: UILabel!
  var tmpImg = UIImage()
  var fileList:[FileInformation] = []
  var fileDataList :[fileData] = []
  //var file = FileInformation(fileImg: UIImage(), fileName: "")
  @IBOutlet weak var totalPrice: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var waitingListCollectionView: UICollectionView!
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    setWaitingListCV()
    storeName.text = storeInfo?.store_name
    storeAddress.text = storeInfo?.store_address
    waitingListCollectionView.refreshControl = refreshCollectionView
    refreshCollectionView.addTarget(self, action: #selector(refresh), for: .valueChanged)
    self.navigationController?.isNavigationBarHidden = true
    //loadWaitingView()
  }
  func loadWaitingView(orderIdx:Int){
    waitListService.shared.waitlist(orderIdx: orderIdx){
      networkResult in
      switch networkResult{
      case .success(let data):
        guard let data = data as? waitCellData else {return}
        var tempFilelist:[fileData] = []
        
        if let file =  data.file_info{
          for i in 0..<file.count{
            tempFilelist.append(fileData(file_idx: file[i].file_idx, file_name: file[i].file_name, file_extension: file[i].file_extension, file_path: file[i].file_path))
          }
          self.fileDataList = tempFilelist
          tempFilelist.removeAll()
        }
        else{
          self.fileDataList.removeAll()
          tempFilelist.removeAll()
        }
        self.totalPrice.text = String(data.order_price) + " P"
      case .requestErr(let messgae) : print(messgae)
      case .networkFail: print("networkFail")
      case .serverErr : print("serverErr")
      case .pathErr : print("pathErr")
      }
    }
  }
  
  func goBackToStoreSelection(){
    for i in 0..<fileDataList.count{
      clearFileDir(filename: fileDataList[i].file_name + "." + fileDataList[i].file_extension)
    }
    self.navigationController?.popViewController(animated: true)
    
  }
  
  @IBAction func closeBtn(_ sender: Any) {
    goBackToStoreSelection()
    
  }
  @IBAction func cangeCurrentStore(_ sender: Any) {
    goBackToStoreSelection()
  }
  
  @IBAction func goPayView(_ sender: Any) {
    let orderHsStoryboard = UIStoryboard.init(name:"OrderHs",bundle: nil)
    guard let payView = orderHsStoryboard.instantiateViewController(identifier: "PayViewController") as? PayViewController else {return}
    payView.orderIndex = self.orderIdx
    self.navigationController?.pushViewController(payView, animated: true)
  }
  
  func setWaitingListCV(){
    waitingListCollectionView.delegate = self
    waitingListCollectionView.dataSource = self
  }
  @IBOutlet weak var orderBtnAppear: NSLayoutConstraint!
  func orderViewAppear(){
    self.view.layoutIfNeeded()
    orderBtnAppear.constant = 162
  }
  func orderViewDisappear(){
    orderBtnAppear.constant = 0
  }
  
  func clearFileDir(filename:String){
    
    let filethumbnail = String(filename.split(separator: ".").first!) + "_thumbnail.jpg"
    let curDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    
    let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let thumbnail = dir.appendingPathComponent(filethumbnail)
    let file = dir.appendingPathComponent(filename)
    if FileManager.default.fileExists(atPath: dir.path){
      print("파일이 있다네요")
      do {
        try FileManager.default.removeItem(at: file)
      }
      catch {
        print("삭제가 안되나요")
      }
      do {
        try FileManager.default.removeItem(at: thumbnail)
      }
      catch {
        print("썸네일 삭제 실패")
      }
    }
    
  }
  
  //  func thumbNailGenerator(_ fileURL:URL, thumbnailSize:CGSize) -> UIImage?{
  //
  //  }
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  func getFileFromLocal(){
    let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content"], in: .import)
    documentPicker.delegate = self
    documentPicker.allowsMultipleSelection = false
    self.present(documentPicker, animated: true)
    
    //    print(fileList)
  }
}
extension WaitingListViewController:UIDocumentPickerDelegate {
  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    guard let selectedFileURL = urls.first else {
      return
    }
    let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let sandboxFileURL = dir.appendingPathComponent(selectedFileURL.lastPathComponent)
    if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
      print("Already exists!")
      let alert = UIAlertController(title: "", message: "이미 가져온 파일입니다.", preferredStyle: UIAlertController.Style.alert)
      let confirm = UIAlertAction(title: "확인", style: .default, handler : nil)
      
      alert.addAction(confirm)
      present(alert,animated: true)
    }
    else {
      do {
        try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
      }
      catch {
        print("에러났다이거봐라 : \(error)")
      }
      //여기서 파일 서버에 업로드
      let size:CGSize = CGSize(width: 38, height: 51)
      let scale = UIScreen.main.scale
      let request = QLThumbnailGenerator.Request(fileAt: sandboxFileURL, size: size, scale: scale, representationTypes: .thumbnail)
      let generator = QLThumbnailGenerator.shared
      var thumbNail = UIImage()
      var thumbNailData = Data()
      let uploadfile = sandboxFileURL.lastPathComponent.split(separator: ".")
      let filename = String(uploadfile[0]) + "_thumbnail.jpg"
      var thumbNailURL:URL?
      print("local에서 불러온 파일 : ")
      //      print(sandboxFileURL)
      print(sandboxFileURL.lastPathComponent)
      //파일 업로드 하기
      generator.generateRepresentations(for: request) { (thumbnail, _, error) in
        DispatchQueue.main.async {
          if thumbnail != nil{
            thumbNail = thumbnail!.uiImage
            print("썸네일 있는 파일")
            self.waitingListCollectionView.reloadData()
            thumbNailData = thumbNail.jpegData(compressionQuality: 0.8) ?? Data()
            try? thumbNailData.write(to: dir.appendingPathComponent(filename))
            let fileURL = dir.appendingPathComponent(filename)
            uploadFileService.shared.uploadfile(fileData: sandboxFileURL, thumbNail: fileURL, orderIdx: self.orderIdx){
              networkResult in
              switch networkResult{
              case .success(let fileIndexData) :
                
                guard let fileIndexData = fileIndexData as? fileIdx else {return}
                let filename:String = String(sandboxFileURL.lastPathComponent.split(separator: ".")[0])
                let fileExtension:String = String(sandboxFileURL.lastPathComponent.split(separator: ".")[1])
                self.fileDataList.append(fileData(file_idx: fileIndexData.fileIdx, file_name: filename, file_extension: fileExtension, file_path: sandboxFileURL))
                self.viewDidLoad()
                self.waitingListCollectionView.reloadData()
                self.loadWaitingView(orderIdx:self.orderIdx )
                
              case .requestErr(let messgae) :
                self.clearFileDir(filename:sandboxFileURL.lastPathComponent)
                
              case .networkFail: print("networkFail")
              case .serverErr : print("serverErr")
              case .pathErr : print("pathErr")
              }
            }
            
            
          }
          else if  thumbnail == nil || error != nil{
            
            print("썸네일 없는 파일")
            print("error : \(String(describing: error))")
            self.waitingListCollectionView.reloadData()
          }
        }
        //self.tmpImg = thumbnail?.uiImage as! UIImage
      }
      print(thumbNailURL = dir.appendingPathComponent(filename))
      print(sandboxFileURL)
      
    }
    self.waitingListCollectionView.reloadData()
    print("파일 가져오고 다시,,")
  }
  
  
  
  
  
}


//    guard let url = sandboxFileURL else {
//      assert(false, "The URL can't be nil")
//      return
//    }
//    guard let url = Bundle.main.url(forResource: "test", withExtension: "pdf") else {
//      return
//    }


//    guard let test = self.storyboard?.instantiateViewController(withIdentifier: "optionViewTest") else {return}
//    self.present(test,animated: true)


extension WaitingListViewController:UICollectionViewDelegate{
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return fileDataList.count + 1
  }
  
}

extension WaitingListViewController:UICollectionViewDataSource{
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    print(orderIdx)
    self.viewDidLoad()
    
    
    
    if fileDataList.count == 0 {
      orderViewDisappear()
    }
    else {
      orderViewAppear()
    }
    
    if indexPath.row == fileDataList.count{
      guard let fileAdd:AddFileCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: AddFileCollectionViewCell.identifier, for: indexPath)as? AddFileCollectionViewCell else {
        return UICollectionViewCell()}
      
      
      fileAdd.addFileBtn.tag = indexPath.row
      fileAdd.addFileBtn.addTarget(self, action: #selector(getFile(sender:)), for: .touchUpInside)
      return fileAdd
      
      
    }
    else{
      guard let fileCell:WaitCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: WaitCollectionViewCell.identifier, for:indexPath) as? WaitCollectionViewCell else {
        return UICollectionViewCell()}
      //fileCell.fileName.text = "ddd"
      let thumbnail:String = String(fileDataList[indexPath.row].file_path.lastPathComponent.split(separator: ".").first!) + "_thumbnail.jpg"
      
      
      let thumbnailURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!).appendingPathComponent(thumbnail)
      
      fileCell.preViewImg.setImage(UIImage(contentsOfFile: thumbnailURL.path), for: .normal)
      fileCell.fileName.text = fileDataList[indexPath.row].file_name 
      //fileCell.preViewImg.setImage(fileList[indexPath.row].fileImg, for: .normal)
      fileCell.fileExtention.text = "." + fileDataList[indexPath.row].file_extension
      fileCell.checkOption.tag = indexPath.row
      fileCell.checkOption.addTarget(self, action: #selector(popupOption(sender:)), for: .touchUpInside)
      fileCell.deleteCell.tag = indexPath.row
      fileCell.deleteCell.addTarget(self, action: #selector(deleteCell(sender:)), for: .touchUpInside)
      fileCell.changeOption.tag = indexPath.row
      fileCell.changeOption.addTarget(self, action: #selector(optionChange(sender:)), for: .touchUpInside)
      return fileCell
      
    }
    
    
  }
  @objc func optionChange(sender:UIButton){
    let fileidx:Int = fileDataList[sender.tag].file_idx
    
    OptionService.shared.getOption(fileidx:fileidx) {networkResult in
      switch networkResult {
      case .success(let optionList):
        guard let optionList = optionList as? OptionList else {return}
        let orderHsStoryBoard = UIStoryboard.init(name: "OrderHs", bundle: nil)
        let orderHsStoryboard = UIStoryboard.init(name:"OrderHs",bundle: nil)
        guard let optView = orderHsStoryboard.instantiateViewController(identifier: "OptionViewController") as? OrderHsViewController else {return}
        
        
        optView.fileIdx = fileidx
        optView.optionListFromServer = optionList
        
        self.navigationController?.pushViewController(optView, animated: true)
      case .requestErr(let message):
        guard let message = message as? String else {return}
        let alertViewController = UIAlertController(title: "로그인 실패", message: message,
                                                    preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alertViewController.addAction(action)
        self.present(alertViewController, animated: true, completion: nil)
      case .pathErr: print("path")
      case .serverErr: print("serverErr")
      case .networkFail: print("networkFail")
      }
    }
  }
  @objc func popupOption(sender:UIButton){
    let fileidx:Int = fileDataList[sender.tag].file_idx
    OptionService.shared.getOption(fileidx:fileidx) {networkResult in
      switch networkResult {
      case .success(let optionList):
        guard let optionList = optionList as? OptionList else {return}
        let orderHsStoryBoard = UIStoryboard.init(name: "OrderHs", bundle: nil)
        guard let showOptionView = orderHsStoryBoard.instantiateViewController(identifier: "showOptionViewController") as? ShowOptionViewController else {return}
        showOptionView.modalPresentationStyle = .overCurrentContext
        self.present(showOptionView, animated: false, completion: nil)
        print(optionList)
        showOptionView.fileColor.text = optionList.file_color
        showOptionView.fileDirection.text = optionList.file_direction
        showOptionView.fileSidedType.text = optionList.file_sided_type
        showOptionView.fileCollect.text = String(optionList.file_collect)
        showOptionView.fileRange.text = optionList.file_range
        showOptionView.fileCopyNumber.text = String(optionList.file_copy_number)
        
      case .requestErr(let message):
        guard let message = message as? String else {return}
        let alertViewController = UIAlertController(title: "로그인 실패", message: message,
                                                    preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alertViewController.addAction(action)
        self.present(alertViewController, animated: true, completion: nil)
      case .pathErr: print("path")
      case .serverErr: print("serverErr")
      case .networkFail: print("networkFail")
      }
    }
  }
  @objc func getFile(sender:UIButton){
    getFileFromLocal()
  }
  @objc func deleteCell(sender: UIButton){
    let alert = UIAlertController(title: "", message: "파일을 삭제하겠습니까?", preferredStyle: UIAlertController.Style.alert)
    let no = UIAlertAction(title: "Cancel", style: .default, handler : nil)
    let yes = UIAlertAction(title: "OK", style: .default) { (action) in
      print(self.fileDataList.count)
      print(sender.tag)
      if(self.fileDataList[sender.tag].file_extension == "jpeg"){
        self.fileDataList[sender.tag].file_extension = "jpg"
      }
      self.clearFileDir(filename: self.fileDataList[sender.tag].file_name + "."+self.fileDataList[sender.tag].file_extension)
      deleteFileService.shared.filedeleter(fileidx: self.fileDataList[sender.tag].file_idx){
        networkResult in
        switch networkResult{
        case .success(let message): print(message)
        case .requestErr(let messgae) : print(messgae)
        case .networkFail: print("networkFail")
        case .serverErr : print("serverErr")
        case .pathErr : print("pathErr")
        }
      }
      self.fileDataList.remove(at: sender.tag)
      self.waitingListCollectionView.reloadData()
    }
    alert.addAction(yes)
    alert.addAction(no)
    present(alert,animated: true, completion: nil)
  }
  
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    //print("파일 불러오기")
    
    //collectionView.insertItems(at: [indexPath])
    //collectionView.reloadItems(at:collectionView.indexPathsForVisibleItems)
    //collectionView.reloadData()
    if indexPath.row == fileDataList.count {
      getFileFromLocal()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexpath:IndexPath) ->UICollectionReusableView{
    var header : WaitCollectionViewHeader!
    if kind == UICollectionView.elementKindSectionHeader{
      header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "waitingHeader", for: indexpath) as? WaitCollectionViewHeader
      header.waitingHeaderTitle.text = "파일 목록"
      
    }
    return header
    
  }
}
extension WaitingListViewController:UICollectionViewDelegateFlowLayout{
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width:self.view.frame.size.width
      , height:self.view.frame.size.width * 73.0 / 375.0)
  }
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets{
    if section == 0 {
      return UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
    }
    else{
      return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}

