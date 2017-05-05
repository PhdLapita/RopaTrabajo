//
//  EstadoViewController.swift
//  RopaTrabajo
//
//  Created by Bear on 5/05/17.
//  Copyright © 2017 BearCreeekMining. All rights reserved.
//

import UIKit

class EstadoViewController: UIViewController {
  let bluetoothManager = BTManager.getInstance()
    @IBOutlet weak var imgEstado: UIImageView!
    @IBOutlet weak var btnPrender: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    var contador : Int = 0
    @IBAction func clicPrender(_ sender: UIButton) {
        if(contador == 0){
        bluetoothManager.writePosition("y")
        }else{
        bluetoothManager.writePosition("u")
        }
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
