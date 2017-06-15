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

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    var contador : Int = 0
    
    @IBAction func clicSubir(_ sender: UIButton) {
         bluetoothManager.writePosition("1")
         print("1")
    }
    
    @IBAction func clicBajar(_ sender: UIButton) {
         bluetoothManager.writePosition("0")
         print("0")
    }
    
    @IBAction func clicPlay(_ sender: UIButton) {
         bluetoothManager.writePosition("4")
         print("4")
    }
    
    @IBAction func clicCambiarSentido(_ sender: UIButton) {
         bluetoothManager.writePosition("3")
         print("3")
    }
    
    @IBAction func clicPause(_ sender: UIButton) {
         bluetoothManager.writePosition("2")
         print("2")
    }
    
   /* @IBAction func clicPrender(_ sender: UIButton) {
        if(contador == 0){
        bluetoothManager.writePosition("y")
        }else{
        bluetoothManager.writePosition("u")
        }
        }
    
*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
