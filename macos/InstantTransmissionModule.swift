import Foundation



@objc(InstantTransmissionModule)
class InstantTransmissionModule: NSObject {
  
  @objc func getName() { // Assume name comes from the any native API side
//    successCallback(["SWIFT native Module"])
    print("hi");
  }
}
