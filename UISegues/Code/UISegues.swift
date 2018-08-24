//
//  UISegues.swift
//  UISegues
//

import UIKit

/// Специальный переход, который позволяет указать на сторибоарде, что переход будет осуществлен не туда, куда показывает
public class UICustomSegue: UIStoryboardSegue {
  override public func perform() {
    // Nothing
  }
}

@objc
/// Протокол, который должны реализовывать все ViewController-ы которые имеют переходы
public protocol UISegues {}


public extension UISegues where Self: UIViewController {

  /// Функция являющаяся заменой performSegues, но более продвинутой - возращает созданный VC
  ///
  /// - Parameter identifier: Идентификатор перехода на storyboard
  /// - Parameter on: Тип view controller-а на который осуществляется переход
  /// - Returns: возращает созданный view controller
  @discardableResult
  public func doSegue<T: UIViewController>(identifier: String, on: T.Type) -> T {
    return _perform(from: self, identifier: identifier, type: on)
  }

  /// Функция для осуществления кастомного "перехода"
  /// Но перехода на самом деле не будет - все действия для отображения нового VC делаются внутри метода maker
  ///
  /// - Parameters:
  ///   - identifier: идентификатор перехода на storyboard. Должен быть типом SbisCustomSegue
  ///   - maker: метод для создания и добавления VC
  /// - Returns: возвращает созданный VC
  @discardableResult
  public func customSegue<T: UIViewController>(identifier: String, maker: ()->T) -> T {
    return _perform(from: self, identifier: identifier, maker: maker)
  }

  /// Функция для осуществления кастомного "перехода"
  /// Но перехода на самом деле не будет - все действия для отображения нового VC делаются внутри метода maker
  ///
  /// - Parameters:
  ///   - identifier: идентификатор перехода на storyboard. Должен быть типом SbisCustomSegue
  ///   - maker: методя для добавления VC по переходу.
  public func customSegue(identifier: String, maker: ()->()) {
    _perform(from: self, identifier: identifier, maker: maker)
  }
}


public extension UIStoryboard {

  /// Позволяет получить ViewController по его типу
  /// Для работа storyboard id должен быть такойже как имя типа
  ///
  /// - Parameter type: Тип view controller-а
  /// - Returns: Возращает ViewController заданного типа. Если не смог найти, то fatal
  public func instantiateViewController<T: UIViewController>(_ type: T.Type) -> T {
    guard let vc = instantiateViewController(withIdentifier: "\(type)") as? T else {
      fatalError("Can't instantiate view controller by type: \(type)")
    }
    return vc
  }
}


public extension UINavigationController {

  /// Позволяет найти существующий view controller по его типу в стеке
  ///
  /// - Parameter type: Тип view controller-а
  /// - Returns: Возращает view controller или nil если такого нету
  public func find<T>(_ type: T.Type, isReversed: Bool = false) -> T? {
    if isReversed {
      return self.viewControllers.reversed().flatMap{ $0 as? T }.first
    } else {
      return self.viewControllers.flatMap{ $0 as? T }.first
    }
  }
}


public extension UIViewController {

  /// Позволяет найти существующий view controller по его типу в navigation стеке
  ///
  /// - Parameter type: Тип view controller-а
  /// - Returns: Возращает view controller или nil если такого нету
  public func findOnNavigation<T>(_ type: T.Type, isReversed: Bool = false) -> T? {
    let nav = self as? UINavigationController ?? self.navigationController
    return nav?.find(type, isReversed: isReversed)
  }
}
