import Foundation

public struct Punkt {
  public var nazwa: Character
  public var x: Int
  public var y: Int
  public var ilosc_feromonu: Double
}

public struct Auxil {
  public var nazwa: Character
  public var stosunek: Double
}

public class Swiat {
  public var punkty: [Punkt]
  public var aux: [Auxil]
  public var dom: Character
  public var pokarm: Character
  public var punkty_do_wyboru: Int
  public var zanik_feromonu: Double
  let graf: [(Character, Int, Int)] = [
    ("a", 6, 1), ("b", 13, 1), ("c", 4, 3), ("d", 4, 5), ("e", 8, 5),
    ("f", 6, 8), ("g", 10, 8),
  ]

  public init(
    _ dom: Character, _ pokarm: Character, _ punkty_do_wyboru: Int, _ zanik_feromonu: Double
  ) {
    self.dom = dom
    self.pokarm = pokarm
    self.punkty_do_wyboru = punkty_do_wyboru
    self.zanik_feromonu = zanik_feromonu
    self.punkty =
      graf
      .map { (nazwa, x, y) in
        Punkt(nazwa: nazwa, x: x, y: y, ilosc_feromonu: 0.0)
      }
    self.aux = Array(repeating: Auxil(nazwa: "\0", stosunek: 0.0), count: graf.count)
  }

  func pheromoneReset() {
    for i in 0..<punkty.count {
      punkty[i].ilosc_feromonu -= punkty[i].ilosc_feromonu * zanik_feromonu
    }
  }
}

public struct Ant {
  let MAX = 1e6
  public var swiat: Swiat
  public var polozenie: Character
  public var ilosc_wydzielanego_feromonu: Double
  var dlugosc_sciezek: [Int] = []
  var sciezka: String
  var syta = false

  public init(_ swiat: Swiat, _ ilosc_wydzielanego_feromonu: Double) {
    self.swiat = swiat
    self.polozenie = swiat.dom
    self.ilosc_wydzielanego_feromonu = ilosc_wydzielanego_feromonu
    self.sciezka = String(swiat.dom)
  }

  private func obliczOdleglosc() {
    let polozenie = Int(polozenie.asciiValue! - Character("a").asciiValue!)
    let dom = Int(swiat.dom.asciiValue! - Character("a").asciiValue!)
    var dx: Int
    var dy: Int
    for i in 0..<swiat.punkty.count {
      if i == dom || i == polozenie || sciezka.contains(swiat.punkty[i].nazwa) {
        swiat.aux[i].stosunek = MAX
      } else {
        dx =
          swiat.punkty[
            polozenie
          ].x - swiat.punkty[i].x
        dy =
          swiat.punkty[
            polozenie
          ].y - swiat.punkty[i].y
        swiat.aux[i].stosunek = sqrt(Double(dx * dx + dy * dy))
      }
    }
  }

  private func sortujTablicePomocnicza() {
    for i in 0..<swiat.punkty.count {
      swiat.aux[i].stosunek = (swiat.punkty[i].ilosc_feromonu + 1) / swiat.aux[i].stosunek
    }
    swiat.aux.sort(by: { $0.stosunek >= $1.stosunek })
  }

  private func losuj() -> Int {
    return (Int.random(in: 0..<swiat.punkty_do_wyboru))
  }

  private func ruletka() -> Int {
    var pomocnicza = [Double](repeating: 0.0, count: swiat.punkty_do_wyboru)
    var suma = 0.0
    for i in 0..<swiat.punkty_do_wyboru {
      suma += swiat.aux[i].stosunek
    }
    for i in 0..<swiat.punkty_do_wyboru {
      pomocnicza[i] = swiat.aux[i].stosunek / suma
    }
    var i = 0
    let random = Double.random(in: 0.0..<1.0)
    suma = pomocnicza[i]
    while random > suma {
      i += 1
      suma += pomocnicza[i]
    }
    return i
  }

  public func wybierzPunkt() -> Int {
    for i in 0..<swiat.punkty.count {
      swiat.aux[i].nazwa = swiat.punkty[i].nazwa
    }
    obliczOdleglosc()
    sortujTablicePomocnicza()
    var wybor: Int
    var zly_wybor: Bool
    repeat {
      wybor = ruletka()
      zly_wybor = sciezka.contains(swiat.aux[wybor].nazwa)
    } while zly_wybor
    return wybor
  }

  func polejSciezke() {
    for Punkt in sciezka {
      if Punkt != swiat.dom {
        swiat.punkty[
          Int(
            Punkt
              .asciiValue! - Character("a").asciiValue!)
        ].ilosc_feromonu +=
          ilosc_wydzielanego_feromonu
      }
    }
  }

  mutating public func dzialaj() {
    let i = wybierzPunkt()
    if swiat.aux[i].nazwa != swiat.pokarm {
      polozenie = swiat.aux[i].nazwa
      sciezka += String(polozenie)
    } else {
      syta = true
      polozenie = swiat.pokarm
      sciezka += String(polozenie)
      polejSciezke()
      dlugosc_sciezek.append(sciezka.count - 1)
      sciezka = "a"
    }
  }
}

public struct Mrowisko {
  public let LICZBA_MROWEK: Int
  public var mrowki: [Ant]

  public init(_ swiat: Swiat, _ liczba_mrowek: Int, _ pheromone: Double) {
    self.LICZBA_MROWEK = liczba_mrowek
    self.mrowki = Array(repeating: Ant(swiat, pheromone), count: LICZBA_MROWEK)
  }

  public func wszystkieMrowkiSyte() -> Bool {
    var bool = true
    for mrowka in mrowki {
      bool = bool && !mrowka.dlugosc_sciezek.isEmpty
    }
    return bool
  }

  mutating public func move() {
    for i in 0..<LICZBA_MROWEK {
      mrowki[i].dzialaj()
    }
  }
}

var dlugosc_sciezek: [[Int]] = []
print("| pheromone decay | srednia_dlugosc_sciezki |")
print("| :---: | :---: |")
for i in 0...100 {
  for _ in 1...100 {
    let swiat = Swiat(
      "a", "g", 2, 0)
    var anthill = Mrowisko(swiat, 24, 2)
    while !anthill.wszystkieMrowkiSyte() {
      swiat.pheromoneReset()
      anthill.move()
    }
    dlugosc_sciezek.append(anthill.mrowki.map { $0.dlugosc_sciezek }.flatMap { $0 })
  }
  let splaszczone_dlugosci_sciezek = dlugosc_sciezek.flatMap { $0 }
  let srednia_dlugosc_sciezki =
    dlugosc_sciezek.isEmpty
    ? 0
    : Double(splaszczone_dlugosci_sciezek.reduce(0, +)) / Double(splaszczone_dlugosci_sciezek.count)
  print("| 0% | \(srednia_dlugosc_sciezki) |")
}
