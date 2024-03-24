import Foundation

func generateUniqueCharacters(count: Int) -> [Character] {
  var characters: [Character] = []
  let baseScalar = UnicodeScalar("a").value
  for i in 0..<count {
    characters.append(Character(UnicodeScalar(baseScalar + UInt32(i))!))
  }
  return characters
}

func generateRandomValues(count: Int, range: ClosedRange<Int>) -> [Int] {
  return (0..<count).map { _ in Int.random(in: range) }
}

func generateUniqueTuples(count: Int) -> [(Character, Int, Int)] {
  let characters = generateUniqueCharacters(count: count)
  let randomValue1 = generateRandomValues(count: count, range: 0...32)
  let randomValue2 = generateRandomValues(count: count, range: 0...32)
  var tuples: [(Character, Int, Int)] = []
  for i in 0..<count {
    tuples.append((characters[i], randomValue1[i], randomValue2[i]))
  }
  return tuples
}

// Generate 100 tuples with unique characters and random integer values
let CONFIGURATION = generateUniqueTuples(count: 24)
print(CONFIGURATION)

public func averagePathLength(_ anthill: Anthill) -> Double {
  var total_path_length = 0.0
  for ant in anthill.ants {
    total_path_length += Double(ant.path.count) - 1
  }
  return total_path_length / Double(anthill.ANT_COUNT)
}

TextOutputStream.deleteLog()
TextOutputStream.createLog("| ants count | average path length |\n")
TextOutputStream.createLog("| :---: | :---: |\n")
for cycle in 1...1 {
  var average_path_length = 0.0
  let ant_count = Int(pow(2.0, Double(cycle)))
  for _ in 1...100 {
    let random = Int.random(in: 1...23)
    let world = World(
      "a", CONFIGURATION[random].0, 2)
    var anthill = Anthill(world, 64, 8)
    // TextOutputStream.log("### Initial state\n")
    // anthill.printResults()
    // world.printResults()
    var i = 1
    while !anthill.allAntsFull() {
      // TextOutputStream.log("### Cycle \(i)\n")
      anthill.move()
      // anthill.printResults()
      // world.printResults()
      i += 1
    }
    average_path_length += averagePathLength(anthill)
  }
  TextOutputStream.createLog("| \(cycle) | \(average_path_length / 100) |\n")
}
