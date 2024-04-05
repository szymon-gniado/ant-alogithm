import Foundation

let pheromone_output = 0.25

extension Double {
  func rounded(toPlaces places: Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
}

func calculateStandardError(_ path_lengths: [Double]) -> Double {
  sqrt(
    path_lengths.map {
      pow($0 - path_lengths.reduce(0, +) / Double(path_lengths.count), 2)
    }.reduce(0.0, +) / (Double(path_lengths.count) - 1.0)) / sqrt(Double(path_lengths.count))
}

TextOutputStream.deleteLog()
TextOutputStream.createLog(
  "| ants count | pheromone output | possible points of choice | average path length | standard error |\n"
)
TextOutputStream.createLog("| :---: | :---: | :---: | :---: | :---: |\n")
for choice in 2...4 {
  for pheromone in 1...8 {
    for ant in 1...24 {
      var path_length: [Double] = []
      for _ in 1...100 {
        let world = World(
          "a", "g", choice)
        var anthill = Anthill(world, ant, pheromone_output * Double(pheromone))
        // print("### Initial state\n")
        // anthill.printResults()
        // world.printResults()
        // var i = 1
        while !anthill.allAntsFull() {
          anthill.move()
          // print("### Cycle \(i)\n")
          // anthill.printResults()
          // world.printResults()
          // i += 1
        }
        path_length += anthill.ants.map { Double($0.path.count) }
      }
      TextOutputStream.createLog(
        "| \(ant) | \((Double(pheromone) * pheromone_output).rounded(toPlaces: 3)) | \(choice) | \((path_length.reduce(0, +) / Double(path_length.count) - 1).rounded(toPlaces: 3)) | \(calculateStandardError(path_length).rounded(toPlaces: 3)) |\n"
      )
    }
  }
}
