//
//  UISeguesInitializer.swift
//  UISegues
//

import UIKit

public class UISeguesInitializer {
  public init() {
    let expectedClassCount = objc_getClassList(nil, 0)
    let allClasses = UnsafeMutablePointer<AnyClass>.allocate(capacity: Int(expectedClassCount))
    let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(allClasses)
    let actualClassCount:Int32 = objc_getClassList(autoreleasingAllClasses, expectedClassCount)

    for i in 0..<actualClassCount {
      let cls: AnyClass = allClasses[Int(i)]
      if class_conformsToProtocol(cls, UISegues.self) {
        swizzle_prepare(cls)
        swizzle_should(cls)
      }
    }
  }
}


/// Swizzle
private func swizzle_prepare(_ cls: AnyClass) {
  let original = #selector(UIViewController.prepare(for:sender:))
  let swizzled = #selector(UIViewController.sbis_route_prepare(for:sender:))
  swizzle(cls, old: original, new: swizzled)
}

private func swizzle_should(_ cls: AnyClass) {
  let original = #selector(UIViewController.shouldPerformSegue(withIdentifier:sender:))
  let swizzled = #selector(UIViewController.sbis_route_shouldPerformSegue(withIdentifier:sender:))
  swizzle(cls, old: original, new: swizzled)
}

private func swizzle(_ cls: AnyClass, old: Selector, new: Selector) {
  let originalMethod = class_getInstanceMethod(cls, old)!
  let swizzledMethod = class_getInstanceMethod(cls, new)!

  let didAddMethod = class_addMethod(cls, old, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))

  if didAddMethod {
    class_replaceMethod(cls, new, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
  } else {
    method_exchangeImplementations(originalMethod, swizzledMethod)
  }
}

fileprivate extension UIViewController {
  @objc fileprivate func sbis_route_prepare(for segue: UIStoryboardSegue, sender: Any?) {
    self.sbis_route_prepare(for: segue, sender: sender)
    _prepare(for: segue, sender: sender)
  }

  @objc fileprivate func sbis_route_shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    return identifier.isEmpty
  }
}

/// Читерские методы, на которых основан весь SbisSegues
/// По факту все, что тут происходит, это при вызове performSegues мы получаем и возращаем обратно созданный VC
private typealias Configurator = (UIViewController)->()
func _perform<T: UIViewController>(from: UIViewController, identifier: String, type: T.Type) -> T {
  var result: T!
  from.performSegue(withIdentifier: identifier, sender: { result = $0 as! T } as Configurator)
  return result
}

private typealias MakerConfigurator = ()->()
func _perform<T: UIViewController>(from: UIViewController, identifier: String, maker: ()->T) -> T {
  return withoutActuallyEscaping(maker) { maker in
    var result: T!
    from.performSegue(withIdentifier: identifier, sender: { result = maker() } as MakerConfigurator)
    return result
  }
}


func _perform(from: UIViewController, identifier: String, maker: ()->()) {
  return withoutActuallyEscaping(maker) { maker in
    from.performSegue(withIdentifier: identifier, sender: maker as MakerConfigurator)
  }
}

/// Если sender это closure определенного вида, то мы вызываем его
private func _prepare(for segue: UIStoryboardSegue, sender: Any?) {
  if let configurator = sender as? Configurator {
    configurator(segue.destination)
  } else if let makerConfigurator = sender as? MakerConfigurator {
    makerConfigurator()
  }
}
