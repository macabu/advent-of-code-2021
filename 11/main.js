const fs = require('fs')

const input = fs.readFileSync('input.txt', 'utf8')
  .split('\n')
  .map(line => line.split('').map(energyLevel => Number(energyLevel)))

const findAdjacent = (table, i, j) => {
  const ret = []

  if (table?.[i-1]?.[j]) ret.push({i: i-1, j: j})
  if (table?.[i]?.[j-1]) ret.push({i: i, j: j-1})
  if (table?.[i]?.[j+1]) ret.push({i: i, j: j+1})
  if (table?.[i+1]?.[j]) ret.push({i: i+1, j: j})
  if (table?.[i+1]?.[j+1]) ret.push({i: i+1, j: j+1})
  if (table?.[i-1]?.[j-1]) ret.push({i: i-1, j: j-1})
  if (table?.[i-1]?.[j+1]) ret.push({i: i-1, j: j+1})
  if (table?.[i+1]?.[j-1]) ret.push({i: i+1, j: j-1})

  return ret
}

const increaseAllEnergyLevel = (table, amount = 1) =>
  table.map(row => row.map(cell => cell + amount))

const propagateFlash = (table, flashed = []) => {
  const newTable = [...table.map(row => [...row])]

  for (i = 0; i < table.length; i++) {
    for (j = 0; j < table.length; j++) {
      if (table[i][j] > 9) {
        newTable[i][j] = 0

        flashed.push({ i, j })

        const adj = findAdjacent(table, i, j)
        for (const coords of adj) {
          const {i: adj_i, j: adj_j} = coords

          const hasFlashed = !!flashed.find(({i: fi, j: fj}) => fi === adj_i && fj === adj_j)
          if (!hasFlashed) {
            newTable[adj_i][adj_j] += 1
          }
        }
      }
    }
  }

  return [newTable, flashed]
}

const doStep = (table, flashed = []) => {
  let shouldFlash = !!table.find(row => row.find(cell => cell > 9))
  if (shouldFlash) {
    const [newTable, newFlashed] = propagateFlash(table, flashed)
    return doStep(newTable, newFlashed)
  }

  return [table, flashed.length]
}

const partOne = (input, iter = 10, count = 0) => {
  if (iter === 0) {
    return [input, count]
  }

  const increased = increaseAllEnergyLevel(input, 1)
  const step = doStep(increased)

  return partOne(step[0], iter - 1, count + step[1])
}

const partTwo = (input, iter = 10, count = 0) => {
  if (iter === 0) {
    return [input, count]
  }

  const increased = increaseAllEnergyLevel(input, 1)
  const step = doStep(increased)
  
  if (step[1] === 100) {
    return [input, iter - 1]
  }

  return partTwo(step[0], iter - 1, count + step[1])
}

console.log(`Part One: ${partOne(input, 100, 0)[1]}`)
console.log(`Part Two: ${1000-partTwo(input, 1000, 0)[1]}`)
