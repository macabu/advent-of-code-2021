<?php declare(strict_types = 1);

final class Part1 {
    /** @var int[] $lanternFishes */
    private array $lanternFishes;

    public function __construct()
    {
        $this->lanternFishes = [];

        $input = file_get_contents('input.txt');
        $timesToSpawn = explode(',', $input);

        foreach ($timesToSpawn as $t) {
            $this->lanternFishes[] = (int)$t;
        }
    }

    public function __invoke(int $daysToProgress): int
    {
        $lf = $this->lanternFishes;
        for ($i = 0; $i < $daysToProgress; $i++) {
            $lf = $this->progressDay($lf);
        }
        return sizeof($lf);
    }

    private function progressDay(array $lanternFishes): array
    {
        $resulting = [];

        // Naive approach that works for up to 128 progressed days.
        foreach ($lanternFishes as $lf) {
            $new_lf = $lf - 1;
            if ($new_lf == -1) {
                $resulting[] = 6;
                $resulting[] = 8;
            } else {
                $resulting[] = $new_lf;
            }
        }

        return $resulting;
    }
}

final class Part2 {
    /** @var int[] $fishSpawnDistribution */
    private array $fishSpawnDistribution;

    public function __construct()
    {
        $this->fishSpawnDistribution = [0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 0];

        $input = file_get_contents('input.txt');
        $timesToSpawn = explode(',', $input);

        foreach ($timesToSpawn as $t) {
            $this->fishSpawnDistribution[(int)$t] +=1;
        }
    }

    public function __invoke(int $daysToProgress): int
    {
        for ($i = 0; $i < $daysToProgress; $i++) {
            $this->progressDay();
        }

        return $this->totalAmountOfFish();
    }

    private function progressDay(): void
    {
        // Fishes on 0 day will spawn $newSpawns amount of fishes.
        $newSpawns = array_shift($this->fishSpawnDistribution);

        // Reset the spawn timer of fishes who just spawned new ones.
        $this->fishSpawnDistribution[6] += $newSpawns;

        // Add the newly spawned fishes to the end of the array.
        $this->fishSpawnDistribution[] = $newSpawns;
    }

    private function totalAmountOfFish(): int
    {
        $count = 0;

        foreach ($this->fishSpawnDistribution as $lf) {
            $count += $lf;
        }

        return $count;
    }
}

$part1 = new Part1();
print_r(sprintf("Part 1: %d\n", $part1->__invoke(80)));

$part2 = new Part2();
print_r(sprintf("Part 2: %d\n", $part2->__invoke(256)));
