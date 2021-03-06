//
//  DownloadViewController.swift
//  FreeboxClient
//
//  Created by Romain Hild on 28/10/2014.
//  Copyright (c) 2014 Romain Hild. All rights reserved.
//

import UIKit

class DownloadViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {

    @IBOutlet weak var downloadTableView: UITableView!
    
    var free: Freebox?
    var sessionToken : String?
    var api: APIController!
    var downloads = [Download]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIController(token: self.sessionToken!, delegate: self)
        api.downloads()
        var nib = UINib(nibName: "DownloadCell", bundle: nil)
        downloadTableView.registerNib(nib, forCellReuseIdentifier: "downloadCell")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloads.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = downloadTableView.dequeueReusableCellWithIdentifier("downloadCell") as DownloadCell
        let dl = downloads[indexPath.row]
        cell.initDownload(dl)
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dl = downloads[indexPath.row]
        performSegueWithIdentifier("toDetailView", sender: self)
    }
    
    func didReceiveAPIResults(jsonResults: NSDictionary, id_cmd: Int) {
        switch id_cmd {
        case 0:
            if jsonResults["success"] as Bool == true {
                let results = jsonResults["result"] as Array<Dictionary<String,AnyObject>>
                downloads = Download.DownloadsWithArray(results)
                downloadTableView.reloadData()
            }
        default:
            println("command unknown")
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var detailVC = segue.destinationViewController as DetailDownloadViewController
        detailVC.dl = downloads[downloadTableView.indexPathForSelectedRow()!.row]
    }

}
