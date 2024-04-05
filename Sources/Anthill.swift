public struct Anthill {
  public let ANT_COUNT: Int
  public var ants: [Ant]

  public init(_ world: World, _ ant_count: Int, _ pheromone: Double) {
    self.ANT_COUNT = ant_count
    self.ants = Array(repeating: Ant(world, pheromone), count: ANT_COUNT)
  }

  public func allAntsFull() -> Bool {
    var bool = true
    for ant in ants {
      bool = bool && ant.is_full
    }
    return bool
  }

  mutating public func move() {
    for i in 0..<ANT_COUNT {
      if !ants[i].is_full { ants[i].act() }
    }
  }

  public func printResults() {
    print(
      """
      | ant | full | path | path length |
      | :--- | :--- | :--- | :--- |\n
      """)
    for i in 0..<ANT_COUNT {
      ants[i].printResults(i)
    }
  }
}
