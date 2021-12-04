import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Scanner;
import java.util.Stack;
import java.util.stream.Collectors;
import java.util.stream.Stream;

class Board {
    private int[][] numbersInBoard;
    private int[][] markedCellsInBoard;

    public Board(int[][] board) {
        this.numbersInBoard = Stream.of(board).map(int[]::clone).toArray(int[][]::new);
        this.markedCellsInBoard = new int[5][5];
    }

    private List<Integer> findCellForNumber(int number) {
        for (int i = 0; i < 5; i++) {
            for (int j = 0; j < 5; j++) {
                if (number == this.numbersInBoard[i][j]) {
                    return Arrays.asList(i, j);
                }
            }
        }

        return null;
    }

    private List<Integer> getUnmarkedNumbers() {
        List<Integer> unmarkedNumbers = new ArrayList<Integer>();

        for (int i = 0; i < 5; i++) {
            for (int j = 0; j < 5; j++) {
                if (this.markedCellsInBoard[i][j] == 0) {
                    unmarkedNumbers.add(this.numbersInBoard[i][j]);
                }
            }
        }

        return unmarkedNumbers;
    }

    public int sumAllUnmarkedNumbers() {
        List<Integer> unmarkedNumbers = this.getUnmarkedNumbers();

        return unmarkedNumbers.stream().reduce(0, Integer::sum);
    }

    public boolean hasWon() {
        for (int i = 0; i < 5; i++) {
            int count = 0;
            for (int j = 0; j < 5; j++) {
                count += this.markedCellsInBoard[i][j];
            }
            if (count == 5) {
                return true;
            }
        }

        for (int i = 0; i < 5; i++) {
            int count = 0;
            for (int j = 0; j < 5; j++) {
                count += this.markedCellsInBoard[j][i];
            }
            if (count == 5) {
                return true;
            }
        }

        return false;
    }

    public void markNumber(int number) {
        List<Integer> cells = this.findCellForNumber(number);
        if (cells == null) {
            return;
        }

        int row = cells.get(0);
        int col = cells.get(1);

        this.markedCellsInBoard[row][col] = 1;
    }
}

class Game {
    private Stack<Integer> draws;
    private List<Board> boards;

    public Game(Stack<Integer> draws, List<Board> boards) {
        this.draws = draws;
        this.boards = boards;
    }

    public Stack<Integer> getDraws() {
        return this.draws;
    }

    public List<Board> getBoards() {
        return this.boards;
    }
}

class Main {
    public static Game generateDrawsAndBoards() {
        File fd = new File("input.txt");

        Stack<Integer> draws = new Stack<Integer>();

        List<Board> boards = new ArrayList<Board>();

        try {
            Scanner sc = new Scanner(fd);
            sc.useDelimiter("\n");

            Stream.of(sc.next().split(","))
                    .map(Integer::parseInt)
                    .collect(Collectors.toCollection(ArrayDeque::new))
                    .descendingIterator()
                    .forEachRemaining(draws::add);

            // skip empty lines
            sc.nextLine();
            sc.nextLine();

            int i = 0, j = 0;
            int[][] board = new int[5][5];

            while (sc.hasNextLine()) {
                String nextLine = sc.nextLine();

                if (nextLine.length() <= 1) {
                    boards.add(new Board(Stream.of(board).map(int[]::clone).toArray(int[][]::new)));
                    i = j = 0;
                    continue;
                }

                for (String n : nextLine.split(" ")) {
                    if (n == "") {
                        continue;
                    }

                    board[i][j] = Integer.parseInt(n);
                    j++;
                }
                i++;
                j = 0;
            }

            sc.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
            return null;
        }

        return new Game(draws, boards);
    }

    public static void partOne() {
        Game g = generateDrawsAndBoards();
        if (g == null) {
            return;
        }

        Stack<Integer> draws = g.getDraws();
        List<Board> boards = g.getBoards();

        out: while (!draws.isEmpty()) {
            int drawedNumber = draws.pop();

            for (Board b : boards) {
                b.markNumber(drawedNumber);

                if (b.hasWon()) {
                    int finalScore = drawedNumber * b.sumAllUnmarkedNumbers();

                    System.out.println("Final Score = " + finalScore);
                    break out;
                }
            }
        }
    }

    public static void partTwo() {
        Game g = generateDrawsAndBoards();
        if (g == null) {
            return;
        }

        Stack<Integer> draws = g.getDraws();
        List<Board> boards = g.getBoards();

        HashSet<Board> winners = new HashSet<Board>();
        int finalScore = 0;

        while (!draws.isEmpty()) {
            int drawedNumber = draws.pop();

            for (Board b : boards) {
                if (winners.contains(b)) {
                    continue;
                }

                b.markNumber(drawedNumber);

                if (b.hasWon()) {
                    winners.add(b);

                    finalScore = drawedNumber * b.sumAllUnmarkedNumbers();
                }
            }
        }

        System.out.println("Last Final Score = " + finalScore);
    }

    public static void main(String[] args) {
        partOne();
        partTwo();
    }
}
