import Foundation

public struct Ant {
  let MAX = 1e6
  public var world: World
  public var position: Character
  public var pheromone_output: Double
  var is_full = false
  var path: String

  public init(_ world: World, _ pheromone_output: Double) {
    self.world = world
    self.position = world.home
    self.pheromone_output = pheromone_output
    self.path = String(world.home)
  }

  private func calculateDistance() {
    let position = Int(position.asciiValue! - Character("a").asciiValue!)
    let home = Int(world.home.asciiValue! - Character("a").asciiValue!)
    var dx: Int
    var dy: Int
    for i in 0..<world.points.count {
      if i == home || i == position || path.contains(world.points[i].name) {
        world.aux[i].ratio = MAX
      } else {
        dx =
          world.points[
            position
          ].x - world.points[i].x
        dy =
          world.points[
            position
          ].y - world.points[i].y
        world.aux[i].ratio = sqrt(Double(dx * dx + dy * dy))
      }
    }
  }

  private func sortAuxil() {
    for i in 0..<world.points.count {
      world.aux[i].ratio = (world.points[i].pheromone_value + 1) / world.aux[i].ratio
      // world.aux[i].ratio =
      //   if world.points[i].pheromone_value == 0
      //     && world.points[Int(position.asciiValue! - Character("a").asciiValue!)].pheromone_value
      //       == 0
      //   {
      //     1 / (world.aux[i].ratio * world.aux[i].ratio)
      //   } else if world.points[Int(position.asciiValue! - Character("a").asciiValue!)]
      //     .pheromone_value
      //     == 0
      //   {
      //     world.points[i].pheromone_value
      //       / world.aux[i].ratio
      //   } else {
      //     world.points[i].pheromone_value
      //       * world.points[Int(position.asciiValue! - Character("a").asciiValue!)].pheromone_value
      //       / (world.aux[i].ratio * world.aux[i].ratio)
      //   }
    }
    world.aux.sort(by: { $0.ratio >= $1.ratio })
  }

  private func draw() -> Int {
    return (Int.random(in: 0..<world.points_of_choice_count))
  }

  private func roulette() -> Int {
    var help = [Double](repeating: 0.0, count: world.points_of_choice_count)
    var sum = 0.0
    for i in 0..<world.points_of_choice_count {
      sum += world.aux[i].ratio
    }
    for i in 0..<world.points_of_choice_count {
      help[i] = world.aux[i].ratio / sum
    }
    var i = 0
    let random = Double.random(in: 0.0..<1.0)
    sum = help[i]
    while random > sum {
      i += 1
      sum += help[i]
    }
    return i
  }

  public func choosePoint() -> Int {
    for i in 0..<world.points.count {
      world.aux[i].name = world.points[i].name
    }
    calculateDistance()
    sortAuxil()
    var choice: Int
    var wrong_choice: Bool
    repeat {
      choice = roulette()
      wrong_choice = path.contains(world.aux[choice].name)
    } while wrong_choice
    return choice
  }

  func markPath() {
    for point in path {
      if point != world.home {
        world.points[
          Int(
            point
              .asciiValue! - Character("a").asciiValue!)
        ].pheromone_value +=
          pheromone_output
      }
    }
  }

  mutating public func act() {
    let i = choosePoint()
    if world.aux[i].name != world.food {
      position = world.aux[i].name
      path += String(position)
    } else {
      is_full = true
      position = world.food
      path += String(position)
      markPath()
    }
  }

  public func printResults(_ i: Int) {
    print(
      "| \(i + 1) | \(is_full ? "yes" : "no") | \(path) | \(path.count) |\n"
    )
  }
}
