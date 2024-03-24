public class World {
  public var points: [Point]
  public var aux: [Auxil]
  public var home: Character
  public var food: Character
  public var points_of_choice_count: Int

  public init(
    _ home: Character, _ food: Character, _ points_of_choice_count: Int
  ) {
    self.home = home
    self.food = food
    self.points_of_choice_count = points_of_choice_count
    self.points =
      CONFIGURATION
      .map { (name, x, y) in
        Point(name: name, x: x, y: y, pheromone_value: 0.0)
      }
    self.aux = Array(repeating: Auxil(name: "\0", ratio: 0.0), count: CONFIGURATION.count)
  }

  // func pheromoneReset() {
  //     for i in 0..<points.count {
  //         points[i].pheromone = 0.0
  //     }
  // }

  public func printResults() {
    var str = "\n|"
    for point in points {
      str += " \(point.name) |"
    }
    TextOutputStream.createLog(str + "\n")
    str = "|"
    for _ in points {
      str += " - |"
    }
    TextOutputStream.createLog(str + "\n")
    str = "|"
    for point in points {
      str += " \(point.pheromone_value.rounded()) |"
    }
    TextOutputStream.createLog(str + "\n")
  }
}
