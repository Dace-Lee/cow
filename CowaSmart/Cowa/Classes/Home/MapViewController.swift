//
//  MapViewController.swift
//  Cowa
//
//  Created by GJ on 17/1/13.
//  Copyright © 2017年 GJ. All rights reserved.
//

import UIKit
import MapKit
import JZLocationConverter
import GoogleMaps
import DynamicButton

class MapViewController: UIViewController, BMKMapViewDelegate, BMKLocationManagerDelegate{
    
    let bdMapView = BMKMapView()
    let bdLocation = BMKLocationManager.init()
    
    var ggMapView = GMSMapView()
    var bounds:GMSCoordinateBounds?
    
    var updateBtn:UIButton?
    
    var mapSelectBtn:UIButton?
    var mapSelectView:MapSelectView?
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        createUpdateBtn()
        
        createNaviGationBar()
        
        //百度地图设置
        bdMapView.isHidden = false
        bdMapView.frame = CGRect(x:0, y:64, width:self.view.frame.size.width, height:self.view.frame.size.height)
        
        bdLocation.delegate = self
        bdLocation.requestLocation(withReGeocode: true, withNetworkState: true) { (location, state, error) in
            if error != nil {
                
            } else {
                if location != nil {
                    let userLocation = BMKUserLocation.init()
                    userLocation.location = location?.location
                    self.bdMapView.updateLocationData(userLocation)
                }
            }
        }
        
        bdMapView.userTrackingMode = BMKUserTrackingModeFollow
        bdMapView.showsUserLocation = true
        
        let para = BMKLocationViewDisplayParam()
        para.isAccuracyCircleShow = false
        para.isRotateAngleValid = false
        para.locationViewImgName = "bnavi_icon_location_fixed"
        bdMapView.updateLocationView(with: para)
        
        view.addSubview(bdMapView)
        
        //谷歌地图设置
        let camera = GMSCameraPosition.camera(withLatitude: 1.285, longitude: 103.848, zoom: 12)
        ggMapView = GMSMapView.map(withFrame: CGRect(x:0, y:64, width:self.view.frame.size.width, height:self.view.frame.size.height), camera: camera)
        ggMapView.isMyLocationEnabled = true
        ggMapView.isHidden = true
        view.addSubview(ggMapView)

    }
    
    func createNaviGationBar(){
        let btn: DynamicButton? = DynamicButton.init(style: .caretLeft)
        btn?.addTarget(self, action: #selector(leftBtnAction), for: .touchUpInside)
        btn?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btn?.strokeColor = UIColor.white
        let item1=UIBarButtonItem(customView: btn!)
        self.navigationItem.leftBarButtonItem = item1
        
        title = NSLocalizedString("LocationPage", comment: "")
    }
    
    @objc func leftBtnAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func createUpdateBtn(){
        updateBtn = UIButton.init(frame: CGRect(x:0,y:0,width: 25,height: 25))
        updateBtn?.setImage(UIImage(named: "刷新图标"), for: UIControl.State())
        updateBtn!.addTarget(self, action: #selector(update), for: .touchUpInside)
        let item1=UIBarButtonItem(customView: updateBtn!)
        self.navigationItem.rightBarButtonItem = item1
    }
    
    @objc func update(){
        TCowaLocation.locaTool.work()
    }
    
    @objc func createGoogleMap(){
        mapSelectBtn?.isSelected = !(mapSelectBtn?.isSelected)!
        if (mapSelectBtn?.isSelected)! {
            mapSelectView?.isHidden = false
        }else{
            mapSelectView?.isHidden = true
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bdMapView.delegate = self
        
        mapSelectBtn = UIButton.init(type: .custom)
        mapSelectBtn?.isSelected = false
        mapSelectBtn?.frame = CGRect(x:40, y:view.frame.size.height - 91, width:42, height:41)
        mapSelectBtn?.setImage(UIImage(named:"切换按钮—释放"), for: .normal)
        mapSelectBtn?.setImage(UIImage(named:"切换按钮—点击"), for: .selected)
        mapSelectBtn?.addTarget(self, action: #selector(createGoogleMap), for: .touchUpInside)
        UIApplication.shared.keyWindow?.addSubview(mapSelectBtn!)
        
        mapSelectView = Bundle.main.loadNibNamed("MapSelectView", owner: self, options: nil)?.last as? MapSelectView
        mapSelectView!.frame = CGRect(x: 40,y: view.frame.size.height - 194,width: 42,height: 94)
        mapSelectView!.isHidden = true
        UIApplication.shared.keyWindow?.addSubview(mapSelectView!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showDevices), name: NSNotification.Name(rawValue: TCowaLocation.locaTool.kNotiCowaDeviceLocationUpdate), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showBdMap), name: NSNotification.Name(rawValue: "showbdMap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showGgMap), name: NSNotification.Name(rawValue: "showGgMap"), object: nil)
        
        
        TCowaLocation.locaTool.work()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bdMapView.delegate = nil
        
        TCowaLocation.locaTool.work(false)
        
        mapSelectBtn?.removeFromSuperview()
        mapSelectView?.removeFromSuperview()
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    @objc func showGgMap(){
        mapSelectView?.isHidden = true
        mapSelectBtn?.isSelected = false
        
        bdMapView.isHidden = true
        ggMapView.isHidden = false
        
        ggMapView.camera = GMSCameraPosition.camera(withLatitude: (ggMapView.myLocation?.coordinate.latitude)!, longitude: (ggMapView.myLocation?.coordinate.longitude)!, zoom: 12)
        if bounds != nil {
            ggMapView.animate(with: GMSCameraUpdate.fit(bounds!, withPadding: 100))
        }
    }
    
    @objc func showBdMap(){
        mapSelectView?.isHidden = true
        mapSelectBtn?.isSelected = false
        
        bdMapView.isHidden = false
        ggMapView.isHidden = true
        
    }
    
    
    @objc func showDevices() {
        
        
        let all: Array<AnyObject> = bdMapView.annotations as Array<AnyObject>
        if all.count > 0 {
            bdMapView.removeAnnotations(all)
        }
        
        var devicesLoca: [BMKPointAnnotation] = Array()
        
        if TCowaLocation.locaTool.devsLoca.count > 0 {
            
            for (_,aDev) in TCowaLocation.locaTool.devsLoca {
                let lat = Double(aDev.lat)!
                let lon = Double(aDev.lon)!
                let loca = CLLocationCoordinate2DMake(lat, lon)
                
                
                let userLocaAnnotation = BMKPointAnnotation()
                userLocaAnnotation.coordinate = loca
                userLocaAnnotation.title = aDev.name
                devicesLoca.append(userLocaAnnotation)
            }
            
            var upper:CLLocationCoordinate2D = devicesLoca[0].coordinate
            var lower:CLLocationCoordinate2D = devicesLoca[0].coordinate
            
            for item in devicesLoca {
                let eachLoc = item as BMKPointAnnotation
                if eachLoc.coordinate.latitude > upper.latitude {
                    upper.latitude = eachLoc.coordinate.latitude
                }
                if eachLoc.coordinate.latitude < lower.latitude {
                    lower.latitude = eachLoc.coordinate.latitude
                }
                if eachLoc.coordinate.longitude > upper.longitude{
                    upper.longitude = eachLoc.coordinate.longitude
                }
                if eachLoc.coordinate.longitude < lower.longitude{
                    lower.longitude = eachLoc.coordinate.longitude
                }
            }
            
            var locationSpan = BMKCoordinateSpan()
            locationSpan.latitudeDelta = upper.latitude - lower.latitude
            locationSpan.longitudeDelta = upper.longitude - lower.longitude
            
            var locationCenter = CLLocationCoordinate2D()
            locationCenter.latitude = (upper.latitude + lower.latitude) / 2
            locationCenter.longitude = (upper.longitude + lower.longitude) / 2
            
            let region = BMKCoordinateRegion.init(center: locationCenter, span: locationSpan)
            let region1 = bdMapView.regionThatFits(region)
            bdMapView.setRegion(region1, animated: true)
            
            
            bdMapView.addAnnotations(devicesLoca)
            bdMapView.showAnnotations(devicesLoca, animated: true)
        }
        
        
        ggMapView.clear()
        
        if TCowaLocation.locaTool.devsLoca.count > 0 {
            
            bounds = GMSCoordinateBounds()
            
            for (_,aDev) in TCowaLocation.locaTool.devsLoca {
                let lat = Double(aDev.lat)!
                let lon = Double(aDev.lon)!
                let loca = CLLocationCoordinate2DMake(lat, lon)
                
                
                bounds = bounds?.includingCoordinate(loca)
                
                
                let marker = GMSMarker.init(position: loca)
                marker.title = aDev.name
                marker.icon = UIImage(named: "行李")
                marker.map = ggMapView
                
            }
            
            ggMapView.animate(with: GMSCameraUpdate.fit(bounds!, withPadding: 100))
            
        }
        
    }
    
    
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if annotation.isKind(of: BMKPointAnnotation.self){
            
            let annotationView = BMKAnnotationView.init(annotation: annotation, reuseIdentifier: "myanotation")
            annotationView?.image = UIImage(named: "行李")
            return annotationView
        }
        
        return nil
    }
    
}
