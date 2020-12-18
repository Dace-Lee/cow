//
//  UpdateVC.swift
//  Cowa
//
//  Created by gaojun on 2017/8/28.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit
import SVProgressHUD

class UpdateVC: UIViewController, URLSessionDownloadDelegate{

    var versionUrl = ""
    
    var idx:Int = 0
    var endSend = false
 
    var fileData = NSMutableData()
    
    var filePath = ""
    var timer = Timer()
    
    @IBOutlet weak var updatingLabel: UILabel!
    @IBOutlet weak var comfirmBtn: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addListener()
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }
    
    func addListener(){
        NotificationCenter.default.addObserver(self, selector: #selector(sendFileDataWithData), name: NSNotification.Name(rawValue: "hasReceiveData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cancelUpdate), name: NSNotification.Name(rawValue: "cancelUpdate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sendLastData), name: NSNotification.Name(rawValue: "aplySendDataAgain"), object: nil)
    }
    
    func configUI(){
        self.title = "UPDATE BOX"
        updatingLabel.text = NSLocalizedString("UpdatingAvoid", comment: "")
        comfirmBtn.setTitle(NSLocalizedString("UpdateComfirm", comment: ""), for: UIControl.State())
    }
    
    @objc func cancelUpdate(){
        SVProgressHUD.dismiss()
        MyInfoTool.tool.showInView(supView: self.view, title: "升级失败")
        
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: filePath)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        TBLEManager.sharedManager.dev?.status.isUpdating = false
        NotificationCenter.default.post(name: Notification.Name(rawValue: "stopUpdateFile"), object: nil)
        WatchDog.dog.start()
        
        let time = DispatchTime.now() + Double(Int64(1 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            
            _ = self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    @IBAction func comfirmBtnAction(_ sender: AnyObject) {
        
        SVProgressHUD.show(withStatus: "正在升级")
        
        comfirmBtn.isUserInteractionEnabled = false
        endSend = false
        idx = 0;
   
        downLoadFileWithType()
        
    }
    
    func downLoadFileWithType(){

        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        let downloadtask = session.downloadTask(with: URL.init(string: versionUrl)!)
        downloadtask.resume()

    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        //拼接文件路径
        let documentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentPath = documentPaths[0]
        filePath = documentPath + "/r1"

        let fileManager = FileManager.default

        do {
            try fileManager.copyItem(at: location, to: URL.init(fileURLWithPath: filePath))
        } catch let error as NSError{
            print("Could not copy file to disk:\(error.localizedDescription)")
        }

        do {
            try fileData = NSMutableData.init(contentsOfFile: filePath)
        } catch {
            print("fileData Empty")
        }

        //print(fileData)

        NotificationCenter.default.post(name: Notification.Name(rawValue: "startUpdateFile"), object: nil)
        WatchDog.dog.stop()

        let time = DispatchTime.now() + Double(Int64(1 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            
            if let md5 = self.md5File(url: NSURL.init(string: self.filePath)! as URL){
                TBLEManager.sharedManager.dev?.status.isUpdating = true
                TBLEManager.sharedManager.dev?.status.sendPreData(self.fileData as Data!, md5Str: md5)
                
                self.updateProgress()
            }
            
        }
        

    }
    
    func updateProgress(){
        
        if self.timer.isValid == false {
            self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateIdx), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc func updateIdx(){
        let str = NSString(format: "%.2f", Float(idx) / Float(fileData.length))
        let p = str.floatValue
        progressView.progress = p
    }
    
    
    @objc func sendFileDataWithData(){
       
        
        if endSend {
            print("传输结束")
            SVProgressHUD.dismiss()
            TBLEManager.sharedManager.dev?.status.isUpdating = false
            MyInfoTool.tool.showInView(supView: self.view, title: "升级成功")
            
            let time = DispatchTime.now() + Double(Int64(1 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: time) {
                
                HomeControllerVC.updateFinish = true
                _ = self.navigationController?.popViewController(animated: true)

            }
            
            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(atPath: filePath)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            
        }else{
            
            let dataLen = fileData.length
            var count = 0
            
            var oneData = Data()
            if dataLen - idx > 100 || dataLen - idx == 100 {
                count = 100
                oneData = Data.init(bytes: fileData.bytes + idx, count: count)
                //发送数据
                sendDataTimesWithData(oneData)
                idx += count
            }else if 0 < dataLen - idx && dataLen - idx < 100 {
                count = dataLen - idx
                oneData = Data.init(bytes: fileData.bytes + idx, count: count)
                //发送数据
                sendDataTimesWithData(oneData)
                idx += count
            }else if dataLen - idx <= 0 {
                idx = 0
                endSend = true
                //发送结束指令
                sendEOT()
            }
        }
    }
    
    //分包发送数据
    func sendDataTimesWithData(_ data:Data){
        //发送数据
        let dev = TBLEManager.sharedManager.dev
        dev?.status.send(data)
        
    }
    
    //发送结束指令
    func sendEOT(){
        //发送数据
        let dev = TBLEManager.sharedManager.dev
        dev?.status.sendETO()
        
    }
    
    //发送上一次数据
    @objc func sendLastData(){
        //发送数据
        let dev = TBLEManager.sharedManager.dev
        dev?.status.sendLastData()
        
    }
    
    func md5File(url: URL) -> String? {
        
        let bufferSize = 1024 * 1024
        
        do {
            //打开文件
            let file = try FileHandle(forReadingFrom: url)
            defer {
                file.closeFile()
            }
            
            //初始化内容
            var context = CC_MD5_CTX()
            CC_MD5_Init(&context)
            
            //读取文件信息
            while case let data = file.readData(ofLength: bufferSize), data.count > 0 {
                data.withUnsafeBytes {
                    _ = CC_MD5_Update(&context, $0, CC_LONG(data.count))
                }
            }
            
            //计算Md5摘要
            var digest = Data(count: Int(CC_MD5_DIGEST_LENGTH))
            digest.withUnsafeMutableBytes {
                _ = CC_MD5_Final($0, &context)
            }
            
            return digest.map { String(format: "%02hhx", $0) }.joined()
            
        } catch {
            print("Cannot open file:", error.localizedDescription)
            return nil
        }
    }
    

}
