//
//  Datas.swift
//  Booster
//
//  Created by 김태훈 on 2020/07/14.
//  Copyright © 2020 kimtaehoon. All rights reserved.
//

import Foundation
struct LogInData : Codable{
  var status : Int
  var success:Bool
  var message : String
  var data : TokenData?
  
  enum CodingKeys:String, CodingKey {
    case status = "status"
    case success = "success"
    case message = "message"
    case data = "data"
  }
  init(from decoder: Decoder) throws{
    let values = try decoder.container(keyedBy: CodingKeys.self)
    status = (try? values.decode(Int.self, forKey: .status)) ?? -1
    success = (try? values.decode(Bool.self, forKey: .success)) ?? false
    message = (try? values.decode(String.self, forKey: .message)) ?? ""
    data = (try? values.decode(TokenData.self, forKey: .data)) ?? TokenData.init(university_idx: -1, accessToken: "")
    }
  }

struct TokenData:Codable{
  var university_idx : Int
  var accessToken : String
}

struct IDCheckData : Codable {
  var status : Int
  var success:Bool
  var message : String
  
  enum CodingKeys:String, CodingKey {
    case status = "status"
    case success = "success"
    case message = "message"
  }
  init(from decoder: Decoder) throws{
    let values = try decoder.container(keyedBy: CodingKeys.self)
    status = (try? values.decode(Int.self, forKey: .status)) ?? -1
    success = (try? values.decode(Bool.self, forKey: .success)) ?? false
    message = (try? values.decode(String.self, forKey: .message)) ?? ""
    }
}

struct SignUpData : Codable {
  var status : Int
  var success:Bool
  var message : String
  
  enum CodingKeys:String, CodingKey {
    case status = "status"
    case success = "success"
    case message = "message"
  }
  init(from decoder: Decoder) throws{
    let values = try decoder.container(keyedBy: CodingKeys.self)
    status = (try? values.decode(Int.self, forKey: .status)) ?? -1
    success = (try? values.decode(Bool.self, forKey: .success)) ?? false
    message = (try? values.decode(String.self, forKey: .message)) ?? ""
    }
}

struct StoreListData : Codable {
  var status : Int
  var success:Bool
  var message : String
  var data : [StoreData]?
  enum CodingKeys:String, CodingKey {
    case status = "status"
    case success = "success"
    case message = "message"
    case data = "data"
  }
  init(from decoder: Decoder) throws{
  let values = try decoder.container(keyedBy: CodingKeys.self)
  status = (try? values.decode(Int.self, forKey: .status)) ?? -1
  success = (try? values.decode(Bool.self, forKey: .success)) ?? false
  message = (try? values.decode(String.self, forKey: .message)) ?? ""
    data = (try? values.decode([StoreData].self, forKey: .data)) ?? [StoreData.init()]
  }
}


struct StoreData : Codable{
  var store_idx:Int
  var store_name: String
  var store_image:URL
  var store_location:String
  var price_color_double : Int
  var price_color_single : Int
  var price_gray_double : Int
  var price_gray_single : Int
  var store_x_location:Double
  var store_y_location:Double
  var store_double_sale:String
  var store_favorite:Int
  var store_open:Int
  
  init(store_idx:Int = -1, store_name:String = "", store_image:URL = URL(fileURLWithPath: ""), store_location:String = "", price_color_double:Int = 0, price_color_single:Int = 0, price_gray_double:Int = 0, price_gray_single:Int = 0, store_x_location:Double = 0, store_y_location:Double = 0, store_double_sale: String = "", store_favorite:Int = 0, store_open:Int = 0){
    self.store_idx = store_idx
    self.store_name = store_name
    self.store_image = store_image
    self.store_location = store_location
    self.price_color_double = price_color_double
    self.price_color_single = price_color_single
    self.price_gray_double = price_gray_double
    self.price_gray_single = price_gray_single
    self.store_x_location = store_x_location
    self.store_y_location = store_y_location
    self.store_double_sale = store_double_sale
    self.store_favorite = store_favorite
    self.store_open = store_open
  }
}





struct univListData : Codable {
  var status : Int
  var success:Bool
  var message : String
  var data : [univData]?
  enum CodingKeys:String, CodingKey {
    case status = "status"
    case success = "success"
    case message = "message"
    case data = "data"
  }
  init(from decoder: Decoder) throws{
  let values = try decoder.container(keyedBy: CodingKeys.self)
  status = (try? values.decode(Int.self, forKey: .status)) ?? -1
  success = (try? values.decode(Bool.self, forKey: .success)) ?? false
  message = (try? values.decode(String.self, forKey: .message)) ?? ""
    data = (try? values.decode([univData].self, forKey: .data)) ?? [univData.init()]
  }
}

struct univData:Codable{
  var univ_idx:Int
  var univ_name:String
  var univ_address:String
  var univ_line:Int
  init(univ_idx:Int = 0,univ_name:String = "" ,univ_address:String = "" ,univ_line:Int = 0){
    self.univ_idx = univ_idx
    self.univ_name = univ_name
    self.univ_address = univ_address
    self.univ_line = univ_line
  }
}
struct favoriteData : Codable {
  var status : Int
  var success:Bool
  var message : String
  
  enum CodingKeys:String, CodingKey {
    case status = "status"
    case success = "success"
    case message = "message"
  }
  init(from decoder: Decoder) throws{
    let values = try decoder.container(keyedBy: CodingKeys.self)
    status = (try? values.decode(Int.self, forKey: .status)) ?? -1
    success = (try? values.decode(Bool.self, forKey: .success)) ?? false
    message = (try? values.decode(String.self, forKey: .message)) ?? ""
    }
}


struct orderListData:Codable{
  var status:Int
  var success:Bool
  var message:String
  var data:OrderData?
  enum CodingKeys:String, CodingKey {
    case status = "status"
    case success = "success"
    case message = "message"
    case data = "data"
  }
  init(from decoder: Decoder) throws{
  let values = try decoder.container(keyedBy: CodingKeys.self)
  status = (try? values.decode(Int.self, forKey: .status)) ?? -1
  success = (try? values.decode(Bool.self, forKey: .success)) ?? false
  message = (try? values.decode(String.self, forKey: .message)) ?? ""
  data = (try? values.decode(OrderData.self, forKey: .data)) ?? OrderData()
  }
}
struct OrderData:Codable{
  var favorite_store : [simpleStoreData]?

  var recent_order_store:simpleStoreData?
  var store_all : [simpleStoreData]
  init(recent_order_store:simpleStoreData = simpleStoreData(),favorite_store : [simpleStoreData]=[simpleStoreData()],store_all : [simpleStoreData]=[simpleStoreData()]){
    self.recent_order_store = recent_order_store
    self.favorite_store = favorite_store
    self.store_all = store_all
  }
}
struct simpleStoreData:Codable {
  var store_idx : Int
  var store_name : String
  var store_image : URL
  var store_address : String
  init(store_idx : Int = -1,store_name :String = "",store_image : URL = URL(fileURLWithPath: ""),store_address : String = ""){
    self.store_idx = store_idx
    self.store_name = store_name
    self.store_image = store_image
    self.store_address = store_address
  }
}
struct orderBtnClickedData:Codable{
  var status:Int
  var success:Bool
  var message:String
  var data:orderIdx?
  init(from decoder: Decoder) throws{
   let values = try decoder.container(keyedBy: CodingKeys.self)
   status = (try? values.decode(Int.self, forKey: .status)) ?? -1
   success = (try? values.decode(Bool.self, forKey: .success)) ?? false
   message = (try? values.decode(String.self, forKey: .message)) ?? ""
     data = (try? values.decode(orderIdx.self, forKey: .data)) ?? nil
   }
}
struct orderIdx:Codable{
  var order_idx : Int
}
struct waitListData:Codable{
  var status:Int
  var success:Bool
  var message:String
  var data:waitCellData?
  enum CodingKeys:String, CodingKey {
    case status = "status"
    case success = "success"
    case message = "message"
    case data = "data"
  }
  init(from decoder: Decoder) throws{
  let values = try decoder.container(keyedBy: CodingKeys.self)
  status = (try? values.decode(Int.self, forKey: .status)) ?? -1
  success = (try? values.decode(Bool.self, forKey: .success)) ?? false
  message = (try? values.decode(String.self, forKey: .message)) ?? ""
    data = (try? values.decode(waitCellData.self, forKey: .data)) ?? nil
  }
}

struct waitCellData : Codable{
  var store_name:String
  var store_address:String
  var file_info:[fileData]?
  var order_price:Int
  init(store_name:String = "", store_address:String = "", file_info:[fileData] = [fileData()], order_price:Int = 0 ){
    self.store_name = store_name
    self.store_address = store_address
    self.file_info = file_info
    self.order_price = order_price
  }
}

struct fileData:Codable{
  var file_idx:Int
  var file_name:String
  var file_extension:String
  var file_path:URL
  init(file_idx:Int = -1,file_name:String = "",file_extension:String = "",file_path:URL = URL(fileURLWithPath: "")){
    self.file_idx = file_idx
    self.file_name = file_name
    self.file_extension = file_extension
    self.file_path = file_path
  }
}
struct fileUploadData: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: fileIdx?
}
struct fileIdx: Codable {
    var fileIdx: Int
  init(fileIdx:Int) {
    self.fileIdx = fileIdx
  }
}


struct fileDeleteData:Codable{
  let status: Int
  let success: Bool
  let message: String
  enum CodingKeys:String, CodingKey {
     case status = "status"
     case success = "success"
     case message = "message"
  }
  init(from decoder: Decoder) throws{
    let values = try decoder.container(keyedBy: CodingKeys.self)
    status = (try? values.decode(Int.self, forKey: .status)) ?? -1
    success = (try? values.decode(Bool.self, forKey: .success)) ?? false
    message = (try? values.decode(String.self, forKey: .message)) ?? ""
    }
}

          
struct HomeViewData:Codable{
  let status: Int
  let success: Bool
  let message: String
  let data:HomeInfo?
  enum CodingKeys:String, CodingKey {
     case status = "status"
     case success = "success"
     case message = "message"
    case data = "data"
  }
  init(from decoder: Decoder) throws{
    let values = try decoder.container(keyedBy: CodingKeys.self)
    status = (try? values.decode(Int.self, forKey: .status)) ?? -1
    success = (try? values.decode(Bool.self, forKey: .success)) ?? false
    message = (try? values.decode(String.self, forKey: .message)) ?? ""
    data = (try? values.decode(HomeInfo.self, forKey: .data)) ?? HomeInfo(home_state: -1, user_name: "")
    }
}
struct HomeInfo:Codable{
  let home_state:Int
  let user_name:String
}


struct OptionChangeData:Codable{
  let status: Int
  let success: Bool
  let message: String
  enum CodingKeys:String, CodingKey {
     case status = "status"
     case success = "success"
     case message = "message"
  }
  init(from decoder: Decoder) throws{
  let values = try decoder.container(keyedBy: CodingKeys.self)
  status = (try? values.decode(Int.self, forKey: .status)) ?? -1
  success = (try? values.decode(Bool.self, forKey: .success)) ?? false
  message = (try? values.decode(String.self, forKey: .message)) ?? ""
  }
}
struct StoreDetailViewLoadData:Codable{
  let status: Int
  let success: Bool
  let message: String
  let data:StoreDetailData?
  enum CodingKeys:String, CodingKey {
     case status = "status"
     case success = "success"
     case message = "message"
    case data = "data"
  }
  init(from decoder: Decoder) throws{
    let values = try decoder.container(keyedBy: CodingKeys.self)
    status = (try? values.decode(Int.self, forKey: .status)) ?? -1
    success = (try? values.decode(Bool.self, forKey: .success)) ?? false
    message = (try? values.decode(String.self, forKey: .message)) ?? ""
    data = (try? values.decode(StoreDetailData.self, forKey: .data)) ?? StoreDetailData()
    }
}



struct StoreDetailData:Codable{
  var store_image:URL
  var store_name: String
  var store_address:String
  var store_location:String
  var store_time_weekdays:String
  var store_time_saturday:String
  var store_time_sunday:String
  var store_phone_number:String
  var price_color_double : Int
  var price_color_single : Int
  var price_gray_double : Int
  var price_gray_single : Int
  var univ_line:Int
  var store_x_location:Double
  var store_y_location:Double
  var store_favorite:Int

  
  init(store_image:URL = URL(fileURLWithPath: ""), store_name:String = "",  store_address:String = "", store_location:String = "",store_time_weekdays:String = "",store_time_saturday:String = "", store_time_sunday:String = "" ,store_phone_number:String = "" , price_color_double:Int = 0, price_color_single:Int = 0, price_gray_double:Int = 0, price_gray_single:Int = 0, univ_line:Int = 0, store_x_location:Double = 0, store_y_location:Double = 0,store_favorite:Int = 0){
    self.store_image = store_image
    self.store_name = store_name
    self.store_address = store_address
    self.store_location = store_location
    self.store_time_weekdays = store_time_weekdays
    self.store_time_saturday = store_time_saturday
    self.store_time_sunday = store_time_sunday
    self.store_phone_number = store_phone_number
    self.price_color_double = price_color_double
    self.price_color_single = price_color_single
    self.price_gray_double = price_gray_double
    self.price_gray_single = price_gray_single
    self.store_x_location = store_x_location
    self.store_y_location = store_y_location
    self.store_favorite = store_favorite
    self.univ_line = univ_line
  }
}

struct OrderDetailData: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: OrderDetail?
  enum CodingKeys:String, CodingKey {
      case status = "status"
      case success = "success"
      case message = "message"
     case data = "data"
   }
   init(from decoder: Decoder) throws{
     let values = try decoder.container(keyedBy: CodingKeys.self)
     status = (try? values.decode(Int.self, forKey: .status)) ?? -1
     success = (try? values.decode(Bool.self, forKey: .success)) ?? false
     message = (try? values.decode(String.self, forKey: .message)) ?? ""
     data = (try? values.decode(OrderDetail.self, forKey: .data)) ?? nil
     }
}

// MARK: - DataClass
struct OrderDetail: Codable {
    let orderIdx: Int
    let orderStoreName: String
    let orderState: Int
    let orderTime: String
    let orderPrice: Int
    let orderComment: String
    let orderFileList: [OrderFileList]

    enum CodingKeys: String, CodingKey {
        case orderIdx = "order_idx"
        case orderStoreName = "order_store_name"
        case orderState = "order_state"
        case orderTime = "order_time"
        case orderPrice = "order_price"
        case orderComment = "order_comment"
        case orderFileList = "order_file_list"
    }
  
}

// MARK: - OrderFileList
struct OrderFileList: Codable {
    let fileThumbnailPath: URL
    let fileName, fileExtension: String
    let filePrice: Int
    let fileColor: String
    let fileRangeStart, fileRangeEnd: Int
    let fileSidedType, fileDirection: String
    let fileCollect, fileCopyNumber: Int

    enum CodingKeys: String, CodingKey {
        case fileThumbnailPath = "file_thumbnail_path"
        case fileName = "file_name"
        case fileExtension = "file_extension"
        case filePrice = "file_price"
        case fileColor = "file_color"
        case fileRangeStart = "file_range_start"
        case fileRangeEnd = "file_range_end"
        case fileSidedType = "file_sided_type"
        case fileDirection = "file_direction"
        case fileCollect = "file_collect"
        case fileCopyNumber = "file_copy_number"
    }
}
